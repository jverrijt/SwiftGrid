SwiftGrid
=========

SwiftGrid is a scrollable, reorderable, variable-size grid component for iOS written in Swift. 

A tile in SwiftGrid consists one or multiple cells. A cell has an arbitrary pixel width and height. It is set before the grid will render and controls the total size of the grid. This will allow for different size tiles for different screen sizes. By default the grid will automatically adjust to device orientation changes.  

![Imgur](http://i.imgur.com/G3t6ab1.gif)


## Example

```swift
gridView.cellSize = CGSizeMake(100.0, 100.0)

var imageView = UIImageView(image: UIImage(named: "kitten.jpg"))
// Create a 2x2 tile and add an image for content. Total tile size will be 200x200 px
var tile = SwiftGridTile(size: TileSize(rows: 2, cols: 2), contentView:imageView)
        
// Add the tile to the grid
gridView.addTile(tile)
        
// Add the tile at an option grid position
gridView.removeTile(tile)
gridView.addTile(tile, position: GridPosition(row: 2, col: 3))
```

See `ViewController.swift` for a more in-depth example.

## Contribute

Improvements to utility and performance of the code is ongoing. Suggestions on how to improve SwiftGrid are very much appreciated. 

This code was originally created by Joost Verrijt and licensed under the MIT license. See LICENSE for details.
