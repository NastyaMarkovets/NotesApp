//
//  AddingNoteViewController.swift
//  NotesApp
//
//  Created by Anastasia Markovets on 08.12.2018.
//  Copyright © 2018 Lonely Tree Std. All rights reserved.
//

import UIKit

class AddingNoteViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var textTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let alamofireHelper = AlamofireHelper()
    let dataHelper = DataHelper()
    let alertHelper = AlertHelper()
    
    var notes = [Note]()
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillDisappear), name: .UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillAppear), name: .UIKeyboardWillShow, object: nil)
        
        self.titleTextView.delegate = self
        self.textTextView.delegate = self
        
        if let indexPath = self.index {
            self.titleTextView.text = notes[indexPath].title
            self.textTextView.text = notes[indexPath].text
            
        } else {
            self.titleTextView.text = "Enter the text..."
            self.titleTextView.textColor = UIColor.lightGray
            self.textTextView.text = "Enter the text..."
            self.textTextView.textColor = UIColor.lightGray
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)

    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        
        self.adjustingHeight(show: true, notification: notification)

    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        
        self.adjustingHeight(show: false, notification: notification)

    }
    
    func adjustingHeight(show: Bool, notification: NSNotification) {
        if self.bottomConstraint.constant > 6 && show {
            return
        }
        var userInfo = notification.userInfo!
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = CGFloat(271.0) * (show ? 1 : -1)
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.bottomConstraint.constant += changeInHeight
        })
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black

        } else if textView.textColor == UIColor.red {
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter the text..."
            textView.textColor = UIColor.lightGray

        }
    }

    @IBAction func saveNote(_ sender: Any) {

        let note = Note()
        if self.titleTextView.text != "Enter the text...", self.titleTextView.text != "" {
            if self.titleTextView.text.count <= 250 {
                note.title = self.titleTextView.text

            } else {
                self.titleTextView.textColor = UIColor.red
                return
            }
        } else {
            self.titleTextView.textColor = UIColor.red
            return
        }
        
        if self.textTextView.text != "Enter the text..." {
            if self.textTextView.text.count <= 1000 {
                note.text = self.textTextView.text
            } else {
                self.textTextView.textColor = UIColor.red
                return
            }
        } else {
            note.text = ""
        }
        
        if index != nil {
            self.notes.remove(at: index!)
        }
        self.notes.append(note)
    
        self.alamofireHelper.put(params: ["notes" : self.dataHelper.prepareDictionary(notes: self.notes)], success: {
            let message = UIAlertController(title: "Your note", message: "Success creating.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            })
            message.addAction(ok)
            self.present(message, animated: true, completion: nil)
        }) { (error) in
            self.present(self.alertHelper.errorMessage(message: error), animated: true, completion: nil)
        }
        
        
    }
    

    
}
