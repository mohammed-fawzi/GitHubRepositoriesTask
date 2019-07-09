//
//  Repository.swift
//  RepositoriesTask
//
//  Created by mohamed fawzy on 8July//2019.
//  Copyright © 2019 mohamed fawzy. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    
    let id: Int
    let name: String?
    let description: String?
    let url: URL?
    
    
    enum CodingKeys: String, CodingKey {
        case id,name,description
        case url = "html_url"
    }
    
    init(fromCDRepository repo: CDRepository) {
        self.id = Int(repo.id)
        self.name = repo.name
        self.description = repo.repoDescription
        self.url = URL(string: repo.url ?? "")
        
    }
}
