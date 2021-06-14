//
//  CircleImage.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 14.06.2021.
//

import Foundation
import UIKit

class CircleImage: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addCornerRadius(radius: frame.height / 2)
    }
}

class SquareView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addCornerRadius(radius: 12)
    }
}
