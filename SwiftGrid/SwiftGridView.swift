//
//  SwiftGridView.swift
//  SwiftGrid
//
//  Created by Joost Verrijt on 18/03/15.
//  Copyright (c) 2015 Metamotifs. All rights reserved.
//

import UIKit

protocol SwiftGridViewDelegate: class
{
    func tileWillDrag(_ tile: SwiftGridTile)
    func tileDidDrag(_ tile: SwiftGridTile)
    func tileEndDrag(_ tile: SwiftGridTile)
}

//
//
//
class SwiftGridView: UIScrollView, SwiftGridViewDelegate
{
    var contentView: SwiftGridContentView!
    weak var gridDelegate: SwiftGridViewDelegate?
    
    // Allow positioning of tiles anywhere on the grid.
    var staticPosition = false {
        didSet {
            contentView.staticPosition = staticPosition
            
            if staticPosition == false {
                // ceil all the tiles.
                for tile in contentView.tiles.sorted(by: {$0.position.row < $1.position.row}) {
                    contentView.ceilTile(tile)
                    contentView.updateTileFrames()
                }
            }
        }
    }
    
    // Disable / enable dragging
    var locked = false {
        didSet {
            contentView.isUserInteractionEnabled = !locked
        }
    }
    
    /**
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    /**
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /**
    */
    func commonInit()
    {
        contentView = SwiftGridContentView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: 0))
        contentView.gridContainer = self
        contentView.backgroundColor = self.backgroundColor
    }
    
    /**
    */
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
    */
    override func layoutSubviews()
    {
        if let cv = contentView {
            var frame = cv.frame
            frame.size.width = self.frame.size.width
            
            cv.frame = frame
            
            cv.gridInit()
            cv.repositionOutOfBoundsTiles()
            
            var contentSize = self.contentSize
            contentSize.width = self.frame.width
            
            self.contentSize = contentSize
            
            if cv.drawDebugGrid {
                cv.setNeedsDisplay()
            }
        }
    }
    
    /**
    Set up the grid for a given cell size. 
     
    - parameter cellSize: cell dimensions
    */
    func drawGrid(_ cellSize: CGSize)
    {
        contentView.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: 0)
        contentView.gridContainer = self
        contentView.cellSize = cellSize
        
        self.addSubview(contentView)
        contentView.setNeedsDisplay()
        
        self.contentSize = contentView.frame.size
    }
    
    /**
    As convenience, adds a tile at the next open position in the grid.
    
    - parameter tile: The SwiftGridTile to add to the grid
    */
    @discardableResult
    func addTile(_ tile: SwiftGridTile) -> Bool
    {
        return contentView.addTile(tile)
    }
    
    /**
    */
    @discardableResult
    func addTile(_ tile: SwiftGridTile, position: GridPosition) -> Bool
    {
        return contentView.addTile(tile, position: position)
    }
    
    // MARK: SwiftGridViewDelegate
    
    /**
    */
    func tileWillDrag(_ tile: SwiftGridTile)
    {
        if let dg = gridDelegate {
            dg.tileWillDrag(tile)
        }
    }
    
    /**
    */
    func tileDidDrag(_ tile: SwiftGridTile)
    {
        if let dg = gridDelegate {
            dg.tileDidDrag(tile)
        }
    }
    
    /**
    */
    func tileEndDrag(_ tile: SwiftGridTile)
    {
        if let dg = gridDelegate {
            dg.tileEndDrag(tile)
        }
    }
    
    /**
    */
    func contentViewSizeDidChange(_ contentView:SwiftGridContentView)
    {
        let oldHeight = self.contentSize.height
        let newHeight = contentView.frame.size.height
        
        self.contentSize.height = newHeight
        
        if newHeight != oldHeight && newHeight > self.frame.size.height {
            self.flashScrollIndicators()
        }
    }
}
