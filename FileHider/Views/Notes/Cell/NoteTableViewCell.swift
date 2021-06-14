//
//  NoteTableViewCell.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 4.06.2021.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var highlightIndicator: UIView!
    @IBOutlet weak var lockImage: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        
       
        titleLabel.clipsToBounds = true
        noteLabel.clipsToBounds = true
        colorView.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
