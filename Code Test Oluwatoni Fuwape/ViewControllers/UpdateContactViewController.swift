//
//  UpdateContactViewController.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/24/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class UpdateContactViewController: KeyboardListenerVC{
    
    var updateContactView: UpdateContactView?
    var contactVM: ContactViewModel = ContactViewModel(){
        didSet {
            configureSaveStatus()
        }
    }
    var contactModel: Contact = Contact()
    var initialContactVM: ContactViewModel = ContactViewModel()
    let numOfSections: Int = 6 // Name, PhoneNums, Emails, Address, Birthday
    let cellIdentifier = "UpdateCell"
    let deleteCellIdentifier = "DeleteCell"
    var isNewContact: Bool = false
    let realmUtil: RealmUtils = RealmUtils()

    override func viewDidLoad() {
        super.viewDidLoad()
        contactModel = contactModel.fromContactViewModel(contactVM: contactVM)
        initialContactVM = contactVM
        
        setupViewResizerOnKeyboardShown()
        updateContactView?.updateContactTableView.delegate = self
        updateContactView?.updateContactTableView.dataSource = self
        updateContactView?.updateContactTableView.register(UINib(nibName: "UpdateCellView", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        updateContactView?.updateContactTableView.register(UITableViewCell.self, forCellReuseIdentifier: deleteCellIdentifier)
        
        configureDetailView()
        configureButtons()
        if isNewContact{
            self.title = "New Contact"
        }
    }
    
    func configureSaveStatus(){
        let enableSave = !contactVM.isSame(newContactVM: initialContactVM) && contactVM.hasRequiredData()
        self.navigationItem.rightBarButtonItem?.isEnabled = enableSave
    }
    
    func configureButtons(){
        self.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(exitPage)), animated: true)
         self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveContact)), animated: true)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func saveContact(){
        realmUtil.saveItem(contactVM: contactVM, delegate: self)
    }
    
    func confirmDeleteContact(){
        let deleteAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        deleteAlert.addAction(UIAlertAction(title: "Delete Contact", style: .destructive, handler: { (action: UIAlertAction!) in
            self.deleteContact()
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    func deleteContact(){
        realmUtil.deleteItem(id: contactVM.primaryKey, delegate: self)
    }
    
    @objc func exitPage(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func loadView() {
        self.updateContactView = UpdateContactView.fromNib()
        self.view = self.updateContactView
    }
    
    func configureDetailView(){
        configureDoneButton()
        updateContactView?.updateContactTableView.reloadData()
        updateContactView?.updateContactTableView.tableFooterView = UIView() // remove empty cells
    }
    
    func configureDoneButton(){
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveContactData)), animated: true)
    }
    
    @objc func saveContactData(){
        // implement
    }
    
    func addNewRow(nextIndex: Int, section: Int){
        updateContactView?.updateContactTableView.reloadSections(IndexSet([section]), with: .automatic)
    }
    
    func removeRow(currentIndex: Int, section: Int){
        var shouldUpdateSection: Bool = true
        
        switch section {
        case UpdateSectionType.PhoneNum.rawValue:
            contactVM.phoneNumbers.remove(at: currentIndex)
            break
        case UpdateSectionType.Email.rawValue:
            contactVM.emails.remove(at: currentIndex)
            break
        case UpdateSectionType.Address.rawValue:
            contactVM.addresses.remove(at: currentIndex)
            break
        default:
            shouldUpdateSection = false
            break
        }
        if shouldUpdateSection{
            updateContactView?.updateContactTableView.reloadSections(IndexSet([section]), with: .automatic)
        }
    }
    
}

enum UpdateSectionType : Int {
    case Name = 0
    case PhoneNum = 1
    case Email = 2
    case DOB = 3
    case Address = 4
    case DeleteContact = 5
}

extension UpdateContactViewController: RealmUtilSaveDeleteDelegate{
    func deleteComplete() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveComplete() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
