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


extension RepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.repositoryCell.rawValue, for: indexPath) as! RepositoryCell
        let repo = viewModel.repository(at: indexPath.row)
        if let repoName = repo.name {
            cell.configure(withName: repoName)
        }
        
        return cell
    }
    
    
}

extension RepositoriesViewController: UITableViewDelegate {
    
}

extension RepositoriesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    
}

extension RepositoriesViewController: RepositoriesViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        tableView.reloadData()
    }
    
    func onFetchFailed(with reason: String) {
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
    
    
}

extension RepositoriesViewController {
    
}

