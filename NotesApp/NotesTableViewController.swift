//
//  ViewController.swift
//  NotesApp
//
//  Created by Anastasia Markovets on 08.12.2018.
//  Copyright © 2018 Lonely Tree Std. All rights reserved.
//

import UIKit

class NotesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var notesTableView: UITableView!
    
    let alamofireHelper = AlamofireHelper()
    let dataHelper = DataHelper()
    let alertHelper = AlertHelper()
    
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            self.notesTableView.refreshControl = refreshControl
        } else {
            self.notesTableView.backgroundView = refreshControl
        }
        
        let noteNib = UINib(nibName: "NoteCell", bundle: nil)
        self.notesTableView.register(noteNib, forCellReuseIdentifier: "noteCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.alamofireHelper.get(success: { (notesValue, size) in
            
            self.notes = notesValue
            self.notesTableView.reloadData()
            if self.dataHelper.isSizeBigger(size: size) {
                self.present(self.alertHelper.errorMessage(message: "The size of ypur notes is too big. Please remofe unnecessary notes."), animated: true, completion: nil)
            }
        
        }) { (error) in
            self.present(self.alertHelper.errorMessage(message: error), animated: true, completion: nil)
        }
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        self.alamofireHelper.get(success: { (noteValue, size) in
            self.notes = noteValue
            self.notesTableView.reloadData()
            refreshControl.endRefreshing()
            
            if self.dataHelper.isSizeBigger(size: size) {
                self.present(self.alertHelper.errorMessage(message: "The size of ypur notes is too big. Please remofe unnecessary notes."), animated: true, completion: nil)
            }
        }) { (error) in
            self.present(self.alertHelper.errorMessage(message: error), animated: true, completion: nil)
        }
    }
    
    @IBAction func addNote(_ sender: Any) {
        self.performSegue(withIdentifier: "addNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destanationVC = segue.destination as? AddingNoteViewController {
            destanationVC.notes = notes
            destanationVC.index = sender as? Int
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "addNote", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
        cell.titleLabel.text = self.notes[indexPath.row].title
        cell.desctiptionLabel.text = self.notes[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.notes.remove(at: indexPath.row)
            self.notesTableView.deleteRows(at: [indexPath], with: .automatic)
            self.alamofireHelper.put(params: ["notes" : self.dataHelper.prepareDictionary(notes: self.notes)], success: {}) { (error) in
            self.present(self.alertHelper.errorMessage(message: error), animated: true, completion: nil)
            }
        }
    }
}

