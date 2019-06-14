//
//  ViewController.swift
//  TestDemoSagarRathode
//
//  Created by appbellmac on 14/05/19.
//  Copyright ©  2019 Sagar Rathode All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var placeArray: [Place] = []
   
    @IBOutlet weak var Listtableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Listtableview.delegate = self
        Listtableview.dataSource = self
        Listtableview.isHidden = true
        readData()
        
        if(placeArray.count == 0) {
            loadData()
        }
        
    }
    func readData()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        do {
            placeArray = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest) as! [Place]
            
            placeArray = (placeArray.sorted(by: { (obj1, obj2) -> Bool in
                return (obj1 as AnyObject).id < (obj2 as AnyObject).id
            }) as NSArray) as! [Place]
            
            Listtableview.reloadData()
            Listtableview.isHidden = false
        }
        catch {
        }
    }
    
    func loadData()
    {
        let url = URL(string: "https://jsonplaceholder.typicode.com/photos")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data : Data?, response : URLResponse?, error : Error?) in
            
            if error != nil{
                print("Unable to fetch data")
            }
            
            do{
                let rootArray = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                print(rootArray)
               
                self.storeToDB(array: rootArray as! [Any])
            }
            
        })
        
        dataTask.resume()
    }
    
    func storeToDB(array : [Any])
    {
        
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        for element in (array as! [[String : Any]])
        {
            let place = NSEntityDescription.insertNewObject(forEntityName: "Place", into: appDelegate.persistentContainer.viewContext) as! Place
            
            place.titile = element["title"] as? String
            place.id = Int32((element["id"] as! Int))
        }
        
        appDelegate.saveContext()
        DispatchQueue.main.async {
            self.Listtableview.reloadData()
        }
        Listtableview.isHidden = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let temp = placeArray[indexPath.row]
        
        cell.lbltitle.numberOfLines = 2
        cell.lbltitle.text =  String(String(temp.id)+" " + temp.titile!)
        return cell
    }

}

