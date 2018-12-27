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
    let numOfSections: Int = 5 // Name, PhoneNums, Emails, Address, Birthday
    let cellIdentifier = "UpdateCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        contactModel = contactModel.fromContactViewModel(contactVM: contactVM)
        initialContactVM = contactVM
        
        setupViewResizerOnKeyboardShown()
        updateContactView?.updateContactTableView.delegate = self
        updateContactView?.updateContactTableView.dataSource = self
        updateContactView?.updateContactTableView.register(UINib(nibName: "UpdateCellView", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        configureDetailView()
        configureButtons()
    }
    
    func configureSaveStatus(){
        let enableSave = !contactVM.isSame(newContactVM: initialContactVM) && contactVM.hasRequiredData()
        self.navigationItem.rightBarButtonItem?.isEnabled = enableSave
    }
    
    func configureButtons(){
        self.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(exitPage)), animated: true)
         self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveContact)), animated: true)
    }
    
    @objc func saveContact(){
        
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
    
}

extension UpdateContactViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 55.0
    }
}

enum UpdateSectionType : Int {
    case Name = 0
    case PhoneNum = 1
    case Email = 2
    case DOB = 3
    case Address = 4
}
