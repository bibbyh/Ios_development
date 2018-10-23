//
//  NowViewController.swift
//  lab4
//
//  Created by 衡俊吉 on 10/22/18.
//  Copyright © 2018 junji. All rights reserved.
//

import UIKit

class NowViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{

    @IBOutlet var collectionView: UICollectionView!
    var theImageCache: [UIImage] = []
    var theData: Info?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupcollectionView()
        theData?.results = []
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.fetchDataForCollectionView()
            self.cacheImages()

            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
                
            }
            
        }
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
    
        
        func fetchDataForCollectionView() {
                
                let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=6862f82aeb589e80608d60358bd6b0ae&language=en-US&page=1")
                    let data = try! Data(contentsOf: url!)
                    theData = try! JSONDecoder().decode(Info.self, from: data)
        
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if theData == nil {return 0}
        return (theData?.results?.count)!
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
