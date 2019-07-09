//
//  ViewController.swift
//  RepositoriesTask
//
//  Created by mohamed fawzy on 8July//2019.
//  Copyright © 2019 mohamed fawzy. All rights reserved.
//

import UIKit

class RepositoriesViewController: UIViewController, AlertDisplayer{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progrssBar: UIProgressView!
    
    private var viewModel: RepositoriesViewModel!
    private let refreshControl = UIRefreshControl()
    fileprivate func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRefreshControl()
        let request = GetRepositoriesRequest(forPageNumber: 1)
        viewModel = RepositoriesViewModel(request: request, delegate: self)
        viewModel.fetchModerators()
    }
    
    
    @objc func refresh(sender:AnyObject) {
        viewModel.refresh()
    }

  
}



//MARK:- Table view Data Source
extension RepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.repositoryCell.rawValue, for: indexPath) as! RepositoryCell
        
        
        if indexPath.row == viewModel.currentCount - 3 && viewModel.hasMoreToFetch {
            print("fetching")
            viewModel.fetchModerators()
        }
        
        let repo = viewModel.repository(at: indexPath.row)
        if let repoName = repo.name {
        cell.configure(withName: repoName)
        }
        
        return cell
    }
    
    
}


//MARK:-  View Model Delegate
extension RepositoriesViewController: RepositoriesViewModelDelegate {
    func fetchCompleted(currentPageNumber: Int, totalNumberOfPages: Int) {
        let progress = Float(currentPageNumber)/Float(totalNumberOfPages)
        print(currentPageNumber)
        print(totalNumberOfPages)
        print(progress)
        progrssBar.setProgress(progress, animated: true)
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
  
    
    func fetchFailed(with reason: String) {
        refreshControl.endRefreshing()
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        let message = reason + " your offline data will be represented you can pull down at the top to refresh your content"
        displayAlert(with: title , message: message, actions: [action])
        viewModel.hasMoreToFetch = false
        tableView.reloadData()
    }
    
    
}


