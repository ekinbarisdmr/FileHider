//
//  AddPeopleViewController.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 4.06.2021.
//

import UIKit

class AddPeopleViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var people = [People]()
    var selectedImage: UIImage?
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationbar()
        setupTextFields()
        people = StoreManager.shared.getPeople()
        avatarImage.layer.cornerRadius = avatarImage.frame.size.height / 2
        avatarImage.contentMode = .scaleAspectFill
        addButton.layer.cornerRadius = 20
        imageButton.layer.cornerRadius = 20
        
    }
    
    func setupTextFields() {
        
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        nameTextField.inputAccessoryView = toolbar
        numberTextField.inputAccessoryView = toolbar
        mailTextField.inputAccessoryView = toolbar
        
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    func setupNavigationbar() {
        
        self.navigationItem.title = "Add Person"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.selectiveYellow()]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.selectiveYellow()]
        self.navigationController?.navigationBar.tintColor = UIColor.selectiveYellow()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.jaguarColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationController?.setStatusBar(backgroundColor: UIColor.jaguarColor())
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @IBAction func imageButton(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: {_ in self.openCamera()
            
        }))
        
        alertController.addAction(UIAlertAction.init(title: "Gallery", style: .default, handler: {_ in
            self.openGallery()
        }))
        
        alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        imagePicker.delegate = self
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func addButton(_ sender:Any) {
        
        if let name = nameTextField.text, let mail = mailTextField.text, let number = numberTextField.text, let image = selectedImage {
            
            let newPerson = People(name: name, number: number, mail: mail, img: image)
            people.insert(newPerson, at: 0)
            StoreManager.shared.savePeople(data: people)
            self.navigationController?.popViewController(animated: true)
            
        }
    }
}

extension AddPeopleViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        
        self.selectedImage = image
        avatarImage.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func openCamera() {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        else {
            
            Alerts.show(inViewController: self, title: "Error!", message: "Camera doesnt' turn on.")
        }
    }
    
    @objc func openGallery() {
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
    }
}

