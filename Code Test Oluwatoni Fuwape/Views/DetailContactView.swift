//
//  DetailContactView.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/24/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import Foundation
import UIKit

class DetailContactView: UIView{
    
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var detailTableView: UITableView!
    
}

extension DetailContactView {
    class func fromNib<T: DetailContactView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
