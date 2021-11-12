//
//  UsersCell.swift
//  RealTimeChatApp
//
//  Created by abdurhman elbosaty on 12/09/2021.
//

import UIKit

class UsersCell: UITableViewCell {

    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var userFullname: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
