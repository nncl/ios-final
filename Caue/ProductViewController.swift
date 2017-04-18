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
    var dataSource = [
        "Arroz",
        "Feijão",
        "Batata",
        "Macarrão",
        "Ovo"
    ]
    var product: Product!
    var pickerView: UIPickerView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    @IBOutlet weak var btAddUpdate: UIButton!
    @IBOutlet weak var tfState: UITextField!
    
    // MARK: - Functions/Methods
    func cancel() {
        tfState.resignFirstResponder() // Some com o foco do tfield, fazendo o teclado sumir
    }
    
    // Clica no outro botão do toolbar
    func done() {
        tfState.text = dataSource[pickerView.selectedRow(inComponent: 0)]
        cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if product != nil {
            product.name = tfName.text
            product.card = swCard.isOn
            product.price = Float(tfPrice.text!)!
            
            btAddUpdate.setTitle("Atualizar", for: .normal)
            
        }
        
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Build do select dos estados
        let toolBar = UIToolbar(frame: CGRect(x:0,y:0,width:self.view.frame.size.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.items = [btCancel, btSpace, btDone] // Adicionando na toolbar
        
        tfState.inputView = pickerView
        tfState.inputAccessoryView = toolBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if product != nil {
            if let states = product.states {
                let arr = states.allObjects
                tfState.text = arr.map({($0 as! State).name!}).joined(separator: " | ")
            }
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! StatesViewController
        if product == nil {
            product = Product(context: context)
        }
        vc.product = product
    }
    
    // TODO Finish save
    @IBAction func doSaveProduct(_ sender: UIButton) {
        
        // Validate fields
        if (tfName.text?.isEmpty ?? true || tfPrice.text?.isEmpty ?? true) {
            doShowError(title: "Erro", message: "Todos os campos são obrigatórios")
        } else {
            
            if product == nil {product = Product(context: context)}
            product.name = tfName.text
            product.card = swCard.isOn
            product.price = Float(tfPrice.text!)!
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func doShowError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    /*
     * Action sheet
     
     let alert = UIAlertController(title: "Do something", message: "With this", preferredStyle: .actionSheet)
     alert.addAction(UIAlertAction(title: "A thing", style: .default) { action in
     // perhaps use action.title here
     })
     
     self.present(alert, animated: true)

     */
}

extension ProductViewController: UIPickerViewDelegate {
    
    // Populamos os valores que aparecerão no PickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    //
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Cumero " + dataSource[row])
        tfState.text = dataSource[row]
    }
    
}

extension ProductViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // Quantos componentes existem no pickerview = colunas; like date
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
}

