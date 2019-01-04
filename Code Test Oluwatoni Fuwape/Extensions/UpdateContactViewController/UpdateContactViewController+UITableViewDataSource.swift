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
        case UpdateSectionType.Name.rawValue:
            return ["FirstName","LastName"]
        case UpdateSectionType.PhoneNum.rawValue:
            return ["Phone Number"]
        case UpdateSectionType.Email.rawValue:
            return ["Email"]
        case UpdateSectionType.Address.rawValue:
            return ["Address"]
        case UpdateSectionType.DOB.rawValue:
            return ["Pick BirthDate"]
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
        case UpdateSectionType.DOB.rawValue:
            return ["Delete Contact"]
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
        case UpdateSectionType.DeleteContact.rawValue:
            numRows =  isNewContact ? 0 : 1
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
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe({ _ in
                self.updateContactField(text: cell.textField.text ?? "",indexPath: indexPath)
            })
            .disposed(by: cell.disposeBag)
        
        cell.textField.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe({ _ in
                self.toggleDatePicker(show: false)
            })
            .disposed(by: cell.disposeBag)
    }
    
    func listenToDelete(cell: UpdateCellView, indexPath: IndexPath){
        let tapGest = UITapGestureRecognizer()
        cell.buttonImageView.addGestureRecognizer(tapGest)
        tapGest.rx.event
            .asObservable()
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe({_ in
                self.removeRow(currentIndex: indexPath.row, section: indexPath.section)
                self.toggleDatePicker(show: false)
            })
            .disposed(by: cell.disposeBag)
    }
    
    func updateContactField(text: String, indexPath: IndexPath){
        switch indexPath.section {
        case UpdateSectionType.Name.rawValue:
            if indexPath.row == 0{
                contactVM.firstname = text
            }else{
                contactVM.lastname = text
            }
            break
        case UpdateSectionType.PhoneNum.rawValue:
            contactVM.phoneNumbers[indexPath.row] = text
            break
        case UpdateSectionType.Email.rawValue:
            contactVM.emails[indexPath.row] = text
            break
        case UpdateSectionType.Address.rawValue:
            contactVM.addresses[indexPath.row] = text
            break
        default:
            break
        }
    }
    
    func configureCellKeyboard(cell: UpdateCellView, section: Int){
        switch section {
        case UpdateSectionType.Name.rawValue:
            cell.textField.keyboardType = .namePhonePad
            break
        case UpdateSectionType.Email.rawValue:
            cell.textField.keyboardType = .emailAddress
            break
        case UpdateSectionType.PhoneNum.rawValue:
            cell.textField.keyboardType = .phonePad
            break
        default:
            cell.textField.keyboardType = .default
            break
        }
    }
    
    func configureCell(cell: UpdateCellView, indexPath: IndexPath) {
        let placeHolderText: [String] = getPlaceHolders(section: indexPath.section)
        let cellText: [String] = getCellTextList(section: indexPath.section)
       
        
        cell.textField.placeholder = placeHolderText[0]
        if indexPath.row >= cellText.count{
            cell.textField.isUserInteractionEnabled = false
            cell.textField.placeholder = "Add "+placeHolderText[0]
            cell.setAddImage()
        }else{
            let currentCellText: String = cellText[indexPath.row]
            if !currentCellText.isEmpty{
                cell.textField.text = currentCellText
            }
            if indexPath.section != UpdateSectionType.DOB.rawValue {
                cell.setRemoveImage()
                cell.buttonImageView.accessibilityIdentifier = "DeleteRowSection_"+String(indexPath.section)
            }
            if indexPath.section == UpdateSectionType.Name.rawValue {
                cell.textField.placeholder = placeHolderText[indexPath.row]
                cell.clearImage()
            }
            cell.textField.isUserInteractionEnabled = !(indexPath.section == UpdateSectionType.DOB.rawValue)
        }
        
        
        listenToTextField(cell: cell, indexPath: indexPath)
        listenToDelete(cell: cell, indexPath: indexPath)
        configureCellKeyboard(cell: cell, section: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == UpdateSectionType.DeleteContact.rawValue {
            var cell : UITableViewCell!
            cell = tableView.dequeueReusableCell(withIdentifier: deleteCellIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: deleteCellIdentifier)
            }
            cell.textLabel?.textColor = UIColor.red
            cell.textLabel?.text = "Delete Contact"
            cell.textLabel?.textAlignment = .center
            return cell
        }else{
            var cell : UpdateCellView!
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UpdateCellView
            cell.selectionStyle = .none
            clearCell(cell: cell)
            configureCell(cell: cell, indexPath: indexPath)
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return " "
    }
    
}
