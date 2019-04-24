//
//  CategoryViewController.swift
//  Todoey
//
//  Created by IlmuOne Data on 02/04/19.
//  Copyright © 2019 IlmuOneData. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadData()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for:
            indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categoryArray.count
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        var alertText = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Add item success")
            
            let newCategory = Category(context: self.context)
            newCategory.name = alertText.text!
            self.categoryArray.append(newCategory)
            
            self.saveData()
        }
            
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Input text here"
                alertText = textField
            })
            
            alert.addAction(action)
        
            present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    func saveData(){
        do{
          try context.save()
        }
        catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadData(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        do{
           categoryArray = try context.fetch(request)
        }
        catch{
            print("Error fetching data from context \(error)")
        }
        self.tableView.reloadData()
    }
    
}
