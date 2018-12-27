//
//  ContactViewController.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/23/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class ContactViewController: KeyboardListenerVC, RealmUtilDelegate {
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "ContactCell"
    let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    let itemsPerRow: CGFloat = 1
    let numOfSections: Int = 1
    var contactResults: [ContactViewModel]=[]
    
    fileprivate let realmUtil: RealmUtils = RealmUtils()
    fileprivate var disposeBag: DisposeBag = DisposeBag()
    fileprivate var hasDefaultResult = true
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var noResultsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewResizerOnKeyboardShown()
        setupSearchBar()
        configureAddButton()
        self.collectionView.register(UINib(nibName: "ContactCollectionCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.title = "Contacts"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if searchBar.text?.isEmpty ?? true{
            realmUtil.fetchAll(realmDelegate: self)
        }else{
            self.realmUtil.fetchByQuery(realmDelegate: self,query: self.searchBar.text?.lowercased() ?? "")
        }
    }
    
    func configureAddButton(){
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewContact)), animated: true)
    }
    
    @objc func addNewContact(){
        let updateController: UpdateContactViewController = UpdateContactViewController()
        updateController.isNewContact = true
        let navController = UINavigationController(rootViewController: updateController)
        self.present(navController, animated: true, completion: nil)
    }
    
    // MARK: - SetUpSearchBar
    func setupSearchBar(){
        self.searchBar
            .rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] query in
                if query.isEmpty && !self.hasDefaultResult {
                    self.hasDefaultResult = true
                    self.realmUtil.fetchAll(realmDelegate: self)
                }else if !query.isEmpty{
                    self.hasDefaultResult = false
                    self.realmUtil.fetchByQuery(realmDelegate: self,query: self.searchBar.text?.lowercased() ?? "")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func configEmptyView() {
        if contactResults.count==0 && (searchBar.text?.count ?? 0) > 1{
            noResultsLabel.isHidden = false
        }else{
            noResultsLabel.isHidden = true
        }
    }
    
    fileprivate func reloadPage() {
        DispatchQueue.main.async {
            self.configEmptyView()
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - RealmUtilDelegate
    func foundResults(searchResults: Results<Contact>) {
        let contactItems: [Contact] = Array(searchResults)
        contactResults = contactItems.map { contactItem in
            return ContactViewModel(contact :contactItem)
        }
        reloadPage()
    }
    
    func foundResults(query: String, nameResults: Results<Contact>, addressResults: Results<Contact>, phoneNumResults: Results<Contact>, emailResults: Results<Contact>){
       
        let nameItems: [Contact] = Array(nameResults)
        var results: [ContactViewModel] = nameItems.map { nameItem in
            return ContactViewModel(contact :nameItem)
        }
        
        let addItems: [Contact] = Array(addressResults)
        let mAddResults = addItems.map { addItem in
            return ContactViewModel(contact: addItem, query: query, foundAddress: true, foundPhoneNumber: false, foundEmail: false)
        }
        
        let phoneNumItems: [Contact] = Array(phoneNumResults)
        let mPhoneNumResults = phoneNumItems.map { phoneNumItem in
            return ContactViewModel(contact: phoneNumItem, query: query, foundAddress: false, foundPhoneNumber: true, foundEmail: false)
        }
        
        let emailItems: [Contact] = Array(emailResults)
        let mEmailResults = emailItems.map { emailItem in
            return ContactViewModel(contact: emailItem, query: query, foundAddress: false, foundPhoneNumber: false, foundEmail: true)
        }
    
        results.append(contentsOf: mAddResults)
        results.append(contentsOf: mPhoneNumResults)
        results.append(contentsOf: mEmailResults)
        
        results = results.sorted(by:{$0.firstname < $1.firstname})
        contactResults = results
        
        reloadPage()
        
    }
    
}

extension ContactViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        openDetailController(contactViewModel:  contactResults[indexPath.row])
    }
    
    func openDetailController(contactViewModel: ContactViewModel){
        let detailController:DetailContactViewController = DetailContactViewController()
        detailController.contactVM = contactViewModel
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}
