//
//  ViewController.swift
//  Todoey
//
//  Created by IlmuOne Data on 15/03/19.
//  Copyright © 2019 IlmuOneData. All rights reserved.
//

import UIKit

class TodoListViewController : UITableViewController{
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

          let newItem = Item()
          newItem.title = "Find Mike"
          itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Find John"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Find Tyrell"
        itemArray.append(newItem3)
        
        if let item = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = item
        }
    }
    
    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator
        //value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        var alertText = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Add item success")
            
            let newItem = Item()
            newItem.title = alertText.text!
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Input text here"
            alertText = textField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    

}

