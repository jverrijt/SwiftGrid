//
//  SwiftGridTests.swift
//  SwiftGridTests
//
//  Created by Joost Verrijt on 18/03/15.
//  Copyright (c) 2015 Metamotifs. All rights reserved.
//

import UIKit
import XCTest

class SwiftGridTests: XCTestCase
{
    var gridView: SwiftGridContentView!
    
    override func setUp() {
        super.setUp()
        
        gridView = SwiftGridContentView(frame: CGRectMake(0.0, 0.0, 768.0, 1024.0))
        gridView.cellSize = CGSizeMake(100.0, 100.0);

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testGridContentView()
    {
        // With a width of 768 pixels and a cell size of 100x100, there should be 7 columns.
        XCTAssertEqual(gridView.cols, 7, "rows should be 7, is \(gridView.cols)");
        gridView.cellSize = CGSizeMake(10.0, 10.0);
        XCTAssertEqual(gridView.cols, 76, "rows should be 76, is \(gridView.cols)");
    }
    
    func testGridPositionStruct()
    {
        var pos1 = GridPosition(row: 1, col: 1)
        var pos2 = GridPosition(row: 2, col: 3)
        var pos3 = GridPosition(row: 1, col: 1)
        
        XCTAssertEqual(pos1, pos3, "Pos1 and ps3 are equal")
        XCTAssertFalse(pos1 == pos2, "Pos1 and pos2 are not equal")
        
        var pos = GridPosition(row: 1, col: 2)
        println("value: \(pos.description)")
        
        // NSLog("%@", pos)
    }
    
    /**
    Test the collision detection.
    */
    func testGridAdd()
    {
        gridView.cellSize = CGSizeMake(100.0, 100.0);
        
        var tile = SwiftGridTile(size: TileSize(rows: 2, cols: 2))
        var tile2 = SwiftGridTile(size: TileSize(rows: 3, cols: 2))
        var tile3 = SwiftGridTile(size: TileSize(rows: 4, cols: 4))
        var tile4 = SwiftGridTile(size: TileSize(rows: 4, cols: 4))
        
        XCTAssertTrue(gridView.addTile(tile, position:GridPosition(row:0, col:0)), "Tile was added succesfully")
        XCTAssertFalse(gridView.addTile(tile2, position:GridPosition(row:1, col: 1)), "Tile position illegal!")
        XCTAssertTrue(gridView.addTile(tile3, position:GridPosition(row:6, col: 3)), "Tile was added succesfully")
        XCTAssertFalse(gridView.addTile(tile3, position:GridPosition(row:6, col: 12)), "Tile is out of bounds")
    }
    
    
    func testContentView()
    {
        gridView.cellSize = CGSizeMake(100.0, 100.0);
        
        var imageView = UIImageView(image: UIImage(named: "kitten.jpg"))
        // Create a 2x2 tile and add an image for content. Total tile size will be 200x200 px
        var tile = SwiftGridTile(size: TileSize(rows: 2, cols: 2), contentView:imageView)
        
        // Add the tile to the grid
        gridView.addTile(tile)
        
        // Add the tile at an option grid position
        gridView.removeTile(tile)
        gridView.addTile(tile, position: GridPosition(row: 2, col: 3))
    }
}
