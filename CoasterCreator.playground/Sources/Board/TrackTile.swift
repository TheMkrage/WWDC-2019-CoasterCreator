import UIKit

enum TrackType {
    case vertical, horizontal, bottomToTrailing, trailingToTop, topToLeading, leadingToBottom
}
public class TrackTile: TileView {
    
    var row: Int
    var col: Int
    
    var direction: TrackDirection
    var type: TrackType
    
    init(type: TrackType, direction: TrackDirection, row: Int, col: Int) {
        self.row = row
        self.col = col
        self.type = type
        self.direction = direction
        
        switch type {
        case .vertical:
            super.init(frame: .zero, texture: UIImage.init(named: "Coaster-Vertical"))
        case .horizontal:
            super.init(frame: .zero, texture: UIImage.init(named: "Coaster-Horizontal"))
        case .bottomToTrailing:
            super.init(frame: .zero, texture: UIImage(named: "Coaster-Turn-Bottom-Trailing"))
        case .trailingToTop:
            super.init(frame: .zero, texture: UIImage(named: "Coaster-Turn-Trailing-Top"))
        case .leadingToBottom:
            super.init(frame: .zero, texture: UIImage(named: "Coaster-Turn-Leading-Bottom"))
        case .topToLeading:
            super.init(frame: .zero, texture: UIImage(named: "Coaster-Turn-Top-Leading"))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not using IB")
    }
}
