//
//  SecondViewController.swift
//  Disc Golf Tracker
//
//  Created by Michael Lee on 3/26/15.
//  Copyright (c) 2015 itsMorning. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var curCourse: UIPickerView!
    @IBOutlet var tblHoles: UITableView!
    
    @IBOutlet var pickerLock: UIButton!
    @IBOutlet var wheelState: UILabel!
    
    @IBOutlet var coloredBox: UILabel!
    
    var dictValues = Dictionary<Int, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        courseMgr.pickerSelection = courseMgr.allCourses[0]

        //This registers my custom table cell with the tableview tblholes
        var nib = UINib(nibName: "vwTblCell", bundle: nil)
        tblHoles.registerNib(nib, forCellReuseIdentifier: "cell")
        
        view.backgroundColor = UIColorFromRGB("537325")
        self.curCourse.backgroundColor = UIColor.whiteColor()
        self.tblHoles.backgroundColor = UIColorFromRGB("78A635")
    }
    
    override func viewDidAppear(animated: Bool) {
        if(animated == true) {
            curCourse.reloadAllComponents()
            tblHoles.reloadData()
        }
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

    var index = 0

    @IBAction func lock_clicked(sender: UIButton) {
        if(index % 2 == 0) {
            curCourse.userInteractionEnabled = false
            self.wheelState.text = "Locked"
            
        }
        else {
            curCourse.userInteractionEnabled = true
            wheelState.text = "Unlocked"
        }
        index++
    }
    
    //Touching anywhere off the keyboard closes it for a textfield
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //UITextField Delegate works with UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //Next two func are related to tblHoles and load its tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(courseMgr.pickerSelection != nil) {
            return courseMgr.pickerSelection.numOfHoles
        }
        return 0
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: TblCell = self.tblHoles.dequeueReusableCellWithIdentifier("cell") as TblCell
        cell.lblHoleNumber.text = "Hole Number " + (indexPath.row + 1).description
        cell.lblHoleNumber.textColor = UIColorFromRGB("2A401E")
        cell.lblTextField.keyboardType = UIKeyboardType.NumberPad
        cell.lblTextField.text = self.dictValues[indexPath.row];
        
        cell.lblTextField.tag = indexPath.row
        cell.lblTextField.delegate = self
        cell.backgroundColor = UIColorFromRGB("78A635")
        cell.lblTextField.attributedPlaceholder = NSAttributedString(string:"0",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        return cell
    }
    
    @IBAction func submit_click(sender: UIButton) {
        var holesArr: [Int] = [Int](count: courseMgr.pickerSelection.numOfHoles, repeatedValue: 0)
        if(self.dictValues.keys.array.count == courseMgr.pickerSelection.numOfHoles) {
            
            
            let givenTitle = "Submit Following Game?"
            var givenMessage = ""
            let okText = "OK"
            let cancelText = "Cancel"
            
            let alert = UIAlertController(title: givenTitle, message: givenMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Default) { (ACTION) in
                for (row, value) in self.dictValues {
                    holesArr[row] = value.toInt()!
                }
                
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy"
                var dateString = dateFormatter.stringFromDate(NSDate())
                
                var date = NSDate()
                var calendar = NSCalendar.currentCalendar()
                var components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
                var hour = components.hour
                var minutes = components.minute
                
                var timeString = ""
                if(hour.description.toInt() > 12) {
                    hour = (hour.description.toInt()! - 12)
                    timeString = hour.description + ":" + minutes.description + " PM"
                }
                else {
                    timeString = hour.description + ":" + minutes.description + " AM"
                }
                
                courseMgr.pickerSelection.addGame(SingleGame(givenDate: dateString, givenTime: timeString, givenArr: holesArr))
                self.dictValues.removeAll(keepCapacity: true)
                self.view.endEditing(true)
                self.tblHoles.reloadData()
                self.tabBarController?.selectedIndex = 2;
            }
            
            let cancelButton = UIAlertAction(title: cancelText, style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(okayButton)
            alert.addAction(cancelButton)
            self.presentViewController(alert, animated: true, completion: nil)
            
            
            
            
            
            
            
            
        }
        else {
            self.displayAlert("Please correctly fill in all fields")

        }
    }
    
    //Pop-up alert code
    func displayAlert(givenText: String) {
        let givenTitle = "Attention:"
        let givenMessage = givenText
        let okText = "OK"
        
        let disAlert = UIAlertController(title: givenTitle, message: givenMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
        disAlert.addAction(okayButton)
        
        presentViewController(disAlert, animated: true, completion: nil)
    }
    
    //Ian wrote this code. Don't touch it!!! Has to do with updating textfields and what is stored in memory
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        self.dictValues[textField.tag] = newString;
        
        return true
    }
    
    //Next Four methods come from UIPickerViewDelegate
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component.
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return courseMgr.allCourses.count
    }
    //Generates all course names in picker component
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return courseMgr.allCourses[row].courseName
    }
    //Selects course currently in picker window
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var itemSelected = courseMgr.allCourses[row]
        courseMgr.pickerSelection = itemSelected
        
        curCourse.userInteractionEnabled = false
        self.wheelState.text = "Locked"
        index++
        
        dictValues.removeAll(keepCapacity: true)
        
        self.tabBarController?.selectedIndex = 2;
        self.tabBarController?.selectedIndex = 1;
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = courseMgr.allCourses[row].courseName
        var myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:UIColor.blackColor()])
        return myTitle
    }
}

