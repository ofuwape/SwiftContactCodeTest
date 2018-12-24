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

class ContactViewController: UIViewController, RealmUtilDelegate {
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "ContactCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    fileprivate let itemsPerRow: CGFloat = 1
    fileprivate let numOfSections: Int = 1
    fileprivate let realmUtil: RealmUtils = RealmUtils()
    fileprivate var contactResults: [ContactViewModel]=[]
    fileprivate var disposeBag: DisposeBag = DisposeBag()
    fileprivate var hasDefaultResult = true
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        self.collectionView.register(UINib(nibName: "ContactCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ContactCell")
        self.title = "Contacts"
        realmUtil.fetchAll(realmDelegate: self)
    }
    
    // MARK: - SetUpSearchBar
    func setupSearchBar(){
        self.searchBar
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .debounce(0.5, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
//            .filter { !$0.isEmpty } // If the new value is really new, filter for non-empty query.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
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
    
    // MARK: - RealmUtilDelegate
    func foundResults(searchResults: Results<Contact>) {
        let contactItems: [Contact] = Array(searchResults)
        contactResults = contactItems.map { contactItem in
            return ContactViewModel(contact :contactItem)
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
        
        results = results.sorted(by:{$0.firstname! < $1.firstname!})
        contactResults = results
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
}

// MARK: - UICollectionViewDataSource
extension ContactViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return contactResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ContactCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCell", for: indexPath) as! ContactCollectionCell
        cell.backgroundColor = UIColor.lightGray
        let contactVM: ContactViewModel = contactResults[indexPath.item]
        
        cell.mainLabel.isHidden = false
        cell.mainLabel.text = contactVM.fullName
        cell.contactLabel.text = contactVM.fullName
        cell.detailLabel.attributedText = contactVM.matchedDetail
        
        if contactVM.hasMatchedDetail{
            cell.mainLabel.isHidden = true
            cell.contactLabel.isHidden = false
            cell.detailLabel.isHidden = false
        }else{
            cell.mainLabel.isHidden = false
            cell.contactLabel.isHidden = true
            cell.detailLabel.isHidden = true
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ContactViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 62)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
