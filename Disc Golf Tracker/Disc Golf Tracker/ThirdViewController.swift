//
//  ThirdViewController.swift
//  Disc Golf Tracker
//
//  Created by Michael Lee on 3/26/15.
//  Copyright (c) 2015 itsMorning. All rights reserved.
//

import UIKit

protocol ThirdDelegateProtocol {
    func pushThirdUpdate()
}

class ThirdViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //These are text fields
    @IBOutlet var courseTitle: UITextField!
    @IBOutlet var holeCount: UITextField!
    
    //Goes to TableView
    @IBOutlet var courseList: UITableView!
    
    //Decorative
    @IBOutlet var solidColor: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        holeCount.keyboardType = UIKeyboardType.NumberPad
        
        view.backgroundColor = UIColorFromRGB("537325")
        self.solidColor.backgroundColor = UIColorFromRGB("78A635")
        self.solidColor.text = ""
        self.courseList.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        if(animated == true) {
            courseList.reloadData()
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
    
    @IBAction func createCourseConfirmation(sender: UIButton) {
        var num = holeCount.text.toInt()
        
        if(courseTitle.text != "" && num != nil)  {
            let givenTitle = "Create Following Course?"
            var givenMessage = "Course Name: " + courseTitle.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).stringByReplacingOccurrencesOfString(" ", withString: "_").capitalizedString
            while(countElements(givenMessage) < 38) {
                if(countElements(givenMessage)%2 == 0) {
                    givenMessage = givenMessage + "."
                }
                else {
                    givenMessage = "." + givenMessage
                }
            }
            givenMessage += " Number of Holes: " + holeCount.text
            let okText = "OK"
            let cancelText = "Cancel"
            
            let alert = UIAlertController(title: givenTitle, message: givenMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Default) { (ACTION) in
                self.btnCreateCourse_Click()
            }
            let cancelButton = UIAlertAction(title: cancelText, style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(okayButton)
            alert.addAction(cancelButton)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    
        else {
            displayAlert("Fill in blank field(s)")
    
        }
    }
    
    //Submission of new course
    func btnCreateCourse_Click() {
        
        var num = holeCount.text.toInt()
            
        courseMgr.addCourse(num!, name: courseTitle.text.capitalizedString)
        
        self.view.endEditing(true)
        
        courseTitle.text = ""
        holeCount.text = ""
        
        courseList.reloadData()
        
        //moves tab back to first view
        self.tabBarController?.selectedIndex = 1;

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
    
    //Touching anywhere off the keyboard closes it for a textfield
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //UITextField Delegate works with UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Next two methods related to UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseMgr.allCourses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Default")
        
        cell.textLabel?.text = courseMgr.allCourses[indexPath.row].courseName
        cell.detailTextLabel?.text = courseMgr.allCourses[indexPath.row].date
        
        return cell
    }
}
