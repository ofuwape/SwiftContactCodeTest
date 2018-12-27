//
//  UpdateContactViewController+UITableViewDataSource.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/26/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension UpdateContactViewController: UITableViewDataSource{
    
    func getPlaceHolders( section: Int) -> [String] {
        switch section {
        case UpdateSectionType.PhoneNum.rawValue:
            return ["Add Phone Number"]
        case UpdateSectionType.Email.rawValue:
            return ["Add Email"]
        case UpdateSectionType.Address.rawValue:
            return ["Add Address"]
        case UpdateSectionType.DOB.rawValue:
            return ["Add BirthDate"]
        default:
            return []
        }
    }
    
    func getCellTextList( section: Int) -> [String] {
        switch section {
        case UpdateSectionType.Name.rawValue:
            return [self.contactVM.firstname ,self.contactVM.lastname]
        case UpdateSectionType.PhoneNum.rawValue:
            return self.contactVM.phoneNumbers
        case UpdateSectionType.Email.rawValue:
            return self.contactVM.emails
        case UpdateSectionType.Address.rawValue:
            return self.contactVM.addresses
        case UpdateSectionType.DOB.rawValue:
            return [contactVM.dOB]
        default:
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows: Int = 0
        switch section {
        case UpdateSectionType.Name.rawValue:
            numRows = 2
            break
        case UpdateSectionType.PhoneNum.rawValue:
            numRows = (self.contactVM.phoneNumbers.count)+1
            break
        case UpdateSectionType.Email.rawValue:
            numRows = (self.contactVM.emails.count)+1
            break
        case UpdateSectionType.Address.rawValue:
            numRows = (self.contactVM.addresses.count)+1
            break
        case UpdateSectionType.DOB.rawValue:
            numRows = 1
            break
        default:
            break
        }
        return numRows
    }
    
    func clearCell(cell: UpdateCellView){
        cell.clearImage()
        cell.textField.text = ""
        cell.textField.placeholder = ""
        cell.isUserInteractionEnabled = true
    }
    
    func listenToTextField(cell: UpdateCellView, indexPath: IndexPath){
        cell.textField.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe({ _ in
                print("editing state changed section ->"+String(indexPath.section)+" ->"+String(indexPath.row))
            })
            .disposed(by: cell.disposeBag)
    }
    
    func configureCell(cell: UpdateCellView, indexPath: IndexPath) {
        let placeHolderText: [String] = getPlaceHolders(section: indexPath.section)
        let cellText: [String] = getCellTextList(section: indexPath.section)
        listenToTextField(cell: cell, indexPath: indexPath)
        if indexPath.section == UpdateSectionType.Name.rawValue {
            let currentCellText: String = cellText[indexPath.row]
            if cellText.isEmpty{
                cell.textField.placeholder = currentCellText
            }else{
                cell.textField?.text = cellText[indexPath.row]
            }
        }else{
            if indexPath.row >= cellText.count{
                cell.textField.placeholder = placeHolderText[0]
                cell.textField.isUserInteractionEnabled = false
                cell.setAddImage()
            }else{
                cell.textField.text = cellText[indexPath.row]
                cell.setRemoveImage()
                cell.textField.isUserInteractionEnabled = !(indexPath.section == UpdateSectionType.DOB.rawValue)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UpdateCellView!
        cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UpdateCellView
        cell.prepareForReuse()
        cell.selectionStyle = .none
        clearCell(cell: cell)
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return "    "
    }
    
}
