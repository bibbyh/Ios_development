//
//  DetailedViewController.swift
//  InClassDemo2
//
//  Created by Todd Sproull on 10/8/18.
//  Copyright © 2018 Todd Sproull. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    var id: Int!
    
    var image: UIImage!
    
    var imageName: String!
    
    var score: String!
    
    var language: String!
    
    var date: String!
    
    var overview: String!
    
    @objc func handleRegister(sender: UIButton){
        sender.isUserInteractionEnabled = false
        sender.alpha = 0.4
        sender.setTitle("In your Favorites", for: .normal)
        var myArray: [String]?
        let favorarray = NSArray(contentsOfFile: NSHomeDirectory() + "/Documents/favor.plist")
        if favorarray == nil{
            let array = NSArray(object: self.imageName)
            let filePath:String = NSHomeDirectory() + "/Documents/favor.plist"
            array.write(toFile: filePath, atomically: true)
        }else{
            myArray = []
            for movie in favorarray!{
                if(movie as? String != self.imageName && movie as? String != " "){
                    myArray?.append(movie as! String)
                    
                }
            }
            myArray?.append(self.imageName)
            let newArray = NSArray(array: myArray!)
            let filePath:String = NSHomeDirectory() + "/Documents/favor.plist"
            newArray.write(toFile: filePath, atomically: true)
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLoadSetup()
        
        
    }
    func viewLoadSetup(){
        view.backgroundColor = UIColor.white
        navigationItem.title = imageName
        let theImageFrame = CGRect(x: 0, y: 64, width: view.frame.width, height: image.size.height)
        let imageView = UIImageView(frame: theImageFrame)
        imageView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        imageView.contentMode = .center
        imageView.image = image
        
        let theTextFrame = CGRect(x: 0, y: image.size.height + 70, width: view.frame.width, height: 50  )
        let textView = UILabel(frame: theTextFrame)
        textView.text = "Realeased: " + date
        textView.textAlignment = .center
        
        let theTextFrame2 = CGRect(x: 0, y: image.size.height + 120, width: view.frame.width, height: 50  )
        let textView2 = UILabel(frame: theTextFrame2)
        textView2.text = "Language: " + language
        textView2.textAlignment = .center
        
        let theTextFrame3 = CGRect(x: 0, y: image.size.height + 170, width: view.frame.width, height: 50  )
        let textView3 = UILabel(frame: theTextFrame3)
        textView3.text = "Score: " + score + "/" + "10"
        textView3.textAlignment = .center
        
        let buttonFrame = CGRect(x: 100, y: image.size.height + 220, width: 175, height: 36  )
        //        let button = UIButton.init(frame: buttonFrame, type(of: UIButtonType.system))
        let button = UIButton.init(type: .roundedRect)
        button.frame = buttonFrame
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.blue, for: UIControlState.normal)
        button.setTitle("Add to favorites", for: UIControlState.normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue.cgColor
        let favorarray = NSArray(contentsOfFile: NSHomeDirectory() + "/Documents/favor.plist")
        if favorarray != nil{
            
            for movie in favorarray!{
                if(movie as? String == self.imageName){
                    button.isUserInteractionEnabled = false
                    button.alpha = 0.4
                    button.setTitle("In your Favorites", for: .normal)
                }
            }
            
        }
        
        
        
        button.addTarget(self, action:#selector(handleRegister(sender:)), for: .touchUpInside)
        let theTextFrame4 = CGRect(x: 0, y: image.size.height + 255, width: view.frame.width, height: 100  )
        let textView4 = UILabel(frame: theTextFrame4)
        textView4.lineBreakMode = .byTruncatingTail
        textView4.numberOfLines = 0
        textView4.font = UIFont(name: "Arial", size: 14)
        textView4.textAlignment = .center
        
        if (overview != "no"){
            let textView4 = UILabel(frame: theTextFrame4)
            textView4.lineBreakMode = .byTruncatingTail
            textView4.numberOfLines = 0
            textView4.font = UIFont(name: "Arial", size: 14)
            textView4.textAlignment = .center
            textView4.text = overview


            
        }
        else{
            let url = URL(string:"https://api.themoviedb.org/3/movie/" + String(id) + "/reviews?api_key=6862f82aeb589e80608d60358bd6b0ae&language=en-US&page=1")
           
            
            let data = try! Data(contentsOf: url!)
            var reviewData = try! JSONDecoder().decode(Review.self, from: data)
            

            if ((reviewData.results?.count)! > 0){
            let review = reviewData.results![0].content
            let author = reviewData.results![0].author
                let text = review!
                let alertController = UIAlertController(title: author, message: text, preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Cool", style: .default) { (action:UIAlertAction) in}
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
                overview = "a"
            }
            else{
                let text = "No reviews yet"
                let alertController = UIAlertController(title: "Oops!", message: text, preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Emmm", style: .default) { (action:UIAlertAction) in}
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
                overview = "a"
                }


            }
            

        
        
        view.addSubview(textView)
        view.addSubview(textView2)
        view.addSubview(textView3)
         view.addSubview(textView4)
        view.addSubview(imageView)
        view.addSubview(button)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
