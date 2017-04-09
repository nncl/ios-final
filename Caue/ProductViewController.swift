//
//  ProductViewController.swift
//  Caue
//
//  Created by Cauê Almeida on 4/9/17.
//  Copyright © 2017 Usuário Convidado. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var swCard: UISwitch!

    // MARK: - Functions/Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    @IBAction func doSaveProduct(_ sender: UIButton) {
    }
    

}
