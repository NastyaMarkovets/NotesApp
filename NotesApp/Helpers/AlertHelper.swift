//
//  AlertHelper.swift
//  NotesApp
//
//  Created by Anastasia Markovets on 09.12.2018.
//  Copyright © 2018 Lonely Tree Std. All rights reserved.
//

import UIKit

class AlertHelper: NSObject {
    func errorMessage(message: String) -> UIAlertController {
        let alertMessage = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertMessage.addAction(ok)
        return alertMessage
    }
}
