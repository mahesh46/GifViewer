//
//  GifViewController.swift
//  GifViewer
//
//  Created by Administrator on 05/03/2019.
//  Copyright © 2019 mahesh lad. All rights reserved.
//

import UIKit
//import RxSwift
//import RxCocoa
import FLAnimatedImage
import Firebase
import GoogleMobileAds


class GifViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    private let reuseIdentifier = "Cell"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var gifmodel = [GifModel]()
    var gifCache = [String : FLAnimatedImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
       searchBar.delegate = self
        
        collectionView.register(UINib(nibName: "GifCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
 
       fetchData()
        
        bannerView.adUnitID =  "ca-app-pub-2341526960488277/7760204551" //live
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }

    
    // MARK: UICollectionViewDataSource
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.gifmodel.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)  as! GifCollectionViewCell
      
        // Configure the cell
        let model = self.gifmodel[indexPath.row]

        cell.cellTitleLabel.text = model.title
        
        // Check our gif cache for the existing key. This is just a dictionary of FLAnimatedImage
        let urlString = model.previewUrl//model.url
    
        let gif = self.gifCache[urlString]
        
         if( gif == nil ) {
        DispatchQueue.global(qos: .background).async {
        let url = URL(string: urlString)!
        let imageData = try? Data(contentsOf: url)
        let imageData3 = FLAnimatedImage(animatedGIFData: imageData)
             self.gifCache[urlString] = imageData3
         DispatchQueue.main.async {
          cell.cellGifView.animatedImage = imageData3
            }
        }
         } else {
            cell.cellGifView.animatedImage = gif
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.gifmodel[indexPath.row]

        // set up activity view controller
       
        let text = model.title
        //let image = UIImage(named: "Product")
        let WebsiteGif = NSURL(string:model.url)!
        let WebsiteMp4 = NSURL(string:model.mp4)!
        let shareAll = [text , WebsiteGif , WebsiteMp4] as [Any]
        
        
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        //
    }
    
    func loadtable(from url : URL, completion:@escaping (_ gifmodel : [GifModel]) -> Void) {
        
  
        //
        let task =     URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else {return}
           var gifmodel = [GifModel]()
            do {
                let WebsiteDescription = try JSONDecoder().decode(object.self, from: data)
                for dataArray in WebsiteDescription.data {
                    let id = dataArray.id
                    let title = dataArray.title
                    let url = dataArray.images.original.url
                    let width = dataArray.images.original.width
                    let height  = dataArray.images.original.height
                    let mp4  = dataArray.images.original.mp4
                    let previewUrl = dataArray.images.preview_gif.url
                    let gifobj = GifModel(title: title, url: url, width: width, height: height, id: id, mp4: mp4, previewUrl : previewUrl)
         
                        gifmodel.append(gifobj)
                
                }
               DispatchQueue.main.async {
                completion(gifmodel)
               }
              
            } catch let jsonerr {
                print(jsonerr)
                print(jsonerr.localizedDescription)
            }
        }
        task.resume()
        
        //
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         fetchData()
         searchBar.resignFirstResponder()
    }
    
    func fetchData() {
        
        gifmodel = [GifModel]()
        self.collectionView.reloadData()
        var urlString = ""
        // replaca space with %20
        var searchText = self.searchBar.text ?? ""
        searchText = searchText.replacingOccurrences(of: " ", with: "%20")
        if searchText.count > 2 {
            let urlSearch = "https://api.giphy.com/v1/gifs/search?api_key=N3JYnBHwWdNCZcI1PNATSdojX0UaGiBt&q=\(searchText)&limit=25&offset=0&rating=G&lang=en"
            urlString = urlSearch
        } else {
            let urlTrending  = "https://api.giphy.com/v1/gifs/trending?api_key=N3JYnBHwWdNCZcI1PNATSdojX0UaGiBt&limit=25&rating=G"
            urlString = urlTrending
        }
        
        let url = URL(string: urlString)!
        
        self.loadtable(from: url) { (model) in
            DispatchQueue.main.async {
            
                self.gifmodel = model
                self.collectionView.reloadData()
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.----
        gifCache = [String : FLAnimatedImage]()
    }
}

