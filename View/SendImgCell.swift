//
//  SendImgCell.swift
//  RealTimeChatApp
//
//  Created by abdurhman elbosaty on 26/09/2021.
//

import UIKit

class SendImgCell: UITableViewCell {

    @IBOutlet weak var imgMessage: UIImageView!{
        didSet{
            imgMessage.layer.cornerRadius = 25
        }
    }
    @IBOutlet weak var dateLbl: UILabel!
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
