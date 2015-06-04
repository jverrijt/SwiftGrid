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
        var hue = CGFloat(Double(arc4random()) % 256 / 256.0)
        var sat = CGFloat(Double(arc4random()) % 128.0 / 256.0) + 0.5
        var brt = CGFloat(Double(arc4random()) % 128.0 / 256.0) + 0.5
       
        var color = UIColor(hue: hue, saturation: sat, brightness: brt, alpha: 1.0)
        
        return color
    }
    
    /**
    Draw the grid and the tiles for debug purposes
    */
    class func drawDebugGrid(rect: CGRect, contentView: SwiftGridContentView)
    {
        var ctx = UIGraphicsGetCurrentContext()
        
        CGContextClearRect(ctx, rect)
        
        UIColor.whiteColor().setFill()
        CGContextFillRect(ctx, rect)
        
        var row = 0, col = 0
        // center the grid
        var xOffset = (rect.size.width - floor(rect.size.width / contentView.cellSize.width)
            * contentView.cellSize.width) / 2
        
        var x:CGFloat = xOffset, y:CGFloat = 0.0
        
        while row < contentView.rows {
            if col >= contentView.cols {
                y += contentView.cellSize.height
                x = xOffset
                col = 0
                row++
            }
            
            if row >= contentView.rows {
                break
            }
            
            contentView.gridOutlineColor.setStroke()
            CGContextSetLineWidth(ctx, contentView.gridOutlineLineWidth);
            CGContextStrokeRect(ctx, CGRectMake(x, y, contentView.cellSize.width, contentView.cellSize.height));
            
            if let debugTile = contentView.tile(atPosition: GridPosition(row: row, col: col)) {
                
                if debugTile.debugColor == nil {
                    debugTile.debugColor = SwiftGridUtil.randomColor()
                }
                
                debugTile.debugColor?.setFill()
                
            } else {
                UIColor.whiteColor().setFill()
            }
            
            var tileRect = CGRectMake(x, y, contentView.cellSize.width, contentView.cellSize.height)
            CGContextFillRect(ctx, CGRectInset(tileRect, 4.0, 4.0))
            
            x += contentView.cellSize.width;
            col++
        }
    }
}
