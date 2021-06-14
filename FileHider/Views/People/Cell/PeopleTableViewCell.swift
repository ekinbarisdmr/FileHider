//
//  PeopleTableViewCell.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 4.06.2021.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var avatarName: UILabel!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var highlightIndicator: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()

        colorView.layer.cornerRadius = 20
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.layer.cornerRadius = avatarImage.frame.size.height / 2
        avatarName.textColor = UIColor.jaguarColor()
        avatarName.sizeToFit()
        avatarName.numberOfLines = 0
        avatarName.adjustsFontSizeToFitWidth = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
