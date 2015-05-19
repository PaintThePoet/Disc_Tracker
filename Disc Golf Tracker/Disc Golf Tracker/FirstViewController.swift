//
//  FirstViewController.swift
//  Disc Golf Tracker
//
//  Created by Michael Lee on 3/26/15.
//  Copyright (c) 2015 itsMorning. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource {

    var curGame: SingleGame!
    var methodDictator: Int = -3
    var highLighted: Int!
    var cv: UICollectionView!
    @IBOutlet var header: UILabel!
    @IBOutlet var ttlScore: UILabel!
    
    @IBOutlet var average: UIButton!
    @IBOutlet var best: UIButton!
    @IBOutlet var selected: UIButton!
    
    //Goes to TableView
    @IBOutlet var courseList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        header.text = ""
        ttlScore.text = ""
        view.backgroundColor = UIColorFromRGB("537325")
    }
    
    override func viewDidAppear(animated: Bool) {
        cv.reloadData()
        courseList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor {
        var scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }

    @IBAction func average_click(sender: UIButton) {
        if(courseMgr.pickerSelection != nil) {
            methodDictator = -2
            var avgStatMgr: StatMgr = StatMgr(givenCourse: courseMgr.pickerSelection)
            header.text = "Average Results"
            ttlScore.text = "Average Total: " + avgStatMgr.statAvgOverall().description
            cv.reloadData()
        }
    }
    
    @IBAction func best_click(sender: UIButton) {
        if(courseMgr.pickerSelection != nil) {
            methodDictator = -1
            header.text = "Best Results"
            var bestStatMgr: StatMgr = StatMgr(givenCourse: courseMgr.pickerSelection)
            ttlScore.text = "Best total: " + bestStatMgr.statBestOverall().description
            cv.reloadData()
        }
    }
    
    @IBAction func select_click(sender: UIButton) {
        if(highLighted != nil) {
            var desiredGame = courseMgr.pickerSelection.allGames[highLighted]
            header.text = desiredGame.date + " " + desiredGame.time
            methodDictator = highLighted
            ttlScore.text = "Score Total: " + courseMgr.pickerSelection.allGames[methodDictator].totalScore.description
            cv.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        cv = collectionView
        cv.backgroundColor = UIColorFromRGB("78A635")
        
        if(courseMgr.pickerSelection != nil) {
            return courseMgr.pickerSelection.numOfHoles
        }
        else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: colvwCell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as colvwCell
        cell.cellHoleNum.text = (indexPath.row + 1).description
        var myStatMgr: StatMgr = StatMgr(givenCourse: courseMgr.pickerSelection)
        if(methodDictator == -2) {
            var result = myStatMgr.statAvg()[indexPath.row]
            if(result.isNaN == false) {
                cell.cellScore.text = result.description
            }
            else {
                cell.cellScore.text = "..."
            }
        }
        else if(methodDictator == -1) {
            cell.cellScore.text = courseMgr.pickerSelection.eachHolesRecord[indexPath.row].description
        }
        else if(methodDictator >= 0) {
            cell.cellScore.text = courseMgr.pickerSelection.allGames[highLighted].holeArr[indexPath.row].description
        }
        else {
            cell.cellScore.text = "-"
        }
        cell.backgroundColor = UIColorFromRGB("365902")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        methodDictator = indexPath.row
    }
    
    //Next two methods related to UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(courseMgr.pickerSelection != nil) {
            return courseMgr.pickerSelection.allGames.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Default")
        if(courseMgr.pickerSelection != nil) {
            cell.textLabel?.text = courseMgr.pickerSelection.allGames[indexPath.row].date
            cell.detailTextLabel?.text = courseMgr.pickerSelection.allGames[indexPath.row].time
        }
        else {
            cell.textLabel?.text = "MM-dd-yyyy"
            cell.detailTextLabel?.text = "HH:mm"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        highLighted = indexPath.row
    }
    
    //Pop-up alert code
    func displayAlert(givenText: String) {
        let givenTitle = "Attention:"
        let givenMessage = givenText
        let okText = "OK"
        
        let alert = UIAlertController(title: givenTitle, message: givenMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(okayButton)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}