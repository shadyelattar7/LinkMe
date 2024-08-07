//
//  BoxCell.swift
//  Link-Me
//
//  Created by Al-attar on 29/06/2023.
//

import UIKit



class SupportCell: UITableViewCell {

    @IBOutlet weak var seenView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var titleStatus_lbl: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var subTitle_lbl: UILabel!
//    @IBOutlet weak var descripation_tv: UITextView!
    
    @IBOutlet weak var descripation_tv: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func configure(data: TicketsData, source: SupportEnum){
        switch source{
        case .box:
            print("box")
            if data.is_read == 1{ //unread
                seenView.isHidden = false
            }else{
                seenView.isHidden = true
            }
            
            statusView.isHidden = true
            
            let creationDate = Date.dateFromString2(string: data.created_at ?? "")
            date_lbl.text = creationDate?.timeAgoDisplay()
            userImage.image = UIImage(named: "Group 62757")
            title_lbl.text = "Support".localized
            subTitle_lbl.text = data.email ?? ""
            descripation_tv.text = data.replies?.first?.reply ?? ""
            
        case .sent:
            print("sent")
            seenView.isHidden = true
            statusView.isHidden = false
            userImage.getImage(imageUrl: UDHelper.fetchUserData?.imagePath ?? "")
            title_lbl.text = "Sent"
            
            
            let creationDate = Date.dateFromString2(string: data.created_at ?? "")
            date_lbl.text = creationDate?.timeAgoDisplay()
            
            subTitle_lbl.text = data.title ?? ""
            descripation_tv.text = data.description ?? ""
            
            
            if data.status == "pending"{
                statusView.backgroundColor = UIColor.LinkMeUIColor.lightOrang
                titleStatus_lbl.textColor = UIColor.LinkMeUIColor.strongOrang
            }else{
                statusView.backgroundColor = UIColor.LinkMeUIColor.lightRepliedGreen
                titleStatus_lbl.textColor = UIColor.LinkMeUIColor.strongRepliedGreen
            }
            
            titleStatus_lbl.text = data.status
            
        }
        
    }
    
}
