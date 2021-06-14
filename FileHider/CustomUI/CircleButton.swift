//
//  CircleButton.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 13.06.2021.
//

import Foundation
import UIKit


class CircleButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setTitle(self.tag.toString, for: .normal)
        titleLabel?.font = UIFont.helveticaBold(size: 30)
        addCornerRadius(radius: frame.height / 2)
        backgroundColor = UIColor.selectiveYellow()
    }
}

class CircleView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addCornerRadius(radius: frame.height / 2)
        border(borderWidth: 2, borderColor: UIColor.jaguarColor().cgColor)
        
    }

}



