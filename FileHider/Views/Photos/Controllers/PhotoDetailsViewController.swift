//
//  AddPhotoViewController.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 4.06.2021.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        saveButton.layer.cornerRadius = 10
        view.backgroundColor = UIColor.jaguarColor()
                
    }
    
    func setupNavigationController() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.selectiveYellow()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationController?.setStatusBar(backgroundColor: UIColor.clear)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        if let selectedImage = image {
            UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
