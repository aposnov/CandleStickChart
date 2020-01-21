//
//  MainViewController.swift
//  dollarbit
//
//  Created by Andrey Posnov on 21.01.2020.
//  Copyright © 2020 Andrey Posnov. All rights reserved.
//

import UIKit
import CFNetwork

class MainViewController: UIViewController {
    
    let webSocketTask = URLSession(configuration: .default).webSocketTask(with: URL(string: "wss://quotes.eccalls.mobi:18400/")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectToWebSocket()
        self.subscribeBtcUsd()
        self.receiveData()
    }
    
    private func connectToWebSocket() {
        webSocketTask.resume()
    }
    
    private func subscribeBtcUsd() {
        let message = URLSessionWebSocketTask.Message.string("SUBSCRIBE: BTCUSD")
        webSocketTask.send(message) { error in
            if let error = error {
                print("WebSocket couldn’t send message because: \(error)")
            }
        }
    }
    
    private func unSubscribeBtcUsd() {
           let message = URLSessionWebSocketTask.Message.string("UNSUBSCRIBE: BTCUSD")
           webSocketTask.send(message) { error in
               if let error = error {
                   print("WebSocket couldn’t send message because: \(error)")
               }
           }
       }
    
    private func receiveData() {
      webSocketTask.receive { result in
        switch result {
            case .failure(let error):
              print("Error in receiving message: \(error)")
            case .success(let message):
              switch message {
                case .string(let text):
                    print("Received string: \(text)")
                case .data(let data):
                    print("Received data: \(data)")
              @unknown default:
                debugPrint("Unknown message")
              }
          self.receiveData()
        }
      }
    }
    
}

