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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        if let item = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = item
//        }
        
        LoadItems()
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
        
        SaveItems()
        
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
            
            self.SaveItems()
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Input text here"
            alertText = textField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    func SaveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding item array, \(error)")
        }
        tableView.reloadData()
    }
    
    func LoadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

