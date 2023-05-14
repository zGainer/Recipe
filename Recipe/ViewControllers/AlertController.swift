//
//  AlertController.swift
//  Recipe
//
//  Created by Eugene on 12.05.23.
//

import UIKit

extension UIAlertController {
    
    func createAlert(withTitle title: String, andMessage message: String = "", buttonTitle: String = "Cancel") -> UIAlertController {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: buttonTitle, style: .cancel)
        
        alert.addAction(cancel)
        
        return alert
    }
}
