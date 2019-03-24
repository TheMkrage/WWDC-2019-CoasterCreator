import UIKit

public class PathTile: TileView {
    init(frame: CGRect) {
        super.init(frame: frame, texture: UIImage.init(named: "Path"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not using IB")
    }
}
