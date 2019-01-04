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
    static let tablelIdentifier = "UpdateTableId"
    var isNewContact: Bool = false
    let realmUtil: RealmUtils = RealmUtils()
    let datePicker: UIDatePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        if isNewContact{
            contactVM.primaryKey = NSUUID().uuidString
        }
        contactModel = contactModel.fromContactViewModel(contactVM: contactVM)
        initialContactVM = contactVM
        
        setupViewResizerOnKeyboardShown()
        updateContactView?.updateContactTableView.delegate = self
        updateContactView?.updateContactTableView.dataSource = self
        updateContactView?.updateContactTableView.accessibilityIdentifier = UpdateContactViewController.tablelIdentifier
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
    
    func configureDatePicker(){
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(dateChanged), for: UIControl.Event.valueChanged)
        
        let screenBounds = UIScreen.main.bounds
        let pickerHeight: CGFloat = 250.0
        datePicker.frame = CGRect.init(x: screenBounds.minX, y: screenBounds.height-pickerHeight, width: screenBounds.width, height: pickerHeight)
        
        datePicker.isHidden = true
        datePicker.backgroundColor = UIColor.gray
        if !isNewContact{
            datePicker.date = RealmUtils.stringToDate(dateText: contactVM.dOB)
        }
        self.view.addSubview(datePicker)
    }
    
    
    func toggleDatePicker(show: Bool){
        UIView.animate(withDuration: 0.2, animations: {
            self.updateContactView?.tableViewBottomConstraint.constant = show ? 250.0 : 0.0
            self.datePicker.isHidden = !show
            self.updateContactView?.layoutIfNeeded()
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func dateChanged(){
        contactVM.dOB = ContactViewModel.dateToString(date: datePicker.date)
        updateContactView?.updateContactTableView.reloadSections(IndexSet([UpdateSectionType.DOB.rawValue]), with: .automatic)
        
    }
    
    @objc func saveContact(){
        realmUtil.saveItem(contactVM: contactVM, delegate: self, isNew: isNewContact)
    }
    
    func confirmDeleteContact(){
        
        let deleteAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        deleteAlert.addAction(UIAlertAction(title: "Delete Contact", style: .destructive, handler: { (action: UIAlertAction!) in
            self.deleteContact()
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        if let mainView = self.updateContactView{
            let popPresenter = deleteAlert.popoverPresentationController
            popPresenter?.sourceView = mainView
            popPresenter?.sourceRect = CGRect(x: mainView.bounds.midX, y: mainView.bounds.midY, width: 0, height: 0)
            popPresenter?.permittedArrowDirections = []
            present(deleteAlert, animated: true, completion: nil)
        }
    
        
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
        configureDatePicker()
        updateContactView?.updateContactTableView.reloadData()
        updateContactView?.updateContactTableView.tableFooterView = UIView() // remove empty cells
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
        let parentController = self.parent?.presentingViewController as? UINavigationController
        self.dismiss(animated: true, completion: nil)
        if let parent = parentController{
            parent.popViewController(animated: true)
        }
    }
    
    func saveComplete() {
        self.dismiss(animated: true, completion: nil)
        let parentController = self.presentingViewController
        if isNewContact{
            let detailController: DetailContactViewController = DetailContactViewController()
            detailController.contactVM = contactVM
            if let parent = parentController as? UINavigationController{
                parent.pushViewController(detailController, animated: true)
            }
        }
    }
    
}
