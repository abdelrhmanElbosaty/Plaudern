//
//  SendedMessageCell.swift
//  RealTimeChatApp
//
//  Created by abdurhman elbosaty on 19/09/2021.
//

import UIKit

class SendedMessageCell: UITableViewCell {
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var userProfileImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
