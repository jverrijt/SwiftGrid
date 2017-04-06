//
//  SwiftGridUtil.swift
//  SwiftGrid
//
//  Created by Joost Verrijt on 01/04/15.
//  Copyright (c) 2015 Metamotifs. All rights reserved.
//

import UIKit

class SwiftGridUtil: NSObject
{
    /**
    */
    class func randomColor() -> UIColor
    {
        let hue = CGFloat(Double(arc4random()).truncatingRemainder(dividingBy: 256) / 256.0)
        let sat = CGFloat(Double(arc4random()).truncatingRemainder(dividingBy: 128.0) / 256.0) + 0.5
        let brt = CGFloat(Double(arc4random()).truncatingRemainder(dividingBy: 128.0) / 256.0) + 0.5
       
        let color = UIColor(hue: hue, saturation: sat, brightness: brt, alpha: 1.0)
        
        return color
    }
    
    /**
    Draw the grid and the tiles for debug purposes
    */
    class func drawDebugGrid(_ rect: CGRect, contentView: SwiftGridContentView)
    {
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.clear(rect)
        
        UIColor.white.setFill()
        ctx?.fill(rect)
        
        var row = 0, col = 0
        // center the grid
        let xOffset = (rect.size.width - floor(rect.size.width / contentView.cellSize.width)
            * contentView.cellSize.width) / 2
        
        var x:CGFloat = xOffset, y:CGFloat = 0.0
        
        while row < contentView.rows {
            if col >= contentView.cols {
                y += contentView.cellSize.height
                x = xOffset
                col = 0
                row += 1
            }
            
            if row >= contentView.rows {
                break
            }
            
            contentView.gridOutlineColor.setStroke()
            ctx?.setLineWidth(contentView.gridOutlineLineWidth);
            ctx?.stroke(CGRect(x: x, y: y, width: contentView.cellSize.width, height: contentView.cellSize.height));
            
            if let debugTile = contentView.tile(atPosition: GridPosition(row: row, col: col)) {
                
                if debugTile.debugColor == nil {
                    debugTile.debugColor = SwiftGridUtil.randomColor()
                }
                
                debugTile.debugColor?.setFill()
                
            } else {
                UIColor.white.setFill()
            }
            
            let tileRect = CGRect(x: x, y: y, width: contentView.cellSize.width, height: contentView.cellSize.height)
            ctx?.fill(tileRect.insetBy(dx: 4.0, dy: 4.0))
            
            x += contentView.cellSize.width;
            col += 1
        }
    }
}
