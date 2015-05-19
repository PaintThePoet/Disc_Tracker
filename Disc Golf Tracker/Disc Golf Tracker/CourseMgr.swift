//
//  CourseManager.swift
//  Disc Golf Tracker
//
//  Created by Michael Lee on 3/26/15.
//  Copyright (c) 2015 itsMorning. All rights reserved.
//

import UIKit

var courseMgr: CourseManager = CourseManager()


class CourseManager: NSObject {
   
    var pickerSelection: CourseProperties!
    
    var allCourses = [CourseProperties]()
    
    override init() {
        allCourses.append(CourseProperties(givenHoleCount: 0, givenCourseName: "Courses", givenDate: "mm-dd-yyyy"))
    }
    
    func addCourse(holeCount: Int, name: String) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy" //format style. Browse online to get a format that fits your needs.
        var dateString = dateFormatter.stringFromDate(NSDate())
        var displayDate = "Creation Date: " + dateString
        var tempClass: CourseProperties = CourseProperties(givenHoleCount: holeCount, givenCourseName: name, givenDate: displayDate)
        allCourses.append(tempClass)
    }
}


