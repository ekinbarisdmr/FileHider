//
//  PhotosCollectionViewCell.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 4.06.2021.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectIndicator: UIImageView!
    @IBOutlet weak var highlightIndicator: UIView!
    @IBOutlet weak var lockImage: UIImageView!
    
    
    override var isHighlighted: Bool {
        didSet {
            highlightIndicator.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highlightIndicator.isHidden = !isSelected
            selectIndicator.isHidden = !isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setups()
    }
    
    func setups() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.selectiveYellow().cgColor
        imageView.layer.borderWidth = 1.5
    }
}
