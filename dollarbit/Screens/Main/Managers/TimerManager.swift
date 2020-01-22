//
//  TimerManager.swift
//  dollarbit
//
//  Created by Andrey Posnov on 23.01.2020.
//  Copyright © 2020 Andrey Posnov. All rights reserved.
//

import Foundation

class TimeManager: NSObject {
    private override init() {}
    public static let shared = TimeManager()
    
    public var counter = 0.0
    private var timer = Timer()
    private var startTime: Date?
    
    var elapsedTime: TimeInterval {
        if let startTime = self.startTime {
            return Date().timeIntervalSince1970 - startTime.timeIntervalSince1970
        } else {
            return 0
        }
    }
    
    var isRunning: Bool {
        return startTime != nil
    }
    
    func start() {
        if let startTimeTimestamp = UserDefaults.standard.string(forKey: "timerStart") {
            startTime = Date(timeIntervalSince1970: TimeInterval(startTimeTimestamp) ?? 0)
        } else {
            startTime = Date()
            guard let timeStart = startTime?.timeIntervalSince1970 else { return }
            UserDefaults.standard.set("\(timeStart)", forKey: "timerStart")
        }
    }
    
    func stop() {
        startTime = nil
        UserDefaults.standard.removeObject(forKey: "timerStart")
    }
    
}
