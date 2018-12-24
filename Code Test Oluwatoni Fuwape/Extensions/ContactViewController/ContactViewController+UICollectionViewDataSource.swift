//
//  ContactViewController+UICollectionViewDataSource.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/24/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import Foundation
import UIKit

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

