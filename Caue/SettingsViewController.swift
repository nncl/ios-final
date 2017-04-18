//
//  SettingsViewController.swift
//  Caue
//
//  Created by Cauê Almeida on 4/16/17.
//  Copyright © 2017 Usuário Convidado. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets
    var dataSource: [State] = []
    var product: Product!

    @IBOutlet weak var tfDolarPrice: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSettingsValues()
        loadStates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateSettingsValues()
        loadStates()
    }
    
    func updateSettingsValues() {
        if let dolarPrice = UserDefaults.standard.string(forKey: "dolar_preference") {
            tfDolarPrice.text = dolarPrice
            print("tem dolar_preference")
        } else {
            // BUG iOS XCode
            // Setamos o valor aqui e o recuperamos pois parece que o XCode está com bug no simulador
            // Então se houver e conseguir no settings bundle pega de lá, do contrário define e seta
            UserDefaults.standard.set(3.14, forKey: "dolar_preference")
            tfDolarPrice.text = UserDefaults.standard.string(forKey: "dolar_preference")
        }
        
        if let iofPrice = UserDefaults.standard.string(forKey: "iof_preference") {
            print("tem iof_preference")
            tfIOF.text = iofPrice
        } else {
            // BUG iOS XCode
            UserDefaults.standard.set(6.38, forKey: "iof_preference")
            tfIOF.text = UserDefaults.standard.string(forKey: "iof_preference")
        }
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        
        // Ordenação por nome
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            dataSource = try context.fetch(fetchRequest)
            tableView.reloadData()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    func showAlert(type: StateAlertType, state: State?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        // Add campos no alert
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do Estado US"
            
            if let name = state?.name {
                textField.text = name
            }
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Imposto"
            
            if let tax = state?.tax {
                textField.text = "\(tax)"
            }
        }
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            // Cria um estado se não for nulo
            let state = state ?? State(context: self.context)
            state.name = alert.textFields?.first?.text
            state.tax = Double((alert.textFields?[1].text)!)!
            
            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Functions
    
    @IBAction func add(_ sender: Any) {
        showAlert(type: .add, state: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let state = dataSource[indexPath.row]
        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = "\(state.tax)"
        cell.detailTextLabel?.textColor = .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.dataSource[indexPath.row]
            self.context.delete(state)
            do {
                try self.context.save()
                self.dataSource.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Editar") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.dataSource[indexPath.row]
            tableView.setEditing(false, animated: true)
            self.showAlert(type: .edit, state: state)
        }
        
        editAction.backgroundColor = .blue
        return [editAction, deleteAction]
        
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserDefaults.standard.set(tfDolarPrice.text, forKey: "dolar_preference")
        UserDefaults.standard.set(tfIOF.text, forKey: "iof_preference")
    }
}

