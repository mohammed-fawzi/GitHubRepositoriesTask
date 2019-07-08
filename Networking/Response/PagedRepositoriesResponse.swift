//
//  PagedRepositoriesResponse.swift
//  RepositoriesTask
//
//  Created by mohamed fawzy on 8July//2019.
//  Copyright © 2019 mohamed fawzy. All rights reserved.
//

import Foundation

struct PagedRepositoriesResponse: Decodable {
    let repositories: [Repository]
    //let total: Int
    let hasMore: Bool
    //let page: Int
}
