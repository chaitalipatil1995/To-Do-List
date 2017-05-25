//
//  ViewController.swift
//  swTo-Do-List
//
//  Created by Amesten Systems on 24/05/17.
//  Copyright © 2017 Amesten Systems. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, cellDelegateProtocol{
    @IBOutlet var viewForPicker: UIView!

    @IBOutlet var cancelOutlet: UIButton!
    @IBOutlet var okOutlet: UIButton!
    @IBOutlet var listTableView: UITableView!
    var tasks : [NSManagedObject] = []
    var dateString = NSString()
    var indexPath = Int()
    var indexValue :String = ""
    
    @IBOutlet var taskDatePicker: UIDatePicker!
    @IBOutlet var refreshOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        listTableView.backgroundColor = UIColor.clear
        self.automaticallyAdjustsScrollViewInsets = false
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        viewForPicker.isHidden = true
        viewForPicker.backgroundColor = UIColor.white
        viewForPicker.layer.borderColor = UIColor.black.cgColor
        viewForPicker.layer.borderWidth = 2
        viewForPicker.layer.cornerRadius = 5
        taskDatePicker.layer.borderWidth = 0.5
        okOutlet.layer.borderWidth = 0.5
        cancelOutlet.layer.borderWidth = 0.5
        
    }
    
    func createGradientLayer() {
        var gradientLayer: CAGradientLayer!

        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        
        self.view.layer.addSublayer(gradientLayer)
        self.view .addSubview(listTableView)
        self.view.addSubview(refreshOutlet)
        self.view.addSubview(viewForPicker)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self .createGradientLayer()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "TASK")
        
        do{
            
            tasks = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            
            print("counld not fetch. \(error), \(error.userInfo)")
        }
        listTableView .reloadData()

}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tasks.count > 0 {
            return tasks.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let identifier = "cell"
        let cell : ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! ListTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.taskLabel.font = UIFont.systemFont(ofSize: 20)
        cell.taskLabel.font = UIFont.boldSystemFont(ofSize: 22)
        cell.cellDelegate = self
        cell.editButton.tag = indexPath.row
        print(cell.tag)
        print(indexPath.row)
       
            if  tasks.count > 0  {
                let taskSTring = tasks[indexPath.row]
                cell.taskLabel.text = taskSTring.value(forKey: "task") as? String
                cell.timeLabel.text = taskSTring.value(forKey: "time") as? String
            } else {
                cell.taskLabel.text = "No Task avaialable"
                cell.timeLabel.text = "00-00-0000 00:00"
                cell.editButton.isUserInteractionEnabled = false
            }
       
        return cell
    }
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "TASK")
            do {
                tasks = try managedContext.fetch(fetchRequest)
            } catch {
                print("Fetching Failed")
            }
        }
        listTableView.reloadData()
    }
    
    
    @IBAction func addButtonAction(_ sender: AnyObject) {
      
        let alertController = UIAlertController(title: "Note", message: "Add new note which you want to do later", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            firstTextField.delegate = self
            let nameToSave = firstTextField.text
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "TASK", in: managedContext)!
            let task = NSManagedObject(entity: entity, insertInto: managedContext)
            task.setValue(nameToSave, forKey: "task")
            do{
                try managedContext.save()
                self.tasks.append(task)
                self.viewWillAppear(true)
            } catch let error as NSError {
                print("counld not save. \(error), \(error.userInfo)")
            }

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter task"
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    private dynamic func didRecognizeTapGesture(_ gesture: UITapGestureRecognizer) {
        print("succefully can use calender")
    }
    
    @IBAction func refreshButtonAction(_ sender: AnyObject) {
        self.viewWillAppear(true)
        listTableView .reloadData()
    }
    func didPressButton(_ tag: NSInteger) {
        print("I have pressed a button with a tag: \(tag)")
        viewForPicker.isHidden = false
        indexPath = tag
        print(tag)
    }
   
    @IBAction func pickerOkAction(_ sender: AnyObject) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.string(from: taskDatePicker.date)
         dateString = strDate as NSString
        print(dateString )
        self.updateName(index: indexPath, newName: dateString as String)
        self.viewWillAppear(true)
        viewForPicker.isHidden = true
    }
    
    @IBAction func pickerCancelAction(_ sender: AnyObject) {
        viewForPicker.isHidden = true
    }
    func updateName(index: Int, newName: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        tasks[index] .setValue(newName, forKey: "time")
        appDelegate.saveContext()
    }
}


