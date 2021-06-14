//
//  NoteDetailsViewController.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 4.06.2021.
//

import UIKit

class NoteDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var saveNote: UIButton!
    
    var notes = [Notes]()
    var row = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = StoreManager.shared.getNote()
        setupTextViews()
        get()
        titleTextView.layer.cornerRadius = 20
        noteTextView.layer.cornerRadius = 20
        saveNote.layer.cornerRadius = 20
        
    }
    
    func get() {
        
        if let title = notes[row].title, let note = notes[row].note {
            titleTextView.text = title
            noteTextView.text = note
        }
    }
    
    func setupTextViews() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                         target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        titleTextView.inputAccessoryView = toolbar
        noteTextView.inputAccessoryView = toolbar

    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    @IBAction func saveNote(_ sender:Any) {
        
        if let title = titleTextView.text, let note = noteTextView.text {
            notes[row].title = title
            notes[row].note = note
            StoreManager.shared.saveNote(data: notes)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
