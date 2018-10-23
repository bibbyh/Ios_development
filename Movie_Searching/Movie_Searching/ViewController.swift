//
//  ViewController.swift
//  lab4
//
//  Created by 衡俊吉 on 10/19/18.
//  Copyright © 2018 junji. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UISearchBarDelegate,UICollectionViewDelegate{


    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    var theData: Info?
    var theImageCache: [UIImage] = []
    var currentSearch : String = ""
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var latestData: Latest?
    
    @objc func openLatest(){
        let url = URL(string:"https://api.themoviedb.org/3/movie/latest?api_key=6862f82aeb589e80608d60358bd6b0ae&language=en-US")
        
        let data = try! Data(contentsOf: url!)
        latestData = try! JSONDecoder().decode(Latest.self, from: data)
        
        if(latestData?.poster_path == nil){
            theImageCache.append(#imageLiteral(resourceName: "heart"))
            
        }
        else{
            let url = URL(string: "https://image.tmdb.org/t/p/w185" + (latestData?.poster_path!)!)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            theImageCache.append(image!)
        }
        let detailedVC = DetailedViewController()
        detailedVC.image = theImageCache.last
        detailedVC.imageName = latestData!.title
        detailedVC.language =  latestData!.original_language
        detailedVC.date = latestData!.release_date
        detailedVC.score = String(latestData!.vote_average)
        detailedVC.overview = latestData!.overview
        navigationController?.pushViewController(detailedVC, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        theData?.results = []
        setupcollectionView()
        setupSearchBar()
        activityIndicator.center = CGPoint(x: 187, y: 235)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        collectionView.addSubview(self.activityIndicator)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Latest", style: .plain, target: self, action: #selector(openLatest))
        

        
        
        
        DispatchQueue.global(qos: .userInitiated).async {

            
            self.cacheImages()
            self.fetchDataForCollectionView()
            DispatchQueue.main.async {

                self.collectionView.reloadData()
                
            }
            
        }
        
    }
    func setupSearchBar(){
        searchBar.delegate = self
    }
    
    func setupcollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
         collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedVC = DetailedViewController()
        detailedVC.image = theImageCache[indexPath.row]
        detailedVC.imageName = theData!.results![indexPath.row].title!
        detailedVC.language =  theData!.results![indexPath.row].original_language!
        detailedVC.date = theData!.results![indexPath.row].release_date!
        detailedVC.score = String(theData!.results![indexPath.row].vote_average!)
        detailedVC.overview = "no"
        detailedVC.id = theData!.results![indexPath.row].id!
        navigationController?.pushViewController(detailedVC, animated: true)
        
    }
    
    func cacheImages() {
        theImageCache = []
        if theData == nil {
            print("No movies")
        }else{
        for item in (theData?.results)! {
            if(item.poster_path == nil){theImageCache.append(#imageLiteral(resourceName: "heart"))}
            else{
            let url = URL(string: "https://image.tmdb.org/t/p/w185" + item.poster_path!)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            theImageCache.append(image!)
            }
            }
            
        }
        

    }



    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if theData == nil {return 0}
        return (theData?.results?.count)!
    }
    
    func fetchDataForCollectionView() {

   
        if(currentSearch != ""){

        let url = URL(string:"https://api.themoviedb.org/3/search/movie?api_key=6862f82aeb589e80608d60358bd6b0ae&query=" + currentSearch)
            if (url == nil){
                theData = nil
            }else{
        let data = try! Data(contentsOf: url!)
        theData = try! JSONDecoder().decode(Info.self, from: data)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath)
        if (indexPath.row < theImageCache.count){
        let image = theImageCache[indexPath.row]
        cell.backgroundColor = UIColor.white
        let theImageFrame = CGRect(x: 0 , y: 0, width: cell.frame.width, height: cell.frame.height)
        
        let imageView = UIImageView(frame: theImageFrame)
        imageView.image = image
        cell.addSubview(imageView)
        
        let theTextFrame = CGRect(x: 0, y: cell.frame.height - 40, width: cell.frame.width, height: 40  )
        let textView = UILabel(frame: theTextFrame)
        textView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        textView.text = theData!.results![indexPath.row].title!
        textView.textAlignment = .center
        textView.textColor = UIColor.white
        textView.lineBreakMode = .byTruncatingTail
        textView.numberOfLines = 0
        textView.font = UIFont(name: "Arial", size: 11)
        textView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        cell.addSubview(textView)
        }
        // Configure the cell
        return cell
        
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        theImageCache = []
        collectionView.reloadData()
        theData = nil
        activityIndicator.startAnimating()
        let text = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        DispatchQueue.global(qos: .userInitiated).async {

//            if (text?.trimmingCharacters(in: .whitespacesAndNewlines) != self.currentSearch){
//            if (true){
                self.currentSearch = text!
                self.currentSearch = self.currentSearch.replacingOccurrences(of: " ", with: "+")
                self.fetchDataForCollectionView()
                self.theImageCache = []
                self.cacheImages()
                
            

    
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()

                self.collectionView.reloadData()
            }
        }
        
}
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

