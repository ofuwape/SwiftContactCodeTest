//
//  UpdateContactViewController+UITableViewDelegate.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/27/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import Foundation
import UIKit

extension UpdateContactViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        datePicker.isHidden = true
        if (indexPath.section == UpdateSectionType.PhoneNum.rawValue && indexPath.row == contactVM.phoneNumbers.count) {
            contactVM.phoneNumbers.append("")
            addNewRow(nextIndex: contactVM.phoneNumbers.count-1, section: indexPath.section)
        } else if (indexPath.section == UpdateSectionType.Email.rawValue && indexPath.row == contactVM.emails.count){
            contactVM.emails.append("")
            addNewRow(nextIndex: contactVM.emails.count-1, section: indexPath.section)
        } else if (indexPath.section == UpdateSectionType.Address.rawValue && indexPath.row == contactVM.addresses.count){
            contactVM.addresses.append("")
            addNewRow(nextIndex: contactVM.addresses.count-1, section: indexPath.section)
        } else if (indexPath.section == UpdateSectionType.DOB.rawValue){
            datePicker.isHidden = false
            self.view.endEditing(true)
        }else if (indexPath.section == UpdateSectionType.DeleteContact.rawValue){
            confirmDeleteContact()
        }
    }
    
}
