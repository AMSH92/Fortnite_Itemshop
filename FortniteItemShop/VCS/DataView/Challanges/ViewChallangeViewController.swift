//
//  ViewChallangeViewController.swift
//  FortniteItemShop
//
//  Created by Abdullah Alsharif on 1/22/19.
//  Copyright © 2019 Alsharif. All rights reserved.
//

import UIKit

class ViewChallangeViewController: UIViewController {
    
    @IBOutlet weak var collectioView: UICollectionView!
    @IBOutlet weak var challangeWeek: UILabel!
    
    var cellSize_1 = CGSize()
    var challanges:[ [String:Any]] = [[:]]
    var week: Int?
    
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        challangeWeek.text = "WEEK\(week!)"
        registerCell()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer!)
        
    }

    func registerCell(){
        cellSize_1 = CGSize(width: collectioView.frame.size.width - 40, height: 160)
        collectioView.register(UINib(nibName: "challangesDataCell", bundle: nil), forCellWithReuseIdentifier: "detialsCell")
        collectioView.delegate = self
        collectioView.dataSource = self
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        
        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            view.frame.origin = CGPoint(
                x: translation.x,
                y: translation.y
            )
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if velocity.y >= 1500 {
                UIView.animate(withDuration: 0.2
                    , animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.origin.x,
                            y: self.view.frame.size.height
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                })
            }
        }
    }
}

extension ViewChallangeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challanges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectioView.dequeueReusableCell(withReuseIdentifier: "detialsCell", for: indexPath) as! ChallangesDetials
        let challange = self.challanges[indexPath.row]["challenge"] as! String
        let totla = self.challanges[indexPath.row]["total"] as! Int
        let stars = self.challanges[indexPath.row]["stars"] as! Int
        let difficulty = self.challanges[indexPath.row]["difficulty"] as! String
        
        cell.challange.text = challange
        cell.total.text = "0/\(totla)"
        
        if difficulty != "hard" {
            cell.hard.isHidden = true
        }
        else {
            cell.hard.text = "(\(difficulty))"

        }
        cell.starts.text = "\(stars)"

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize_1
    }
}
