//
//  UpdateCellView.swift
//  Code Test Oluwatoni Fuwape
//
//  Created by Toni Fuwape on 12/26/18.
//  Copyright © 2018 Oluwatoni Fuwape. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class UpdateCellView: UITableViewCell{
    
   
    @IBOutlet var textField: UITextField!
    @IBOutlet var buttonImageView: UIImageView!
    
    let addImage: UIImage? = UIImage(named: "Add")
    let removeImage: UIImage? = UIImage(named: "Remove")
    private(set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
        self.textField.keyboardType = .default
    }
    
    func setAddImage() {
        buttonImageView.contentMode = UIView.ContentMode.scaleAspectFit
        buttonImageView.image = addImage
        buttonImageView.isUserInteractionEnabled = false
    }
    
    func setRemoveImage() {
        buttonImageView.contentMode = UIView.ContentMode.scaleAspectFit
        buttonImageView.image = removeImage
        buttonImageView.isUserInteractionEnabled = true
    }
    
    func clearImage() {
        buttonImageView.image = nil
        buttonImageView.isUserInteractionEnabled = false
    }
}
