//
//  String + Extention.swift
//  RepositoriesTask
//
//  Created by mohamed fawzy on 8July//2019.
//  Copyright © 2019 mohamed fawzy. All rights reserved.
//

import Foundation

extension String {
    func subString(WithPattern pattern: String)-> String?{
        let range = NSRange(location: 0, length: self.count)
        
        if let regex = try? NSRegularExpression(pattern: pattern),
            let match = regex.firstMatch(in: self, options: [], range: range){
            return (self as NSString).substring(with: match.range)
        }else {
            return nil
        }
  
    }
}
