//
//  RepositoryTableViewCell.swift
//  SearchGitHub
//
//  Created by Mahalakshmi Raveenthiran on 02/07/21.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var repoView: UIView!
    
    @IBOutlet weak var repoAvatar: UIImageView!
    
    @IBOutlet weak var repoFullName: UILabel!
    
    @IBOutlet weak var repoOwnerLogin: UILabel!
    
    @IBOutlet weak var repoDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
