//
//  StatMgr.swift
//  Disc Golf Tracker
//
//  Created by Michael Lee on 4/4/15.
//  Copyright (c) 2015 itsMorning. All rights reserved.
//

import UIKit

class StatMgr: NSObject {
   
    var course: CourseProperties!
    
    init(givenCourse: CourseProperties) {
        self.course = givenCourse
    }
    
    func statAvg() -> [Double] {
        var binArr = Array<Array<Int>>(count: course.numOfHoles, repeatedValue: Array<Int>(count: course.allGames.count, repeatedValue:0));
        
        var gameNumIndex: Int = 0
        for game in course.allGames {
            var holeNumIndex: Int = 0
            for hole in game.holeArr {
                binArr[holeNumIndex][gameNumIndex] = hole
                holeNumIndex++
            }
            gameNumIndex++
        }
        var resultArr: [Double] = [Double](count: course.numOfHoles, repeatedValue: 0.0)
        var index = 0
        for holeHistory in binArr {
            var total: Double = 0.0
            for singleInstance in holeHistory {
                total += Double(singleInstance)
            }
            var avg: Double = total/Double(holeHistory.count)
            resultArr[index] = Double(round(10*avg)/10)
            index++
        }
        return resultArr
    }
    
    func statBestOverall() -> Int {
        var bestOverallGame: Int = 0
        for game in course.allGames {
            if(game.totalScore > bestOverallGame) {
                bestOverallGame = game.totalScore
            }
        }
        return bestOverallGame
    }
    
    func statAvgOverall() -> Double {
        var sumOfGames = 0.0
        for game in course.allGames {
            sumOfGames += Double(game.totalScore)
        }
        var avg = sumOfGames/Double(course.allGames.count)
        var toTenthsPlace: Double = Double(round(10*avg)/10)
        return toTenthsPlace
    }
}
