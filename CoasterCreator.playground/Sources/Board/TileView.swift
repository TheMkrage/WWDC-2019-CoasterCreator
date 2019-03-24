import UIKit

public class TileView: UIImageView {
    init(frame: CGRect, texture: UIImage?) {
        super.init(frame: frame)
        contentMode = .scaleAspectFill
        image = texture
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not using IB")
    }
}
