//
//  HTTPURLResponse + extention.swift
//  RepositoriesTask
//
//  Created by mohamed fawzy on 8July//2019.
//  Copyright © 2019 mohamed fawzy. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
