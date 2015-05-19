//
//  CourseProperties.swift
//  Disc Golf Tracker
//
//  Created by Michael Lee on 4/3/15.
//  Copyright (c) 2015 itsMorning. All rights reserved.
//

import UIKit

class CourseProperties: NSObject {
    var numOfHoles: Int
    var courseName: String
    var date: String
    var allGames: [SingleGame] = []
    
    //Get rid of this. Broken because if someone misentered a value, then deleted the game, this record wouldn't update.
    var eachHolesRecord: [Int]!
    /**
        Unrelated to this class but other bugs are
        - Having the picker wheel on a course on tab 2, then deleting it in tab 3
        - Highlighting a game in tableview on tab 1, changing the pickerwheel course on tab 2, then hitting select on tab 1
    */
    
    init(givenHoleCount: Int, givenCourseName: String, givenDate: String) {
        self.numOfHoles = givenHoleCount
        self.courseName = givenCourseName
        self.date = givenDate
        eachHolesRecord = [Int](count: givenHoleCount, repeatedValue: 99)
    }
    
    func addGame(givenGame: SingleGame) {
        var index = 0
        for hole in givenGame.holeArr {
            if(hole < eachHolesRecord[index]) {
                eachHolesRecord[index] = hole
            }
            index++
        }
        allGames.append(givenGame)
    }
}
