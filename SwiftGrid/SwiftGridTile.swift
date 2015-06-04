//
//  SwiftGridTile.swift
//  SwiftGrid
//
//  Created by Joost Verrijt on 18/03/15.
//  Copyright (c) 2015 Metamotifs. All rights reserved.
//

import UIKit

//
//
//
struct TileSize : Printable
{
    var rows: Int = 0
    var cols: Int = 0
    
    var description: String {
        return "[rows:\(rows) cols:\(cols)]"
    }
}

//
//
//
struct GridPosition : Hashable, Printable
{
    var row: Int
    var col: Int
    
    var hashValue: Int {
        get {
            // Cantor pairing
            return ((row + col) * (row + col + 1)) / 2 + col
        }
    }
    
    var description: String {
        return "[row:\(row) col:\(col)]"
    }
}

func == (el: GridPosition, er: GridPosition) -> Bool {
    return el.hashValue == er.hashValue
}

//
//
//
class SwiftGridTile: UIView, Printable
{
    var needsFrameUpdate: Bool = false
    var oldPosition: GridPosition?
    
    var position:GridPosition = GridPosition(row: 0, col: 0) {
        didSet {
            if (oldValue != position) {
                self.needsFrameUpdate = true
                self.oldPosition = oldValue
            } else {
                self.needsFrameUpdate = false
            }
        }
    }
    
    var size: TileSize = TileSize(rows: 1, cols: 1)

    var debugColor: UIColor?
    
    private var _contentView: UIView?
    var contentView: UIView? {
        get {
            return _contentView
        }
        set {
            if let curContentView = _contentView {
                curContentView.removeFromSuperview()
            }
            _contentView = newValue
            self.addSubview(_contentView!)
        }
    }

    var peak:Int {
        return position.row + size.rows
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
  
    /**
    */
    init(size: TileSize)
    {
        super.init(frame: CGRectMake(0, 0, 0, 0))
        self.size = size
    }
    
    /**
    */
    init(size: TileSize, contentView: UIView) {
        super.init(frame: CGRectMake(0, 0, 0, 0))
        self.size = size
        self.contentView = contentView
        
        self.autoresizesSubviews = true
    }
    
    /**
    */
    init(position: GridPosition, size: TileSize) {
        super.init(frame: CGRectMake(0, 0, 0, 0))
        self.size = size
        self.position = position
    }
    
    /**
    */
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.autoresizesSubviews = true
    }
    
    /**
    Returns true if the given tile intersects with this tile.
    */
    func colidesWithTile(tile: SwiftGridTile) -> Bool
    {
        var r1 = self.asRect(CGSize(width: 10.0, height: 10.0))
        var r2 = tile.asRect(CGSize(width: 10.0, height: 10.0))
        
        if (CGRectIntersectsRect(r1, r2)) {
            return true
        }
        
        return false
    }
    
    /**
    */
    func colidesWithTile(position: GridPosition, size:TileSize) -> Bool
    {
        var r1 = rectForPosition(self.position, size: self.size, cellSize: CGSizeMake(10.0, 10.0))
        var r2 = rectForPosition(position, size: size, cellSize: CGSizeMake(10.0, 10.0))
        
        if (CGRectIntersectsRect(r1, r2)) {
            return true
        }
        
        return false
    }
    
    /**
    Call before tile will display
    */
    func tileAdded(toContentView contentView:SwiftGridContentView)
    {
        updateFrame(inView: contentView)
        
        // Position and size content view
        var cv = self.frame
        cv.origin.x = 0.0
        cv.origin.y = 0.0
        
        _contentView?.frame = cv
        _contentView?.setNeedsDisplay()
    }
    
    /**
    */
    func updateFrame(inView contentView: SwiftGridContentView)
    {
        var tileRect = self.asRect(contentView.cellSize)
        tileRect.origin.x += contentView.originOffset.x
        tileRect.origin.y += contentView.originOffset.y
        
        self.frame = tileRect
        
        needsFrameUpdate = false
    }
    
    /**
    */
    func rectForPosition(position: GridPosition, size: TileSize, cellSize: CGSize) -> CGRect
    {
        return CGRectMake(CGFloat(position.col) * cellSize.width, CGFloat(position.row) * cellSize.height,
            CGFloat(size.cols) * cellSize.width, CGFloat(size.rows) * cellSize.height);
    }
    
    /**
    */
    func asRect(cellSize: CGSize) -> CGRect
    {
        return rectForPosition(position, size: size, cellSize: cellSize)
    }
    
    /**
    */
    override var description: String {
        return "tile (\(hash)) size:\(size.description) position:\(position.description) \n"
    }
}
