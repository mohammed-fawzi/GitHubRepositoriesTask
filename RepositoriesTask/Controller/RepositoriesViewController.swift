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
    
    private var viewModel: RepositoriesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let request = GetRepositoriesRequest(forPageNumber: 1)
        viewModel = RepositoriesViewModel(request: request, delegate: self)
        viewModel.fetchModerators()
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
    func fetchCompleted() {
        
        tableView.reloadData()
 
    }
    
    func fetchFailed(with reason: String) {
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
        print("fffffff")
        viewModel.hasMoreToFetch = false
        tableView.reloadData()
    }
    
    
}


