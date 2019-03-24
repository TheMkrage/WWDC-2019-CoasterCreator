import UIKit

extension UIView {
    var leadingCenter: CGPoint {
        get {
            return CGPoint(x: frame.minX, y: frame.midY)
        }
    }
    
    var trailingCenter: CGPoint {
        get {
            return CGPoint(x: frame.maxX, y: frame.midY)
        }
    }
    
    var topCenter: CGPoint {
        get {
            return CGPoint(x: frame.midX, y: frame.minY)
        }
    }
    
    var bottomCenter: CGPoint {
        get {
            return CGPoint(x: frame.midX, y: frame.maxY)
        }
    }
}

