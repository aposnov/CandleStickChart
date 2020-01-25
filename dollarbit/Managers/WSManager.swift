//
//  WSManager.swift
//  dollarbit
//
//  Created by Andrey Posnov on 22.01.2020.
//  Copyright © 2020 Andrey Posnov. All rights reserved.
//

import Foundation

class WSManager {
    public static let shared = WSManager()
    private init(){}
    
    private var candlestickArray = [Candlestick]()
    private var lowerPriceCandle: Float = 0.0
    private var higherPriceCandle: Float = 0.0
    private var openPriceCandle: Float = 0.0
    private var closePriceCandle: Float = 0.0
    
    let webSocketTask = URLSession(configuration: .default).webSocketTask(with: URL(string: "wss://quotes.eccalls.mobi:18400/")!)
    
    public func connectToWebSocket() {
        webSocketTask.resume()
        self.receiveData() { _ in }
    }
    
    public func subscribeBtcUsd() {
        let message = URLSessionWebSocketTask.Message.string("SUBSCRIBE: BTCUSD")
        webSocketTask.send(message) { error in
            if let error = error {
                print("WebSocket couldn’t send message because: \(error)")
            }
        }
    }
    
    public func unSubscribeBtcUsd() {
           let message = URLSessionWebSocketTask.Message.string("UNSUBSCRIBE: BTCUSD")
           webSocketTask.send(message) { error in
               if let error = error {
                   print("WebSocket couldn’t send message because: \(error)")
               }
           }
       }
    
    func receiveData(completion: @escaping ([Candlestick]?) -> Void) {
      webSocketTask.receive { result in
        switch result {
            case .failure(let error):
              print("Error in receiving message: \(error)")
            case .success(let message):
              switch message {
                case .string(let text):
                    TimeManager.shared.start()
                    print("Received string: \(text)")
                    let data: Data? = text.data(using: .utf8)
                    let tickData = try? responseModelChart.decode(from: data ?? Data())
                    for tick in tickData?.ticks ?? [] {
                        let bidPrice = tick.bidPrice?.floatValue ?? 0.0
                        if TimeManager.shared.elapsedTime > 1 && TimeManager.shared.elapsedTime < 3 {

                            self.openPriceCandle = bidPrice
                            self.lowerPriceCandle = bidPrice
                            self.higherPriceCandle = bidPrice
                        }
                        
                        if bidPrice > self.higherPriceCandle && bidPrice > self.lowerPriceCandle {
                            self.higherPriceCandle = bidPrice
                        }
                        
                        if bidPrice < self.lowerPriceCandle && bidPrice < self.higherPriceCandle  {
                            self.lowerPriceCandle = bidPrice
                        }
                        
                        if TimeManager.shared.elapsedTime > 59 {
                            self.closePriceCandle = bidPrice
                        }
                    }
                case .data(let data):
                    print("Received data: \(data)")
              @unknown default:
                debugPrint("Unknown message")
              }
              
              debugPrint("hi there!", TimeManager.shared.elapsedTime)
              if TimeManager.shared.elapsedTime > 60 {
                    TimeManager.shared.stop()
                self.candlestickArray.append(Candlestick(lowPrice: self.lowerPriceCandle, highPrice: self.higherPriceCandle, openPrice: self.openPriceCandle, closePrice: self.closePriceCandle))
                    TimeManager.shared.start()
              }
              
              self.receiveData() {_ in }
        }
      }
        completion(self.candlestickArray)
    }
    
    
}
