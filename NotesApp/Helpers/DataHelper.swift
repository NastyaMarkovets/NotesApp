//
//  DataHelper.swift
//  NotesApp
//
//  Created by Anastasia Markovets on 08.12.2018.
//  Copyright © 2018 Lonely Tree Std. All rights reserved.
//

import UIKit

class DataHelper: NSObject {

    func prepareDictionary(notes: [Note]) -> [[String : Any]] {
        
        var dict = [[String : Any]]()
        
        for i in 0 ..< notes.count {
            let noteValue: [String : Any] = ["text" : notes[i].text!, "title" : notes[i].title!]
            dict.append(noteValue)
        }
        return dict
    }
    
    func isSizeBigger(size: Data) -> Bool {
        let mbSize: Double = Double(size.count) / 1024.0 / 1024.0
        
        if mbSize >= 1.5 {
            return true
        }
        return false
    }
    
}
