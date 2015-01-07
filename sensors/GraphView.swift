//
//  GraphView.swift
//  sensors
//
//  Created by Maurizio Tidei on 19/12/14.
//  Copyright (c) 2014 contexagon. All rights reserved.
//

import Foundation

class GraphView: UIView {
    
    var callNo = 0
    
    var buffer:CGContext!
    
    var xStart = 0.0
    
    var xScale = 50.0 // Seconds * xScale = Pixels
    
    var yScale = 150.0
    
    var yCenter = 0.0
    
    var graphWidth = 0.0
    
    var graphHeight = 0.0
    
    // the dynamic thresholds to be drawn
    var min:Double? = nil
    var max:Double? = nil
    var threshold:Double? = nil /* {
        didSet {
            if(max != nil && min != nil) {
                
                var divisor = max! - min!
                if divisor < 0.1 {
                    divisor = 0.1
                }
                
                yScale = graphHeight / 2 / divisor
            }
        }
    }*/
    
    let minColor = UIColor(red: 1, green: 0.5, blue: 0, alpha: 0.5).CGColor
    let maxColor = UIColor(red: 1, green: 0.5, blue: 0, alpha: 0.5).CGColor
    let thresholdColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5).CGColor
    
    // the last value
    var lastY = 0.0
    
    
    func initBuffer() {
    
        let rect = self.frame
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        buffer = CGBitmapContextCreate(nil, UInt(rect.size.width), UInt(rect.size.height), 8, 0, colorSpace, bitmapInfo)
        
        graphWidth = Double(rect.size.width)
        graphHeight = Double(rect.size.height)
        
        yCenter = Double(rect.size.height / 2.0)
    }
    
    
    override func drawRect(rect: CGRect) {
        
        if(buffer == nil) {
            initBuffer()
        }
        
        
        // display background buffer
        let context = UIGraphicsGetCurrentContext()
        var image = CGBitmapContextCreateImage(buffer)
        CGContextDrawImage(context, rect, image)
    }
    
    
    func addValue(#x: Double, y: Double) {
        
        if(xStart == 0) {
            xStart = x
        }
        
        // draw on buffer
        UIGraphicsPushContext(buffer)
        
        var x = (x - xStart) * xScale
        let y = transformY(y) + 0.5
        
        // check if x exceeds the right border
        if x > graphWidth {
            x = x % graphWidth
            
            CGContextSetFillColorWithColor(buffer, UIColor.whiteColor().CGColor)
            CGContextFillRect(buffer, CGRect(x: x, y: 0, width: 20, height: graphHeight))
        }
        
        // draw min, max and threshold if set
        if let min = self.min {
            CGContextSetFillColorWithColor(buffer, minColor)
            CGContextFillRect(buffer, CGRect(x: x, y: transformY(min), width: 1, height: 1))
        }
        
        if let max = self.max {
            CGContextSetFillColorWithColor(buffer, maxColor)
            CGContextFillRect(buffer, CGRect(x: x, y: transformY(max), width: 1, height: 1))
        }
        
        if let threshold = self.threshold {
            CGContextSetFillColorWithColor(buffer, thresholdColor)
            CGContextFillRect(buffer, CGRect(x: x, y: transformY(threshold), width: 1, height: 1))
        }
        
        // draw the new value
        if(lastY != 0) {
            CGContextSetStrokeColorWithColor(buffer, UIColor.blueColor().CGColor)
            CGContextBeginPath(buffer)
            CGContextMoveToPoint(buffer, CGFloat(x-1), CGFloat(lastY))
            CGContextAddLineToPoint(buffer, CGFloat(x), CGFloat(y))
            CGContextStrokePath(buffer)
        }
            
        UIGraphicsPopContext()
        
        setNeedsDisplay()
        
        lastY = y
    }
    
    private func transformY(y:Double) -> Double {
        
        return round(y * yScale + yCenter)
    }
    
}