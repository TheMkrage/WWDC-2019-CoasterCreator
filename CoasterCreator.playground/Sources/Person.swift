import UIKit

public class Person: NSObject {
    private var boardView: BoardView
    
    var pathTiles = [PathTile]()
    var timePerTile = 1.0
    
    lazy var imageView = UIImageView(image: UIImage.init(named: Person.randomName()))
    
    private static func randomName() -> String {
        let number = Int.random(in: 1...4)
        if number == 1 {
            return "Person-01"
        } else if number == 2 {
            return "Person-02"
        } else if number == 3 {
            return "Person-03"
        } else {
            return "Person-04"
        }
    }
    
    init(boardView: BoardView, row: Int, col: Int) {
        self.boardView = boardView
        super.init()
        
        guard let tile = boardView.tiles[col][row] as? PathTile else {
            return
        }
        imageView.frame = tile.frame
        boardView.addSubview(imageView)
        
        pathTiles.append(tile)
        
        animate()
    }
    
    func animate() {
        self.generateTilePath()
        
        let totalTime = Double(pathTiles.count) * timePerTile
        let pathAndKeyFrames = generatePath()
        
        CATransaction.begin()
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = totalTime
        animation.path = pathAndKeyFrames.0.cgPath
        CATransaction.setCompletionBlock {
            self.animate()
        }
        imageView.layer.add(animation, forKey: "move")
        CATransaction.commit()
    }
    
    private func generateTilePath() {
        let lastTile = pathTiles.last!
        pathTiles = [lastTile]
        
        let numberOfTiles = Int.random(in: 5...10)
        for _ in 0..<numberOfTiles {
            let currentTile = pathTiles.last!
            var nextTile: PathTile? = nil
            // loop until adjacent path tile is found
            while nextTile == nil {
                let direction = Int.random(in: 1...4)
                if direction == 1 {
                    if let potentialTile = boardView.getTile(row: currentTile.row + 1, col: currentTile.col) as? PathTile {
                        nextTile = potentialTile
                    }
                } else if direction == 2 {
                    if let potentialTile = boardView.getTile(row: currentTile.row - 1, col: currentTile.col) as? PathTile {
                        nextTile = potentialTile
                    }
                } else if direction == 3 {
                    if let potentialTile = boardView.getTile(row: currentTile.row, col: currentTile.col + 1) as? PathTile {
                        nextTile = potentialTile
                    }
                } else {
                    if let potentialTile = boardView.getTile(row: currentTile.row, col: currentTile.col - 1) as? PathTile {
                        nextTile = potentialTile
                    }
                }
            }
            pathTiles.append(nextTile!)
        }
    }
    
    private func generatePath() -> (UIBezierPath, [NSNumber], [Double]) {
        let path = UIBezierPath()
        
        guard let first = pathTiles.first else {
            return (path, [], [])
        }
        // start the center of the first track piece
        path.move(to: first.center)
        
        //let totalTime = Double(pathTiles.count) * timePerTile
        var angles = [0.0]
        var times = [NSNumber]()
        times.append(0.0)
        
        var currentPoint = first.center
        for i in 0..<pathTiles.count {
            let tile = pathTiles[i]
            //let currentTimeAtStart = Double(i) * timePerTile
            //let currentTimeAtEnd = min(Double(i + 1) * timePerTile, totalTime)
            
            let endingPoint = tile.center
            currentPoint = endingPoint
            path.addLine(to: currentPoint)
        }
        
        return (path, times, angles)
    }
}
