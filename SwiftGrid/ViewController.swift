//
//  ViewController.swift
//  SwiftGrid
//
//  Created by Joost Verrijt on 18/03/15.
//  Copyright (c) 2015 Metamotifs. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var gridView:SwiftGridView!
    
    @IBOutlet weak var rowField:UITextField!
    @IBOutlet weak var colField:UITextField!
    
    @IBOutlet weak var toolbar:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
    */
    override func viewDidAppear(animated: Bool)
    {
        gridView.contentInset = UIEdgeInsets(top: toolbar!.bounds.height + 5.0, left: 0, bottom: 10.0, right: 0)
        
        // Render larger tiles on iPads
        if UIDevice.currentDevice().model.hasPrefix("iPad") {
            gridView.drawGrid(CGSizeMake(75.0, 75.0))
        } else {
            gridView.drawGrid(CGSizeMake(50.0, 50.0))
        }

        gridView.contentView?.drawDebugGrid = false
        gridView.locked = false
        
        addDemoTiles()
        // addRandomTiles(100)
        // addStaticTiles()
    }

    /**
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
    Add Demo tiles
    */
    func addDemoTiles()
    {
        var tile = SwiftGridTile(size: TileSize(rows: 2, cols: 4), contentView: randomImageView())
        var tile2 = SwiftGridTile(size: TileSize(rows: 4, cols: 4), contentView: randomImageView())
        var tile3 = SwiftGridTile(size: TileSize(rows: 2, cols: 2), contentView: randomImageView())
        var tile4 = SwiftGridTile(size: TileSize(rows: 2, cols: 2), contentView: randomImageView())
        var tile5 = SwiftGridTile(size: TileSize(rows: 4, cols: 2), contentView: randomImageView())
        var tile6 = SwiftGridTile(size: TileSize(rows: 2, cols: 4), contentView: randomImageView())
        var tile7 = SwiftGridTile(size: TileSize(rows: 2, cols: 2), contentView: randomImageView())
        var tile8 = SwiftGridTile(size: TileSize(rows: 2, cols: 2), contentView: randomImageView())
        var tile9 = SwiftGridTile(size: TileSize(rows: 2, cols: 2), contentView: randomImageView())
        
        gridView?.addTile(tile)
        gridView?.addTile(tile2)
        gridView?.addTile(tile3)
        gridView?.addTile(tile4)
        gridView?.addTile(tile5)
        gridView?.addTile(tile6)
        gridView?.addTile(tile7)
        gridView?.addTile(tile8)
        gridView?.addTile(tile9)
    }
    
    /**
    Add tiles to the grid with a static position
    */
    func addStaticTiles()
    {
        gridView.staticPosition = true
        
        var tile = SwiftGridTile(size: TileSize(rows: 2, cols: 2), contentView: randomImageView())
        var tile2 = SwiftGridTile(size: TileSize(rows: 3, cols: 2), contentView: randomImageView())
        var tile3 = SwiftGridTile(size: TileSize(rows: 4, cols: 4), contentView: randomImageView())
        
        gridView.addTile(tile, position:GridPosition(row:0, col:0))
        gridView.addTile(tile2, position:GridPosition(row:1, col: 2))
        gridView.addTile(tile3, position:GridPosition(row:6, col: 3))
    }
    
    /**
    Add a bunch of random tiles. Useful for performance tests
    */
    func addRandomTiles(nrOfTiles: Int)
    {
        for i in 1...nrOfTiles {
            var rs = arc4random() % 4

            if rs < 1 {
                rs += 1
            }
            
            var size = TileSize(rows:Int(rs), cols:Int(rs))
            var tile = SwiftGridTile(size: size, contentView: randomImageView())
            
            gridView?.addTile(tile)
        }
    }
    
    /**
    Load a random image of a kitten
    */
    func randomImageView() -> UIImageView
    {
        var r = arc4random() % 8
        var str = NSBundle.mainBundle().pathForResource("kitten_\(r)", ofType: "jpg")
        var v = UIImageView(image: UIImage(contentsOfFile: str!))
        v.clipsToBounds = true
        v.contentMode = UIViewContentMode.ScaleAspectFill
        
        return v
    }
    
    /**
    */
    @IBAction func addTile()
    {
        var tile = SwiftGridTile(size: TileSize(rows: rowField!.text.toInt()!, cols: colField!.text.toInt()!),
            contentView: randomImageView())
        
        if gridView?.addTile(tile) == false {
            println("Tile out of bounds")
        }
    }
    
    @IBAction func debugToggled(toggle: UISwitch)
    {
        gridView.contentView.drawDebugGrid = toggle.on
        for tile in gridView.contentView.tiles {
            tile.alpha = toggle.on ? 0.6 : 1.0
        }
        
        gridView.contentView.setNeedsDisplay()
    }
    
    @IBAction func freeDragToggled(toggle: UISwitch)
    {
        gridView.staticPosition = toggle.on
    }
}

