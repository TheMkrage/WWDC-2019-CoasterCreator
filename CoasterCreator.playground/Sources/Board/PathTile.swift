import UIKit

public class PathTile: TileView {
    var row: Int
    var col: Int
    init(frame: CGRect, row: Int, col: Int) {
        self.row = row
        self.col = col
        super.init(frame: frame, texture: UIImage.init(named: "Path"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not using IB")
    }
}
