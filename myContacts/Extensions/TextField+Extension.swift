//
//  TextField+Extension.swift
//  myContacts
//
//  Created by konstantine on 25.03.23.
//

import Foundation
import UIKit


extension UITextField {
    func formatPhone() -> String{
        let currentText = self.text   // 9
        
        var formattedText = ""
        let length = currentText!.count  //9
        
        for i in 0..<length {
            if i == 3 || i == 6 {
                formattedText += "-"
            } else {
                formattedText += currentText ?? ""
            }
           
        }
        return formattedText
    }
    
}
