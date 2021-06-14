//
//  AddNoteViewController.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 4.06.2021.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    var notes = [Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        notes = StoreManager.shared.getNote()
        titleTextField.layer.cornerRadius = 16
        noteTextField.layer.cornerRadius = 16
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save Note", style: .done, target: self, action: #selector(addNote))
        
    }
    
    func setupTextFields() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                         target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        noteTextField.inputAccessoryView = toolbar
        titleTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }

    @objc func addNote() {
        
        if let title = titleTextField.text, let note = noteTextField.text {
            
            let newNote = Notes(note: note, title: title)
            notes.insert(newNote, at: 0)
            StoreManager.shared.saveNote(data: notes)
            self.navigationController?.popViewController(animated: true)
            
        }
    }
}
