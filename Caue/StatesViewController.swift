//
//  StatesViewController.swift
//  Caue
//
//  Created by Cauê Almeida on 4/15/17.
//  Copyright © 2017 Usuário Convidado. All rights reserved.
//

import UIKit
import CoreData

enum StateAlertType {
    case add
    case edit
}

class StatesViewController: UIViewController {
    
    var dataSource: [State] = []
    var product: Product!

    @IBAction func add(_ sender: Any) {
        showAlert(type: .add, state: nil)
    }
    
    @IBAction func close(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        loadStates()
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
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            // Cria um estado se não for nulo
            let state = state ?? State(context: self.context)
            state.name = alert.textFields?.first?.text
            
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
    
    /**
     * Carrega todos os estados
     */
    
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

}

extension StatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = dataSource[indexPath.row]
        product.states = nil
        product.addToStates(state)
        close(nil)
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

extension StatesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let state = dataSource[indexPath.row]
        cell.textLabel?.text = state.name
        cell.accessoryType = .none
        
        if let states = product.states {
            if states.contains(state) {
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
}


