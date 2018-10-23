//
//  FavoritesViewController.swift
//  lab4
//
//  Created by 衡俊吉 on 10/21/18.
//  Copyright © 2018 junji. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController,UITableViewDataSource{
    
    
    @IBOutlet var tableView: UITableView!
    
    var myArray: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewLoadSetup()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLoadSetup()
        
        
    }
    func viewLoadSetup() {
        tableView.dataSource = self
        let favorarray = NSArray(contentsOfFile: NSHomeDirectory() + "/Documents/favor.plist")
        if favorarray == nil{
//            let array = NSArray(object: " ")
//            let filePath:String = NSHomeDirectory() + "/Documents/favor.plist"
//            array.write(toFile: filePath, atomically: true)
            
        }else{
            myArray = []
            for movie in favorarray!{
                if movie as! String != ""{
                    myArray?.append(movie as! String)}
            }
        }
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (myArray == nil){return 0}
        return (myArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel!.text = myArray?[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "Delete"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
 

            
            var myArray: [String]?
            let favorarray = NSArray(contentsOfFile: NSHomeDirectory() + "/Documents/favor.plist")

                myArray = []
                for movie in favorarray!{
                    if(movie as? String != self.myArray?[indexPath.row]){
                        myArray?.append(movie as! String)
                    }
                
                let newArray = NSArray(array: myArray!)
                let filePath:String = NSHomeDirectory() + "/Documents/favor.plist"
                newArray.write(toFile: filePath, atomically: true)
            }
            
            
            
            
           self.myArray?.remove(at: indexPath.row)
            
            
            
           tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)

        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
