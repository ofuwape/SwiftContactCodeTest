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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailContactView?.detailTableView.delegate = self
        detailContactView?.detailTableView.dataSource = self
        detailContactView?.detailTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        configureDetailView()
    }
    
     override func loadView() {
        self.detailContactView = DetailContactView.fromNib()
        self.view = self.detailContactView
    }
    
    func configureDetailView(){
        configureEditButton()
        detailContactView?.fullNameLabel.text = contactVM?.fullName
        detailContactView?.detailTableView.reloadData()
        detailContactView?.detailTableView.tableFooterView = UIView() // remove empty cells
    }
    
    func configureEditButton(){
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editContact)), animated: true)
    }
    
    @objc func editContact(){
        // implement
    }
    
}

enum SectionType : Int {
    case PhoneNum = 0
    case Email = 1
    case DOB = 2
    case Address = 3
}
