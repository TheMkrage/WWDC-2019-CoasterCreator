import UIKit

public protocol BoardInteractionDelegate {
    func tileTapped(row: Int, col: Int, isCollision: Bool)
}

public class BoardView: UIView {
    
    var tiles: [[TileView]]
    var cols: Int!
    var rows: Int!
    
    public var delegate: BoardInteractionDelegate?
    
    var tileWidth: CGFloat!
    var tileHeight: CGFloat!
    
    public init(frame: CGRect, cols: Int, rows: Int) {
        self.tiles = Array(repeating: Array(repeating: TileView(frame: .zero, texture: nil), count: cols), count: rows)
        super.init(frame: frame)
        backgroundColor = .black
        self.cols = cols
        self.rows = rows
        
        tileWidth = frame.width / CGFloat(rows)
        tileHeight = frame.height / CGFloat(cols)
        
        for row in 0..<rows {
            for col in 0..<cols {
                let tileX = tileWidth * CGFloat(col)
                let tileY = tileHeight * CGFloat(row)
                
                let tileFrame = CGRect(x: tileX, y: tileY, width: tileWidth, height: tileHeight)
                let number = Int.random(in: 0 ..< 10)
                let name = number > 7 ? "Grass-01" : "Grass"
                let tile = TileView(frame: tileFrame, texture: UIImage(named: name))
                addSubview(tile)
                tiles[col][row] = tile
            }
        }
        
        // Build starting path
        for x in 0..<10 {
            replaceTile(row: 7, col: x, newTile: PathTile(frame: .zero))
            replaceTile(row: 8, col: x, newTile: PathTile(frame: .zero))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not using IB")
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            
            let tileRow = Int(point.y / tileHeight)
            let tileCol = Int(point.x / tileWidth)
            
            print("tapped: \(tileRow) \(tileCol)")
            self.delegate?.tileTapped(row: tileRow, col: tileCol, isCollision: doesTileHaveCollision(row: tileRow, col: tileCol))
        }
    }
    
    public func doesTileHaveCollision(row: Int, col: Int) -> Bool {
        let tile = tiles[col][row]
        
        return tile.image != UIImage(named: "Grass") && tile.image != UIImage(named: "Grass-01")
    }
    
    func replaceTile(row: Int, col: Int, newTile: TileView) {
        let oldTile = tiles[col][row]
        oldTile.removeFromSuperview()
        
        tiles[col][row] = newTile
        newTile.frame = oldTile.frame
        addSubview(newTile)
    }
    
    func eraseTile(row:Int, col: Int) {
        replaceTile(row: row, col: col, newTile: TileView(frame: .zero, texture: UIImage(named: "Grass")))
    }
    
    func replaceTile(trackTile: TrackTile) {
        replaceTile(row: trackTile.row, col: trackTile.col, newTile: trackTile)
    }
}
