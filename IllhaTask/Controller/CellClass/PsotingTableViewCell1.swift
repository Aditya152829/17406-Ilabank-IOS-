//
//  PsotingTableViewCell1.swift
//  IllhaTask
//
//  Created by A1502 on 23/08/21.
//

import UIKit


class PsotingTableViewCell3: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func prepareLayout(objDashboard:PostModel?) {
        lblTitle.text = objDashboard?.title?.capitalized
        let randomNumber = Int.random(in: 0...4)
        let imagesArr = ["user","user1","user2","user3","user4"]
        imgUser.image = UIImage(named: imagesArr[randomNumber])
        
    }
    
    
}
