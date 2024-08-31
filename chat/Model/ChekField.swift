//
//  ChekField.swift
//  chat
//
//  Created by Гидаят Джанаева on 14.07.2024.
//

import UIKit

class ChekField {
    
    static let shared = ChekField()
    init() { }
 
    private func isValid(_ type: String, _ data: String) -> Bool {
        var dataRegEx = ""
        switch type {
        case "e":
            dataRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        default:
            dataRegEx = "(?=.*[A-Z0-9a-z]).{6,}"
        }
        let dataPred = NSPredicate(format:"SELF MATCHES %@", dataRegEx)
        return dataPred.evaluate(with: data)
    }
    
    func validField( _ field: UITextField) -> Bool {
        let id = field.restorationIdentifier
        
        switch id {
        case "name":
            if field.text?.count ?? 0 < 3 {
                validView(field, false)
                return false
            } else {
                validView(field, true)
                return true
            }
        case "email":
            if isValid("e", field.text!) {
                validView(field, true)
                return true
            } else {
                validView(field, false)
                return false
            }
        case "password":
            if isValid("p", field.text!) {
                validView(field, true)
                return true
            } else {
                validView(field, false)
                return false
            }
        default:
            if field.text?.count ?? 0 < 2 {
                validView(field, false)
                return false
            } else {
                validView(field, true)
                return true
            }
        }
    }

    func validView(_ field: UITextField, _ valid: Bool) {
        if valid{
            field.layer.borderColor = UIColor(named: "One")?.cgColor

        } else {
            field.layer.borderColor = UIColor.red.cgColor

        }
    }
    

}

