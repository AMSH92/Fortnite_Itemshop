//
//  ChallangesViewController.swift
//  FortniteItemShop
//
//  Created by Abdullah Alsharif on 1/22/19.
//  Copyright © 2019 Alsharif. All rights reserved.
//

import UIKit
import AudioToolbox


class ChallangesDetials: UICollectionViewCell {
    @IBOutlet weak var challange: UILabel!
    @IBOutlet weak var starts: UILabel!
    @IBOutlet weak var hard: UILabel!
    @IBOutlet weak var total: UILabel!
    
}

class ChallangesCollectionCell: UICollectionViewCell {
    @IBOutlet weak var mainView: GradientView!
    @IBOutlet weak var currentSeason: UILabel!
    @IBOutlet weak var currentWeek: UILabel!
    @IBOutlet weak var numberOfWeeks: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var currentWeekTitle: UILabel!
    
    func shake(duration: CFTimeInterval = 0.3, pathLength: CGFloat = 15) {
        let position = self.center
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: position.x, y: position.y))
        path.addLine(to: CGPoint(x: position.x - pathLength, y: position.y))
        path.addLine(to: CGPoint(x: position.x + pathLength, y: position.y))
        path.addLine(to: CGPoint(x: position.x - pathLength, y: position.y))
        path.addLine(to: CGPoint(x: position.x + pathLength, y: position.y))
        path.addLine(to: CGPoint(x: position.x, y: position.y))
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.path = path.cgPath
        positionAnimation.duration = duration
        positionAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        CATransaction.begin()
        self.layer.add(positionAnimation, forKey: nil)
        CATransaction.commit()
    }
    
}
class ChallangesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var cellSize_1 = CGSize()
    var titleCellSize = CGSize()
    var currentWeekSize = CGSize()

    var cellSize = CGFloat()
    var weeklyData: [String:Any] = [:]
    var numberOfChallanges: Int?
    let cellSpacingHeight: CGFloat = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        getChallangesWeek()
    }

    func registerTableView() {
        cellSize_1 = CGSize(width: view.frame.size.width - 20, height: 150)
        currentWeekSize = CGSize(width: view.frame.size.width - 10, height: 180)
        titleCellSize = CGSize(width: view.frame.size.width - 10, height: 88)
        collectionView.register(UINib(nibName: "challanges", bundle: nil), forCellWithReuseIdentifier: "challangesCell")
         collectionView.register(UINib(nibName: "currentWeek", bundle: nil), forCellWithReuseIdentifier: "currentWeekCell")
        collectionView.register(UINib(nibName: "title", bundle: nil), forCellWithReuseIdentifier: "titleCell")
    }
    
    func getChallangesWeek() {
        FortniteJSONClient.fetchWeeklyChallanges { (result) in
            switch result {
            case .success(let json):
                print(json)
                self.weeklyData = json
                let challanges = json["challenges"] as! [String:Any]
                self.numberOfChallanges = challanges.count
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension ChallangesViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 1
        }
        return numberOfChallanges ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "titleCell", for: indexPath) as! ChallangesCollectionCell
            let currentweek = self.weeklyData["currentweek"] as! Int
            let currentSeason = self.weeklyData["season"] as! Int
            cell.currentWeekTitle.text = "CURRENT WEEK  \(currentweek)"
            cell.currentSeason.text = "SEASON \(currentSeason)"
    
            return cell
        }
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "currentWeekCell", for: indexPath) as! ChallangesCollectionCell
            let currentweek = self.weeklyData["currentweek"] as! Int
            cell.currentWeek.text = "\(currentweek)"
            cell.clipsToBounds = false
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cell.layer.shadowRadius = 12.0
            cell.layer.shadowOpacity = 0.7
            return cell
        }
       
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "challangesCell", for: indexPath) as! ChallangesCollectionCell
            let challanges = self.weeklyData["challenges"] as! [String:Any]
            var weeks:[Int] = []
        
            for i in challanges.count {
                weeks.append(i)

            }
        
            let weekData = challanges["week\(weeks[indexPath.row] + 1)"] as! [[String:Any]]
        
            if weekData.count == 0 {
            cell.mainView.topColor = UIColor.gray
            cell.mainView.bottomColor = UIColor.darkGray
            }
        
            cell.numberOfWeeks.text = "\(weeks[indexPath.row] + 1)"
            cell.clipsToBounds = false
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cell.layer.shadowRadius = 12.0
            cell.layer.shadowOpacity = 0.7
        
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.section == 2 {
              let detialsView = self.storyboard?.instantiateViewController(withIdentifier: "ViewChallangeViewController") as! ViewChallangeViewController
            let selectedWeek = indexPath.row + 1
            let challanges = self.weeklyData["challenges"] as! [String:Any]
            let weeks = challanges["week\(selectedWeek)"] as! [[String:Any]]
            
            if weeks.count != 0 {
                detialsView.week = selectedWeek
                detialsView.challanges = weeks
                self.present(detialsView, animated: true, completion: nil)
            }
            
            else {
                let cell = collectionView.cellForItem(at: indexPath) as! ChallangesCollectionCell
                cell.shake()
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

            }
        }
        if indexPath.section == 1 {
              let detialsView = self.storyboard?.instantiateViewController(withIdentifier: "ViewChallangeViewController") as! ViewChallangeViewController
            let currentweek = self.weeklyData["currentweek"] as! Int
            let challanges = self.weeklyData["challenges"] as! [String:Any]
            let weeks = challanges["week\(currentweek)"] as! [[String:Any]]
            detialsView.week = currentweek
            detialsView.challanges = weeks
            self.present(detialsView, animated: true, completion: nil)
        }
        else {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return titleCellSize
        }
        if indexPath.section == 1 {
            return currentWeekSize
        }
        return cellSize_1
    }
}
