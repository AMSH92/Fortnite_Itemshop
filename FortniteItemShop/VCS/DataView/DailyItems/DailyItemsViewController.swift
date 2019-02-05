//
//  DailyItemsViewController.swift
//  FortniteItemShop
//
//  Created by Abdullah Alsharif on 1/21/19.
//  Copyright © 2019 Alsharif. All rights reserved.
//

import UIKit
import ViewAnimator

class DailyImagesCell: UICollectionViewCell {
    @IBOutlet weak var itemImages: UIImageView!
    @IBOutlet weak var pages: UIPageControl!
}

class DailyItemsCell: UICollectionViewCell {
    @IBOutlet weak var itemImages: UIImageView!
}

class DailyItemsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var itemsCount: Int?
    var dailyItems:[[String:Any]] = [[:]]
    var cellSize_1 = CGSize()
    var imagesArray:[UIImage] = []
   
    var images: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.register(UINib(nibName: "dailyItems", bundle: nil), forCellWithReuseIdentifier: "dailyCell")

        cellSize_1 = CGSize(width: view.frame.size.width - 50, height: 400)

    }

}

extension DailyItemsViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dailyCell", for: indexPath) as! DailyItemsCell

        cell.itemImages.image = self.imagesArray[indexPath.row]
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.layer.shadowRadius = 12.0
        cell.layer.shadowOpacity = 0.7
        cell.layer.cornerRadius = 60
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize_1
    }
    
}

extension Int: Sequence {
    public func makeIterator() -> CountableRange<Int>.Iterator {
        return (0..<self).makeIterator()
    }
}
