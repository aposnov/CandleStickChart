//
//  CandleStick.swift
//  dollarbit
//
//  Created by Andrey Posnov on 23.01.2020.
//  Copyright © 2020 Andrey Posnov. All rights reserved.
//

import Foundation

struct Candlestick {
    
    let lowPrice: Float
    let highPrice: Float
    let openPrice: Float
    let closePrice: Float
    
}

// MARK: Trend
enum CandlestickTrend {
    case bullish
    case bearish
}

extension Candlestick {
    
    var trend: CandlestickTrend? {
        guard openPrice != closePrice else { return nil }
        return openPrice < closePrice ? .bullish : .bearish
    }
    
}

extension Array where Element == Candlestick {
    
    func lowestPrice() -> Float {
        if self.count > 0 {
            return reduce(self[0].lowPrice) { (currentLowestPrice, candlestick) -> Float in
                return Swift.min(currentLowestPrice, candlestick.lowPrice)
            }
        }
        return 0
    }
    
    func highestPrice() -> Float {
        if self.count > 0 {
        return reduce(self[0].highPrice) { (currentHighestPrice, candlestick) -> Float in
            return Swift.max(currentHighestPrice, candlestick.highPrice)
        }
        } else { return 0 }
    }
    
    func priceBounds() -> (Float, Float) {
        return (lowestPrice(), highestPrice())
    }
    
    func priceRange() -> Float {
        let (lowestCandlestickPrice, highestCandlestickPrice) = priceBounds()
        return highestCandlestickPrice - lowestCandlestickPrice
    }
    
}
