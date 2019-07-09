//
//  RepositoriesViewModel.swift
//  RepositoriesTask
//
//  Created by mohamed fawzy on 8July//2019.
//  Copyright © 2019 mohamed fawzy. All rights reserved.
//

import Foundation

protocol RepositoriesViewModelDelegate: class {
    func fetchCompleted(currentPageNumber: Int, totalNumberOfPages: Int)
    func fetchFailed(with reason: String)
}

final class RepositoriesViewModel {
    
    //MARK:- Variables
    private weak var delegate: RepositoriesViewModelDelegate?
    
    private var repositories: [Repository] = []
    private var currentPage = 1
    private var isFetchInProgress = false
    var hasMoreToFetch = true
    
    
    let client = GitHubClient()
    let request: GetRepositoriesRequest

    //MARK:- computed properties
   
    var currentCount: Int {
        return repositories.count
    }
    
    func repository(at index: Int) -> Repository {
        return repositories[index]
    }
    
    
    
    //MARK:- methods
    init(request: GetRepositoriesRequest, delegate: RepositoriesViewModelDelegate) {
        self.request = request
        self.delegate = delegate
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
                    print("failure")
                    self.isFetchInProgress = false
                    self.repositories = CoreDataManager.shared.fetchAllRepositories()
                    self.delegate?.fetchFailed(with: error.reason)
                }
            
            case .success(let response):
                DispatchQueue.main.async {
                    
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    self.hasMoreToFetch = response.hasMore
                    self.repositories.append(contentsOf: response.repositories)
                    CoreDataManager.shared.saveRepositories(response.repositories)
                    
                    self.delegate?.fetchCompleted(currentPageNumber: self.currentPage - 1,
                                                  totalNumberOfPages: self.client.totalNumberOfPages)
                }
            }
        }
    }
    
    
    func refresh(){
        repositories = []
        hasMoreToFetch = true
        currentPage = 1
        fetchModerators()
    }
    
}

