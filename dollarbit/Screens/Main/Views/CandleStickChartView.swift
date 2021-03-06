//
//  CandleStickChartView.swift
//  dollarbit
//
//  Created by Andrey Posnov on 23.01.2020.
//  Copyright © 2020 Andrey Posnov. All rights reserved.
//


import UIKit

enum CandlestickChartViewOverflowMode {
    case scaleToFit
    case scroll
}


class CandlestickChartView: UIView {
    
    static let HorizontalSpacing: CGFloat = 5
    static let DefaultCandlestickWidth: CGFloat = 30
    static let CandlestickCenterLineWidth: CGFloat = 3
    
    var overflowMode: CandlestickChartViewOverflowMode = .scroll {
        didSet {
            reset()
        }
    }
    
    var candlestickArray = [Candlestick]() {
        didSet {
            reset()
        }
    }
    
    func reset() {
        setNeedsDisplay()
        translationBase = CGPoint.zero
        translation = CGPoint.zero
    }
    
    
    // MARK: Scroll
    
    private var gestureRecognizer: UIPanGestureRecognizer?
    private var translationBase: CGPoint = CGPoint.zero
    private var translation: CGPoint = CGPoint.zero
    
    private func enableGestures() {
        if gestureRecognizer == nil {
            gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CandlestickChartView.pan(_:)))
            addGestureRecognizer(gestureRecognizer!)
        }
    }
    
    private func disableGestures() {
        if let gestureRecognizer = gestureRecognizer {
            removeGestureRecognizer(gestureRecognizer)
            self.gestureRecognizer = nil
        }
    }
    
    @objc func pan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let grTranslation = gestureRecognizer.translation(in: self)
        translation = CGPoint(x: translationBase.x + grTranslation.x, y: translationBase.y + grTranslation.y)
        if case .ended = gestureRecognizer.state {
            translationBase = translation
        }
        setNeedsDisplay()
    }
    
    
    // MARK: Drawing
    
    // forces redraw on orientation change
    override func layoutSubviews() {
        super.layoutSubviews()
        reset()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        context.applyTransformToSwitchToBottomLeftOriginCoordinateSystem(in: self)
        transformContextToZoom(context)
        
        context.translateBy(x: translation.x, y: 0)
        let candlestickWidth = calculateCandlestickWidthConsideringOverflow()
        
        for (index, candlestick) in candlestickArray.enumerated() {
            draw(candlestick, x: candlestickX(index: index, width: candlestickWidth), width: candlestickWidth)
        }
    }
    
    private func transformContextToZoom(_ context: CGContext) {
        let priceRange = candlestickArray.priceRange()
        let aspectRatio = self.bounds.height / CGFloat(priceRange)
        context.translateBy(x: 0, y: -CGFloat(candlestickArray.lowestPrice()) * aspectRatio)
        context.scaleBy(x: 1, y: aspectRatio)
    }
    
    private func calculateCandlestickWidthConsideringOverflow() -> CGFloat {
        let totalSpacing = CGFloat(candlestickArray.count - 1) * CandlestickChartView.HorizontalSpacing
        let proposedCandlestickWidth = (self.bounds.size.width - totalSpacing) / CGFloat(candlestickArray.count)
        let overflow = proposedCandlestickWidth < CandlestickChartView.DefaultCandlestickWidth
        if overflow {
            switch overflowMode {
            case .scaleToFit:
                disableGestures()
                return proposedCandlestickWidth
            case .scroll:
                enableGestures()
                return CandlestickChartView.DefaultCandlestickWidth
            }
        } else {
            disableGestures()
            return CandlestickChartView.DefaultCandlestickWidth
        }
    }
    
    private func candlestickX(index: Int, width: CGFloat) -> CGFloat {
        return CGFloat(index) * width + CGFloat(index) * CandlestickChartView.HorizontalSpacing
    }
    
    private func draw(_ candlestick: Candlestick, x: CGFloat, width: CGFloat) {
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(candlestick.trend.color().cgColor)
        
        let rect = CGRect(x: x, y: CGFloat(candlestick.lowPrice), width: width, height: CGFloat(candlestick.highPrice - candlestick.lowPrice))
        
        let centerLine = rect.insetBy(dx: (rect.width - CandlestickChartView.CandlestickCenterLineWidth) / 2, dy: 0)
        context.fill(centerLine)
        
        let lowOpenClosePrice = CGFloat(min(candlestick.openPrice, candlestick.closePrice))
        let highOpenClosePrice = CGFloat(max(candlestick.openPrice, candlestick.closePrice))
        
        let bodyRect = CGRect(x: rect.origin.x, y: lowOpenClosePrice, width: rect.width, height: highOpenClosePrice - lowOpenClosePrice)
        context.fill(bodyRect)
    }

}


extension Optional where Wrapped == CandlestickTrend {
    
    func color() -> UIColor {
        switch self {
        case nil:
            return UIColor.black
        case CandlestickTrend.bullish?:
            return UIColor.green
        case CandlestickTrend.bearish?:
            return UIColor.red
        }
    }
    
}


extension CGContext {
    
    func applyTransformToSwitchToBottomLeftOriginCoordinateSystem(in view: UIView) {
        translateBy(x: 0, y: view.bounds.height)
        scaleBy(x: 1, y: -1)
    }
    
}
