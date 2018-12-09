//
//  AlamofireHelper.swift
//  NotesApp
//
//  Created by Anastasia Markovets on 08.12.2018.
//  Copyright © 2018 Lonely Tree Std. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireHelper: NSObject {
    
    let alertHelper = AlertHelper()
    
    let header = [
        "Content-Type" : "application/json; charset=utf-8"
    ]
    
    func get(success: @escaping ([Note], Data) -> (), failure: @escaping (String) -> ()) {
        Alamofire.request(NOTES_URL, method: .get, encoding: JSONEncoding.default, headers: header).validate().responseJSON { (res) in
            switch res.result {
            case .success:
                var sizeOfNodes = Data()
                if let size = res.data {
                    sizeOfNodes = size
                }
                if let value = res.result.value as? [String : Any] {
                    if let notesValue = value["notes"] as? [[String : Any]] {
                        var notes = [Note]()
                        for i in 0 ..< notesValue.count {
                            let note = Note()
                            
                            guard let text = notesValue[i]["text"] as? String else { return }
                            guard let title = notesValue[i]["title"] as? String else { return }

                            note.text = text
                            note.title = title
                            
                            notes.append(note)
                        }
 
                        success(notes, sizeOfNodes)
                    }
                    
                } else {
                    failure("No data was found.")
                }
            case .failure:
                let message = res.error!.localizedDescription
                failure(message)
            }
        }
    }
    
    func put(params: [String : Any], success: @escaping () -> (), failure: @escaping (String) -> ()) {

        Alamofire.request(NOTES_URL, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).validate().responseString { (res) in
            print(res)
            switch res.result {
            case .success:
                success()
            case .failure:
                let message = res.error!.localizedDescription
                failure(message)
            }
        }
    }

}
