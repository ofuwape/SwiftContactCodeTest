//
//  DetailContactViewController+UITableViewDataSource.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/24/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import Foundation
import UIKit

extension DetailContactViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows: Int = 0
        
        switch section {
        case SectionType.PhoneNum.rawValue:
            numRows = self.contactVM?.phoneNumbers.count ?? 0
            break
        case SectionType.Email.rawValue:
            numRows = self.contactVM?.emails.count ?? 0
            break
        case SectionType.Address.rawValue:
            numRows = self.contactVM?.addresses.count ?? 0
            break
        case SectionType.DOB.rawValue:
            numRows = 1
            break
        default:
            break
        }
        return numRows
    }
    
    func getCellTextList( section: Int) -> [String] {
        switch section {
        case SectionType.PhoneNum.rawValue:
            return self.contactVM?.phoneNumbers ?? []
        case SectionType.Email.rawValue:
            return self.contactVM?.emails ?? []
        case SectionType.Address.rawValue:
            return self.contactVM?.addresses ?? []
        case SectionType.DOB.rawValue:
            return [contactVM?.dOB ?? ""]
        default:
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        var headerTitle: String = ""
        switch section {
        case SectionType.PhoneNum.rawValue:
            headerTitle = "Phone Number(s)"
            break
        case SectionType.Email.rawValue:
            headerTitle = "Email(s)"
            break
        case SectionType.Address.rawValue:
            headerTitle = "Address(es)"
            break
        case SectionType.DOB.rawValue:
            headerTitle = "Birthday"
            break
        default:
            break
        }
        return headerTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell.textLabel?.text = ""
        cell.textLabel?.text = getCellTextList(section: indexPath.section)[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return numOfSections
    }
    
}
