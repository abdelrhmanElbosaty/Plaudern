//
//  RecentsChatRoomCell.swift
//  RealTimeChatApp
//
//  Created by abdurhman elbosaty on 30/09/2021.
//

import UIKit

class RecentsChatRoomCell: UITableViewCell {

    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userMsgLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var containerViewForCounter: UIView!{
        didSet{
            containerViewForCounter.layer.cornerRadius = containerViewForCounter.frame.width / 2
        }
    }
    @IBOutlet weak var counterLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(){
        
        
        
        
        
    }

}
