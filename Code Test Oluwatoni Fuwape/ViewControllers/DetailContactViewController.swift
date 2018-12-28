//
//  DetailContactViewController.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/24/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import Foundation
import UIKit

class DetailContactViewController: UIViewController{
    
    var detailContactView: DetailContactView?
    var contactVM: ContactViewModel?
    let numOfSections: Int = 4 // PhoneNums, Emails, Address, Birthday
    let cellIdentifier = "DetailCell"
    static let tablelIdentifier = "DetailTableId"
    let realmUtil = RealmUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailContactView?.detailTableView.delegate = self
        detailContactView?.detailTableView.dataSource = self
        detailContactView?.detailTableView.accessibilityIdentifier = DetailContactViewController.tablelIdentifier
        detailContactView?.detailTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        configureDetailView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let contactId = contactVM?.primaryKey{
            realmUtil.fechItem(id: contactId, delegate: self)
        }
    }
    
    override func loadView() {
        self.detailContactView = DetailContactView.fromNib()
        self.view = self.detailContactView
    }
    
    func configureDetailView(){
        configureEditButton()
        detailContactView?.detailTableView.tableFooterView = UIView() // remove empty cells
        configureData()
    }
    
    func configureData() {
        detailContactView?.fullNameLabel.text = contactVM?.fullName
        detailContactView?.detailTableView.reloadData()
    }
    
    func configureEditButton(){
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editContact)), animated: true)
    }
    
    @objc func editContact(){
        let updateController: UpdateContactViewController = UpdateContactViewController()
        updateController.contactVM = contactVM ?? ContactViewModel()
        let navController = UINavigationController(rootViewController: updateController)
        self.present(navController, animated: true, completion: nil)
    }
    
}

extension DetailContactViewController: RealmUtilSingleFetchDelegate{
    
    func foundItem(contact: Contact?) {
        if let mContact = contact{
            contactVM = ContactViewModel.init(contact: mContact)
            DispatchQueue.main.async {
                self.configureData()
            }
        }
    }
    
}

enum SectionType : Int {
    case PhoneNum = 0
    case Email = 1
    case DOB = 2
    case Address = 3
}
