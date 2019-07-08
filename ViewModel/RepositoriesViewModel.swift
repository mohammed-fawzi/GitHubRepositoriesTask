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

final class RepositoriesViewModel {
    private weak var delegate: RepositoriesViewModelDelegate?
    
    private var repositories: [Repository] = []
    private var currentPage = 1
    private var total = 30
    private var isFetchInProgress = false
    var hasMoreToFetch = true
    
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
        
        guard !isFetchInProgress || hasMoreToFetch else {
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
                    
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    self.hasMoreToFetch = response.hasMore
                    self.repositories.append(contentsOf: response.repositories)
                    
                    if response.page > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.repositories)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    // This utility calculates the index paths for the last page of repositories received from the API
    // used  to refresh only the content that's changed, instead of reloading the whole table view.
    private func calculateIndexPathsToReload(from newRepositories: [Repository]) -> [IndexPath] {
        let startIndex = repositories.count - newRepositories.count
        let endIndex = startIndex + newRepositories.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

