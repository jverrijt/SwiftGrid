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
    override func viewDidAppear(_ animated: Bool)
    {
        gridView.contentInset = UIEdgeInsets(top: toolbar!.bounds.height + 5.0, left: 0, bottom: 10.0, right: 0)
        
        // Render larger tiles on iPads
        if UIDevice.current.model.hasPrefix("iPad") {
            gridView.drawGrid(CGSize(width: 75.0, height: 75.0))
        } else {
            gridView.drawGrid(CGSize(width: 50.0, height: 50.0))
        }

        gridView.contentView?.drawDebugGrid = false
        gridView.locked = false
        
        addDemoTiles();
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
        let tile = SwiftGridTile(size: TileSize(rows: 2, cols: 4), contentView: randomImageView())
        let tile2 = SwiftGridTile(size: TileSize(rows: 4, cols: 4), contentView: randomImageView())
        let tile3 = SwiftGridTile(size: TileSize(rows: 2, cols: 2), contentView: randomImageView())
        let tile4 = SwiftGridTile(size: TileSize(rows: 2, cols: 2), contentView: randomImageView())
        let tile5 = SwiftGridTile(size: TileSize(rows: 4, cols: 2), contentView: randomImageView())
        let tile6 = SwiftGridTile(size: TileSize(rows: 2, cols: 4), contentView: randomImageView())
        let tile7 = SwiftGridTile(size: TileSize(rows: 2, cols: 2), contentView: randomImageView())
        let tile8 = SwiftGridTile(size: TileSize(rows: 2, cols: 2), contentView: randomImageView())
        let tile9 = SwiftGridTile(size: TileSize(rows: 2, cols: 2), contentView: randomImageView())
        
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
        
        let tile = SwiftGridTile(size: TileSize(rows: 2, cols: 2), contentView: randomImageView())
        let tile2 = SwiftGridTile(size: TileSize(rows: 3, cols: 2), contentView: randomImageView())
        let tile3 = SwiftGridTile(size: TileSize(rows: 4, cols: 4), contentView: randomImageView())
        
        gridView.addTile(tile, position:GridPosition(row:0, col:0))
        gridView.addTile(tile2, position:GridPosition(row:1, col: 2))
        gridView.addTile(tile3, position:GridPosition(row:6, col: 3))
    }
    
    /**
    Add a bunch of random tiles. Useful for performance tests
    */
    func addRandomTiles(_ nrOfTiles: Int)
    {
        for _ in 1...nrOfTiles {
            var rs = arc4random() % 4

            if rs < 1 {
                rs += 1
            }
            
            let size = TileSize(rows:Int(rs), cols:Int(rs))
            let tile = SwiftGridTile(size: size, contentView: randomImageView())
            
            gridView?.addTile(tile)
        }
    }
    
    /**
    Load a random image of a kitten
    */
    func randomImageView() -> UIImageView
    {
        let r = arc4random() % 8
        let str = Bundle.main.path(forResource: "kitten_\(r)", ofType: "jpg")
        let v = UIImageView(image: UIImage(contentsOfFile: str!))
        v.clipsToBounds = true
        v.contentMode = UIViewContentMode.scaleAspectFill
        
        return v
    }
    
    /**
    */
    @IBAction func addTile()
    {
        let tile = SwiftGridTile(size: TileSize(rows: Int(rowField!.text!)!, cols: Int(colField!.text!)!),
            contentView: randomImageView())
        
        if gridView?.addTile(tile) == false {
            print("Tile out of bounds")
        }
    }
    
    @IBAction func debugToggled(_ toggle: UISwitch)
    {
        gridView.contentView.drawDebugGrid = toggle.isOn
        for tile in gridView.contentView.tiles {
            tile.alpha = toggle.isOn ? 0.6 : 1.0
        }
        
        gridView.contentView.setNeedsDisplay()
    }
    
    @IBAction func freeDragToggled(_ toggle: UISwitch)
    {
        gridView.staticPosition = toggle.isOn
    }
}

