//
//  RepositoryCell.swift
//  RepositoriesTask
//
//  Created by mohamed fawzy on 8July//2019.
//  Copyright © 2019 mohamed fawzy. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {
    
    @IBOutlet weak var repoName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        repoName.text = nil
    }
    
    
    func configure(withName name: String){
        repoName.text = name
    }
    

}
