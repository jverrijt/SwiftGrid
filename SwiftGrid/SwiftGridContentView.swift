//
//  SwiftGridView.swift
//  SwiftGrid
//
//  Created by Joost Verrijt on 18/03/15.
//  Copyright (c) 2015 Metamotifs. All rights reserved.
//

import UIKit

//
//
//
class SwiftGridContentView: UIView
{
    var cellSize: CGSize = CGSize(width: 100.0, height: 100.0) {
        didSet {
            gridInit()
        }
    }
    
    var rows: Int = 0, cols: Int = 0
    var tiles = [SwiftGridTile]()
    
    var gridContainer: SwiftGridView?
    
    // Enables tiles to be positioned anywhere
    var staticPosition = false
    
    var drawDebugGrid = false // Draws the grid including cells when enabled
    var gridOutlineColor: UIColor = UIColor.gray
    var gridOutlineLineWidth: CGFloat = 2.0
    
    var originOffset: CGPoint = CGPoint.zero
    fileprivate var dragTile: SwiftGridTile!
    fileprivate var cellOffset: CGSize!
    fileprivate var dragPoint: CGPoint!
    
    /**
    */
    override func draw(_ rect: CGRect)
    {
        if drawDebugGrid {
            SwiftGridUtil.drawDebugGrid(rect, contentView: self)
        }
    }
    
    /**
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        gridInit()
    }
   
    /**
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        gridInit()
    }
    
    /**
    Calculate rows and columns based on cell size.
    */
    func gridInit()
    {
        // Center the grid
        let xOffset = (self.frame.size.width - floor(self.frame.size.width / cellSize.width) * cellSize.width) / 2
        originOffset.x = xOffset
        
        rows = Int(floor(self.frame.size.height / cellSize.height))
        cols = Int(floor(self.frame.size.width / cellSize.width))
    }
    
    /**
    Adds a tile at an optional grid position. A valid tile position will be calculated if no position is given
    
    - parameter tile: The SwiftGridTile to add to the grid
    - parameter position: The position of where to add the tile (optional)
    
    - returns: true if the tile was succesfully added
    */
    @discardableResult
    func addTile(_ tile: SwiftGridTile, position: GridPosition? = nil) -> Bool
    {
        if let position = position {
            if tilePositionValid(position, size: tile.size) {
                tile.position = position
            } else {
                return false
            }
        } else {
            if tile.size.cols <= cols {
                tile.position = openGridPostion(tile)
            } else {
                return false
            }
        }
        
        tiles.append(tile)
        self.addSubview(tile)
        calculateContentSize()
        
        if drawDebugGrid {
            tile.isHidden = true
            self.setNeedsDisplay()
        } else {
            tile.tileAdded(toContentView: self)
        }
        
        return true
    }
    
    /**
    - parameter position: The position of where to add the tile (optional)
    :param" size The size of the tile.
    
    - returns: true if the given position and size are valid
    */
    func tilePositionValid(_ position: GridPosition, size: TileSize) -> Bool
    {
        if self.tile(atPosition: position) == nil
            && collisions(atPosition: position, size: size).count == 0
            && position.col >= 0
            && position.row >= 0
            && !(position.col > cols || position.col + size.cols > cols) {
                return true
        }
        
        return false
    }
    
    /**
    Removes given tile from grid
    */
    func removeTile(_ tile: SwiftGridTile)
    {
        tile.removeFromSuperview()
        
        if let l = tiles.index(of: tile) {
            tiles.remove(at: l)
        }
    }
    
    /**
    Find and return the next space the given tile will fit in.
    */
    func openGridPostion(_ tile: SwiftGridTile) -> GridPosition
    {
        let position = GridPosition(row: 0, col: 0)
        
        for row in 0 ..< Int.max {
            for col in 0 ..< cols {
                // width exceeded
                if col + tile.size.cols > cols {
                    break
                }
                
                let curPosition = GridPosition(row: row, col: col)
                if collisions(atPosition: curPosition, size: tile.size).count > 0 {
                    continue
                }
               
                return curPosition
            }
        }
        return position
    }
    
    /**
    Repositions all tiles that are out of bounds
    */
    func repositionOutOfBoundsTiles()
    {
        for t in tiles.sorted(by: {$0.position.row < $1.position.row}) {
            if t.position.col + t.size.cols > cols {
                t.position = openGridPostion(t)
            }
            
            ceilTile(t)
            t.needsFrameUpdate = true
        }
        
        // All tiles will need an update after this.
        updateTileFrames()
        calculateContentSize()
    }
    
    /**
    Get the tile located at given position
    */
    func tile(atPosition position: GridPosition) -> SwiftGridTile?
    {
        for tile in tiles {
            if (position.row >= tile.position.row && position.row < tile.position.row + tile.size.rows) &&
                (position.col >= tile.position.col && position.col < tile.position.col + tile.size.cols) {
                return tile
            }
        }
        return nil
    }
    
    /**
    Returns the tiles that are colliding with the given tile at this position
    */
    func collisions(atPosition position: GridPosition, size: TileSize, excludeTile: SwiftGridTile? = nil) -> NSArray
    {
        let colidingTiles = NSMutableArray()  // Note: returning an NSMutableArray due to Swift performance concerns
        
        for tile in tiles {
            if tile.colidesWithTile(position, size: size) && tile != excludeTile {
                colidingTiles.add(tile)
            }
        }
        return colidingTiles
    }
    
    /**
    Moves other tiles out of the way of the drag tile.
    */
    func repositionCollisions(_ collidingTiles: NSArray, dragTile:SwiftGridTile)
    {
        for t in collidingTiles {
            
            let tile = t as! SwiftGridTile
            
            if tile == dragTile {
                continue
            }
            
            var newPosition = tile.position
            newPosition.row = dragTile.position.row + dragTile.size.rows
            tile.position = newPosition
            
            let c = collisions(atPosition: tile.position, size: tile.size)

            if c.count > 0 {
                repositionCollisions(c, dragTile: tile)
            }
        }
    }
    
    /**
    Move up tile until it collides with the ceiling or another tile.
    */
    func ceilTile(_ tile: SwiftGridTile)
    {
        if tile.position.row > 0 {
            var curPos = tile.position
            curPos.row -= 1
            let c = collisions(atPosition: curPos, size: tile.size, excludeTile:tile)
            if c.count == 0 {
                tile.position = curPos
                ceilTile(tile)
            }
        }
    }
    
    /**
    finds the highest row occupied by a tile
    */
    func highestTileRow() -> Int
    {
        if tiles.count == 0 {
            return 0
        }
        
        var sorted = tiles.sorted(by: {$0.peak > $1.peak})
        let maxRow = sorted[0].position.row
        var ret = 0
        
        for tile in sorted {
            if tile.position.row != maxRow {
                break
            }
            
            if tile.position.row + tile.size.rows > ret {
                ret = tile.position.row + tile.size.rows
            }
        }
        
        return ret
    }
    
    /**
    */
    func calculateContentSize()
    {
        rows = highestTileRow()
        
        var viewSize = self.frame
        viewSize.size.height = CGFloat(rows) * cellSize.height
        self.frame = viewSize
        
        gridContainer?.contentViewSizeDidChange(self)
    }
    
    /**
    Update and animate the tile frames that need it.
    */
    func updateTileFrames()
    {
        let animate = tiles.filter({$0.needsFrameUpdate == true})
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut,
            animations: { () -> Void in
                for tile in animate {
                    tile.updateFrame(inView: self)
                }
            }, completion:nil)
    }

    // MARK: Touch handling
    
    /**
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        dragTile = nil
        cellOffset = CGSize.zero
        
        let touch = touches.first as UITouch!
        var point = touch!.location(in: self)
        
        point.x -= originOffset.x
        point.y -= originOffset.y
        
        dragPoint = point
        
        let col = Int(ceil(point.x / cellSize.width)) - 1
        let row = Int(ceil(point.y / cellSize.height)) - 1
        
        let tile = self.tile(atPosition: GridPosition(row: row, col: col))
        
        if let tile = tile {
            dragTile = tile
            
            bringSubview(toFront: dragTile)
            
            // calculate the cell where the touch originated
            let cr = CGFloat(row - dragTile.position.row)
            let cc = CGFloat(col - dragTile.position.col)
            
            cellOffset = CGSize(width: cc * cellSize.width, height: cr * cellSize.height)
            gridContainer?.isScrollEnabled = false
            
            gridContainer?.tileWillDrag(tile)
        }
    }
    
    /**
    */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if dragTile == nil {
            return
        }
        
        let touch = touches.first as UITouch!
        var point = touch!.location(in: self)
        
        point.x -= originOffset.x
        point.y -= originOffset.y
        
        var dragRect = dragTile.frame
        dragRect.origin.x += point.x - dragPoint.x
        dragRect.origin.y += point.y - dragPoint.y
        dragTile.frame = dragRect
        
        dragPoint = point
        
        let newCol = Int(ceil((point.x - cellOffset.width) / cellSize.width)) - 1
        let newRow = Int(ceil((point.y - cellOffset.height) / cellSize.height)) - 1
        
        // check if being dragged out of bounds
        if (newRow < 0 || newRow > rows) || (newCol < 0 || newCol + dragTile.size.cols > cols) {
            return
        }
        
        let newPosition = GridPosition(row: newRow, col: newCol)
        dragTile.position = newPosition
    
        // Colliding tiles at the new position
        let collidingTiles = collisions(atPosition: dragTile.position, size: dragTile.size, excludeTile: dragTile)
        repositionCollisions(collidingTiles, dragTile: dragTile)
        
        gridContainer?.tileDidDrag(dragTile)
        
        // Stick tiles to the ceiling.
        if staticPosition == false {
            for t in tiles.sorted(by: {$0.position.row < $1.position.row}) {
                ceilTile(t)
            }
        }

        // Update the frames of the tiles that need it. Don't update the frame for the tile that's being dragged
        // just yet to avoid animation artifacts. Its frame will be updated when the user lets go of the tile.
        dragTile.needsFrameUpdate = false
        updateTileFrames()
        
        // Recalculate contentsize
        calculateContentSize()
        
        if drawDebugGrid {
            self.setNeedsDisplay()
        }
    }
    
    /**
    */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if dragTile == nil {
            return
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut,
            animations: { () -> Void in
                self.dragTile.updateFrame(inView: self)
            }, completion: nil)
        
        gridContainer?.tileEndDrag(dragTile)
        gridContainer?.isScrollEnabled = true
    }
}
