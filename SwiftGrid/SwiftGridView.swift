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
    func tileWillDrag(tile: SwiftGridTile)
    func tileDidDrag(tile: SwiftGridTile)
    func tileEndDrag(tile: SwiftGridTile)
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
                for tile in contentView.tiles.sorted({$0.position.row < $1.position.row}) {
                    contentView.ceilTile(tile)
                    contentView.updateTileFrames()
                }
            }
        }
    }
    
    // Disable / enable dragging
    var locked = false {
        didSet {
            contentView.userInteractionEnabled = !locked
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
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /**
    */
    func commonInit()
    {
        contentView = SwiftGridContentView(frame: CGRectMake(0.0, 0.0, self.frame.size.width, 0))
        contentView.gridContainer = self
        contentView.backgroundColor = self.backgroundColor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged",
            name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    /**
    */
    func orientationChanged()
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
    
    :param: cellSize cell dimensions
    */
    func drawGrid(cellSize: CGSize)
    {
        contentView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, 0)
        contentView.gridContainer = self
        contentView.cellSize = cellSize
        
        self.addSubview(contentView)
        contentView.setNeedsDisplay()
        
        self.contentSize = contentView.frame.size
    }
    
    /**
    As convenience, adds a tile at the next open position in the grid.
    
    :param: tile The SwiftGridTile to add to the grid
    */
    func addTile(tile: SwiftGridTile) -> Bool
    {
        return contentView.addTile(tile)
    }
    
    
    func addTile(tile: SwiftGridTile, position: GridPosition) -> Bool
    {
        return contentView.addTile(tile, position: position)
    }
    
    // MARK: SwiftGridViewDelegate
    
    /**
    */
    func tileWillDrag(tile: SwiftGridTile)
    {
        if let dg = gridDelegate {
            dg.tileWillDrag(tile)
        }
    }
    
    /**
    */
    func tileDidDrag(tile: SwiftGridTile)
    {
        if let dg = gridDelegate {
            dg.tileDidDrag(tile)
        }
    }
    
    /**
    */
    func tileEndDrag(tile: SwiftGridTile)
    {
        if let dg = gridDelegate {
            dg.tileEndDrag(tile)
        }
    }
    
    /**
    */
    func contentViewSizeDidChange(contentView:SwiftGridContentView)
    {
        var oldHeight = self.contentSize.height
        var newHeight = contentView.frame.size.height
        
        self.contentSize.height = newHeight
        
        if newHeight != oldHeight && newHeight > self.frame.size.height {
            self.flashScrollIndicators()
        }
    }
}
