//
//  ProductViewController.swift
//  Caue
//
//  Created by Cauê Almeida on 4/9/17.
//  Copyright © 2017 Usuário Convidado. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }

}
