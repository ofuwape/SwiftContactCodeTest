//
//  EmailModel.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/23/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import Foundation
import RealmSwift

class EmailModel: Object{
    @objc dynamic var text: String = ""

}

extension EmailModel{
    convenience init(emailText: String) {
        self.init()
        self.text = emailText
    }
}
