//
//  GetRepositoriesRequest.swift
//  RepositoriesTask
//
//  Created by mohamed fawzy on 8July//2019.
//  Copyright © 2019 mohamed fawzy. All rights reserved.
//

import Foundation

class GetRepositoriesRequest {
     var resourceName = "repos"
     var queires = [String:String]()
    
    init(forPageNumber number: Int) {
        queires["page"] = number.description
        queires["per_page"] = "15"
    }
    
    func updateQueiry(forKey key: String, withValue value: Int){
        queires[key] = value.description
    }
    
}
