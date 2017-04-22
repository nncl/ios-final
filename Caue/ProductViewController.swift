//
//  ProductViewController.swift
//  Caue
//
//  Created by Cauê Almeida on 4/9/17.
//  Copyright © 2017 Usuário Convidado. All rights reserved.
//

import UIKit
import CoreData

class ProductViewController: UIViewController {
    
    // MARK: - Variables
    var smallImage: UIImage!
    var stateTax: Double = 0
    var dataSource: [State] = []
    var product: Product!
    var pickerView: UIPickerView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    @IBOutlet weak var btAddUpdate: UIButton!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var ivPoster: UIImageView!
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addPoster(_ sender: UIButton) {
        print("Add poster")
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Functions/Methods
    func cancel() {
        tfState.resignFirstResponder() // Some com o foco do tfield, fazendo o teclado sumir
    }
    
    // Clica no outro botão do toolbar
    func done() {
        tfState.text = dataSource[pickerView.selectedRow(inComponent: 0)].name
        stateTax = dataSource[pickerView.selectedRow(inComponent: 0)].tax
        cancel()
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        
        // Ordenação por nome
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            dataSource = try context.fetch(fetchRequest)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if product != nil {
            product.name = tfName.text
            product.card = swCard.isOn
            product.price = Float(tfPrice.text!)!
            
            if let image = product.poster as? UIImage {
                ivPoster.image = image
            }
            
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
        
        loadStates()
        
        if product != nil {
            if let states = product.states {
                let arr = states.allObjects
                tfState.text = arr.map({($0 as! State).name!}).joined(separator: " | ")
                
                if (arr.count > 0) {
                    stateTax = (arr[0] as! State).tax
                }
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
    
    func calculatePercentageValue(value: Double, percentage: Double) -> Double {
        var total: Double = (percentage / 100)
        total = total * value
        return total
    }
    
    @IBAction func doSaveProduct(_ sender: UIButton) {
        
        // Validação de campos
        if (tfName.text?.isEmpty ?? true || tfPrice.text?.isEmpty ?? true) {
            
            doShowMessage(title: "Erro", message: "Todos os campos são obrigatórios", back: nil)
            
        } else {
            
            if product == nil {product = Product(context: context)}
            product.name = tfName.text
            product.card = swCard.isOn
            product.price = Float(tfPrice.text!)!
            
            if smallImage != nil {
                product.poster = smallImage
            }

            product.total = Float(calculatePercentageValue(value: Double(product.price), percentage: Double(stateTax)))
            
            product.total = product.total + product.price
            
            if swCard.isOn {
                print("Pagou com cartão")
                
                if let dolarPrice = UserDefaults.standard.string(forKey: "iof_preference") {
                    
                    // Pegar IOF% do produto e somar no total
                    let totalWithIOF = Float(calculatePercentageValue(value: Double(product.price), percentage: Double(dolarPrice)!))
                    
                    product.total = product.total + totalWithIOF
                    
                } else {
                    doShowMessage(title: "Erro", message: "Erro ao calcular IOF. Tente novamente", back: nil)
                }
            }
            
            print("Valor total do produto: \(product.total)")
            
            do {
                try context.save()
                doShowMessage(title: "Sucesso", message: "Produto cadastrado com sucesso", back: true)
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func doShowMessage(title: String, message: String, back: Bool?) {
        let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel) { (UIAlertAction) in
            if let getBack = back {
                if getBack == true {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
}

extension ProductViewController: UIPickerViewDelegate {
    
    // Populamos os valores que aparecerão no PickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row].name
    }
    
    //
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfState.text = dataSource[row].name
        stateTax = dataSource[row].tax
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

extension ProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        // Reduzir imagem
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivPoster.image = smallImage
        
        dismiss(animated: true, completion: nil)
    }
}
