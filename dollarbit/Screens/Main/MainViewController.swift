//
//  MainViewController.swift
//  dollarbit
//
//  Created by Andrey Posnov on 21.01.2020.
//  Copyright © 2020 Andrey Posnov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var candleStickChart: CandlestickChartView!
    var timer: Timer?
    let candlestickGenerator = RandomCandlestickGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // demo generator candles
        //candleStickChart.candlestickArray = candlestickGenerator.randomCandlesticks(withNumber: 1)
        //candleStickChart.reset()
        WSManager.shared.connectToWebSocket()
        WSManager.shared.subscribeBtcUsd()
        self.drawCandleSticks()
    }
    
    
    @objc
    private func drawCandleSticks() {
        WSManager.shared.receiveData() { [weak self] (data) in
            guard let self = self else { return }
            guard let data = data else { return }
            if data.count > 0 {
                self.candleStickChart.candlestickArray = data
            }
            self.startWebSocketLoop()
            debugPrint("out candlesticks", data)
        }
    }

    
}

extension MainViewController {
    
    func startWebSocketLoop() {
      if timer == nil {
        timer = Timer.scheduledTimer(timeInterval: 59.0,
                                    target: self,
                                    selector: #selector(drawCandleSticks),
                                    userInfo: nil,
                                    repeats: true)
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
        }
      }
    }
    
}
