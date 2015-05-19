//
//  SingleGame.swift
//  Disc Golf Tracker
//
//  Created by Michael Lee on 4/11/15.
//  Copyright (c) 2015 itsMorning. All rights reserved.
//

import UIKit

class SingleGame: NSObject {
    var holeArr: [Int]
    var date: String
    var time: String
    var totalScore: Int = 0
    
    init(givenDate: String, givenTime: String, givenArr: [Int]) {
        date = givenDate
        time = givenTime
        holeArr = givenArr
        for number in givenArr {
            totalScore += number
        }
    }
}