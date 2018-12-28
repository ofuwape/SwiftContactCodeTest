//
//  UpdateContactView.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/24/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import Foundation
import UIKit

class UpdateContactView: UIView {
    
    @IBOutlet var updateContactTableView: UITableView!
    @IBOutlet var tableViewBottomConstraint: NSLayoutConstraint!

}

extension UpdateContactView {
    class func fromNib<T: UpdateContactView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
