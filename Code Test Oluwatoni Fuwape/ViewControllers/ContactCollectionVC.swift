//
//  ViewController.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/18/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import UIKit
import RealmSwift

class ContactCollectionVC: UICollectionViewController, RealmUtilDelegate {
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "ContactCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    fileprivate let itemsPerRow: CGFloat = 1
    fileprivate let numOfSections: Int = 1
    fileprivate let realmUtil: RealmUtils = RealmUtils()
    fileprivate var contactResults: [ContactViewModel]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "ContactCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ContactCell")
        realmUtil.fetchAll(realmDelegate: self)
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
}

// MARK: - UICollectionViewDataSource
extension ContactCollectionVC {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return contactResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ContactCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCell", for: indexPath) as! ContactCollectionCell
        cell.backgroundColor = UIColor.lightGray
        let contactVM: ContactViewModel = contactResults[indexPath.item]
        cell.contactLabel.text = contactVM.fullName
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ContactCollectionVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 60)
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

