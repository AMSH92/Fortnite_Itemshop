//
//  ViewController.swift
//  FortniteItemShop
//
//  Created by Abdullah Alsharif on 1/21/19.
//  Copyright © 2019 Alsharif. All rights reserved.
//

import UIKit
import ViewAnimator
import CenteredCollectionView

class itemsColelctionView: UICollectionViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var colelctioView: UICollectionView!
    @IBOutlet weak var todaysDate: UILabel!
    @IBOutlet weak var countDown: UILabel!
    
    var cellSize_1 = CGSize()
    var dailyItemsCount: Int?
    var dailyItems:[[String:Any]] = [[:]]
    var delegets: countDownDelegates?
    var carousalTimer: Timer?
    var newOffsetX: CGFloat = 0.0
    var delegates: didPressDailyItemDelegats?
    
    var imagesArray: [UIImage] = []
    var itemData: [String:Any] = [:]
    var releaseDate: Date?
    var countdownTimer = Timer()

    
    
    func startTimer() {
        DispatchQueue.main.async {
            self.carousalTimer = Timer(fire: Date(), interval: 0.01, repeats: true) { (timer) in
        let initailPoint = CGPoint(x: self.newOffsetX,y :0)
        if __CGPointEqualToPoint(initailPoint, self.colelctioView.contentOffset) {
            if self.newOffsetX < self.colelctioView.contentSize.width {
                self.newOffsetX += 0.25
            }
            if self.newOffsetX > self.colelctioView.contentSize.width - self.colelctioView.frame.size.width {
                self.newOffsetX = 0
            }
            self.colelctioView.contentOffset = CGPoint(x: self.newOffsetX,y :0)
            } else {
            self.newOffsetX = self.colelctioView.contentOffset.x
            }
        }
            RunLoop.current.add(self.carousalTimer!, forMode: .common)
        }
    }
    
    func startCountTimer() {
        let lastUpdated = self.itemData["lastupdate"] as! Int
        let date = Date(timeIntervalSince1970: TimeInterval(lastUpdated))
        let calculate = date.addingTimeInterval(86400)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "HH:mm:ss"
        releaseDate = calculate
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
      
    }
    
    @objc func updateTime() {
        let currentDate = Date()
        let calendar = Calendar.current
        let lastUpdated = self.itemData["lastupdate"] as! Int
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: releaseDate! as Date)
        let sec = diffDateComponents.second ?? 0
        var seconds = String()
        let min = diffDateComponents.minute ?? 0
        var mintues = String()
        let hou = diffDateComponents.hour ?? 0
        var hours = String()

        seconds = "\(sec)"
        mintues = "\(min)"
        hours = "\(hou)"
        
        if sec  < 10 {
            seconds = "0\(sec)"
        }
        
        if min < 10 {
            mintues = "0\(min)"
        }
        
        if hou < 10 {
            hours = "0\(hou)"
        }
        
        let countdown = "\(hours):\(mintues):\(seconds)"
        self.countDown.text = countdown
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemShopCell", for: indexPath) as! todayCollectionViewCell
        cell.itemsImages.image = imagesArray[indexPath.row]
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return cellSize_1
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegates?.didPress(cell: self)
    }
    


}

class todayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemsImages: UIImageView!
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var cellSize_1 = CGSize()
    var cellSize_2 = CGSize()
    var cellSize_3 = CGSize()
    var dailyItems = [String:Any]()
    var itemImages: [[String?: Any?]] = [[:]]
    var imagesArray: [UIImage] = []
    var lastUpdated: Int = 0

    let flowLayout = ZoomAndSnapFlowLayout()
    

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view, typically from a nib.
      
        
    }
    
    func registerCells() {
        
        cellSize_1 = CGSize(width: view.frame.size.width - 20, height: 90)
        cellSize_2 = CGSize(width: view.frame.size.width - 20, height: 300)
        cellSize_3 = CGSize(width: view.frame.size.width - 20, height: 65)
        
        
        
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.register(UINib(nibName: "currentItems", bundle: nil), forCellWithReuseIdentifier: "itemsCell")
        self.collectionView.register(UINib(nibName: "today", bundle: nil), forCellWithReuseIdentifier: "todayCell")
        self.collectionView.register(UINib(nibName: "challenges", bundle: nil), forCellWithReuseIdentifier: "challangesCell")
        self.collectionView.register(UINib(nibName: "comingItems", bundle: nil), forCellWithReuseIdentifier: "comingCell")
        self.collectionView.register(UINib(nibName: "status", bundle: nil), forCellWithReuseIdentifier: "statusCell")

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView!.collectionViewLayout = layout
    }
    
    func getData() {
        FortniteJSONClient.fetchDailyItemshop { (result) in
            switch result {
            case .success(let json):
                self.dailyItems = json
                self.lastUpdated = self.dailyItems["lastupdate"] as! Int
                for i in self.dailyItems["items"] as! [[String : Any]] {
                    let item = i["item"] as! [String:Any]
                    let images = item["images"] as! [String:Any]
                    let backgroundImage = images["information"] as! String
                    let imageData = try? Data(contentsOf: URL(string: backgroundImage)!)
                    let img = UIImage(data: imageData!)
                    self.imagesArray.append(img!)
                }
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.registerCells()
                               
                // get rid of scrolling indicators
                self.collectionView.showsVerticalScrollIndicator = false
                self.collectionView.showsHorizontalScrollIndicator = false
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        collectionView.reloadData()
    }
    

}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell", for: indexPath) as? itemsColelctionView else {return UICollectionViewCell()}
            let time = Date(timeIntervalSince1970: TimeInterval(lastUpdated))
            let dateFormatter = DateFormatter()
   
            dateFormatter.dateFormat = "EEEE, MMMM d"
            let newDate = dateFormatter.string(from: time).capitalized
            cell.todaysDate.text = newDate
            cell.itemData = self.dailyItems
            cell.startCountTimer()
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemsCell", for: indexPath) as! itemsColelctionView
            
            cell.cellSize_1 = CGSize(width: self.view.frame.size.width - 50, height: 400)
     
            cell.imagesArray = imagesArray
  
            

            
            cell.colelctioView.delegate = cell
            cell.colelctioView.dataSource = cell
            cell.colelctioView.isPagingEnabled = true
            
      
            cell.colelctioView.collectionViewLayout = flowLayout
            cell.colelctioView.register(UINib(nibName: "Todaysitemshop", bundle: nil), forCellWithReuseIdentifier: "itemShopCell")
        
            cell.delegates = self
            cell.clipsToBounds = false
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cell.layer.shadowRadius = 12.0
            cell.layer.shadowOpacity = 0.7
            cell.layer.cornerRadius = 5
            cell.startTimer()
            
            return cell
        }
        
        else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "challangesCell", for: indexPath) as! itemsColelctionView
            cell.clipsToBounds = false
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cell.layer.shadowRadius = 12.0
            cell.layer.shadowOpacity = 0.7
            cell.layer.cornerRadius = 5

            return cell

        }
        else if indexPath.section == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comingCell", for: indexPath) as! itemsColelctionView
            cell.clipsToBounds = true
            cell.layer.masksToBounds = false

            cell.layer.cornerRadius = 5
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "statusCell", for: indexPath) as! itemsColelctionView

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return cellSize_1
        } else if indexPath.section == 1 {
            return cellSize_2
        }
        else if indexPath.section == 4 {
            return cellSize_3
        }
        return cellSize_1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let challangeVC = self.storyboard?.instantiateViewController(withIdentifier: "ChallangesViewController") as! ChallangesViewController
            self.navigationController?.pushViewController(challangeVC, animated: true)
        }
    }
}

extension ViewController: didPressDailyItemDelegats {

    func didPress(cell: itemsColelctionView) {
        let dailyItemsView = self.storyboard?.instantiateViewController(withIdentifier: "DailyItemsViewController") as! DailyItemsViewController
        let dailyitems = self.dailyItems["items"] as! [[String : Any]]
        dailyItemsView.itemsCount = (self.dailyItems["rows"] as! Int)
        dailyItemsView.dailyItems = dailyitems
        dailyItemsView.imagesArray = imagesArray
        self.navigationController?.pushViewController(dailyItemsView, animated: true)
    }
    
}
