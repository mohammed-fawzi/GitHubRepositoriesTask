//
//  RepositoriesViewModel.swift
//  RepositoriesTask
//
//  Created by mohamed fawzy on 8July//2019.
//  Copyright © 2019 mohamed fawzy. All rights reserved.
//

import Foundation

protocol RepositoriesViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class ModeratorsViewModel {
    private weak var delegate: RepositoriesViewModelDelegate?
    
    private var repositories: [Repository] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    let client = GitHubClient()
    let request: GetRepositoriesRequest
    
    init(request: GetRepositoriesRequest, delegate: RepositoriesViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return repositories.count
    }
    
    func repository(at index: Int) -> Repository {
        return repositories[index]
    }
    
    func fetchModerators() {
        
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        client.fetchRepositories(withRequest: request, page: currentPage) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            
            case .success(let response):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.repositories.append(contentsOf: response.repositories)
                    self.delegate?.onFetchCompleted(with: .none)
                }
            }
        }
    }
}

