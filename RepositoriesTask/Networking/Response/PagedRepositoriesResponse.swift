//
//  PagedRepositoriesResponse.swift
//  RepositoriesTask
//
//  Created by mohamed fawzy on 8July//2019.
//  Copyright © 2019 mohamed fawzy. All rights reserved.
//

import Foundation

struct PagedRepositoriesResponse {
    let repositories: [Repository]
    var hasMore: Bool
    
    init(repositories: [Repository]) {
        self.repositories = repositories
        hasMore = true
    }
}
