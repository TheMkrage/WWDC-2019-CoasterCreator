import UIKit

enum TrackDirection {
    case forward, right, left
}

class Coaster: NSObject {
    private var boardView: BoardView
    
    private var tracks = [TrackTile]()
    var timePerTrack = 0.25
    
    var nextCoasterTileCol = 0
    var nextCoasterTileRow = 0
    var currentCoasterTileCol: Int {
        get {
            return tracks.last!.col
        }
    }
    var currentCoasterTileRow: Int {
        get {
            return tracks.last!.row
        }
    }
    
    var hasAnchorTileBeenSet: Bool {
        get {
            return tracks.count > 0
        }
    }
    
    init(boardView: BoardView, row: Int, col: Int) {
        self.boardView = boardView
        
        let firstTile = TrackTile(type: .horizontal, direction: .forward, row: row, col: col)
        boardView.replaceTile(row: row, col: col, newTile: firstTile)
        tracks.append(firstTile)
        nextCoasterTileRow = row
        nextCoasterTileCol = col + 1
        print("next is \(nextCoasterTileRow) \(nextCoasterTileCol)")
    }
    
    // MARK: Coaster Car
    func addCar() {
        guard let first = tracks.first else {
            return
        }
        print("ADDCAR")
        
        let car = UIImageView(image: UIImage.init(named: "Coaster-Car"))
        car.frame = first.frame
        boardView.addSubview(car)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(5.0)
        
        let pathAndKeyFrames = generateCarPath()
        let totalTime = Double(tracks.count) * timePerTrack
        
        let spinAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        spinAnimation.values = pathAndKeyFrames.2
        spinAnimation.keyTimes = pathAndKeyFrames.1
        spinAnimation.duration = totalTime
        
        car.layer.add(spinAnimation, forKey: "spin")
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = totalTime
        animation.path = pathAndKeyFrames.0.cgPath
        car.layer.add(animation, forKey: "move")
        
        CATransaction.commit()
    }
    
    private func generateCarPath() -> (UIBezierPath, [NSNumber], [Double]) {
        let path = UIBezierPath()
        
        guard let first = tracks.first else {
            return (path, [], [])
        }
        // start the center of the first track piece
        path.move(to: first.leadingCenter)
        
        let totalTime = Double(tracks.count) * timePerTrack
        var angles = [0.0]
        var times = [NSNumber]()
        times.append(0.0)
        
        var currentPoint = first.leadingCenter
        for i in 0..<tracks.count {
            let piece = tracks[i]
            let currentTimeAtStart = Double(i) * timePerTrack
            let currentTimeAtEnd = min(Double(i + 1) * timePerTrack, totalTime)
            
            let endingPoint = getEndingSide(nextPiece: piece, currentPoint: currentPoint)
            
            switch piece.direction {
            // if the piece is just going straight, just move to it
            case .forward:
                path.addLine(to: endingPoint)
                // add angle to timing
                let time = currentTimeAtStart/totalTime
                times.append(NSNumber(value: time))
                angles.append(angles.last!)
            case .right, .left:
                // add start angle to timing
                let timeStart = currentTimeAtStart/totalTime
                times.append(NSNumber(value: timeStart))
                angles.append(angles.last!)
                // animate path
                path.addQuadCurve(to: endingPoint, controlPoint: CGPoint(x: currentPoint.x, y: endingPoint.y))
                // add end angle to timing
                let timeEnd = currentTimeAtEnd/totalTime
                times.append(NSNumber(value: timeEnd))
                if piece.direction == .right {
                    angles.append(angles.last! + Double.pi/2)
                } else {
                    angles.append(angles.last! - Double.pi/2)
                }
            }
            currentPoint = endingPoint
        }
        path.close()
        
        return (path, times, angles)
    }
    
    private func getEndingSide(nextPiece: TrackTile, currentPoint: CGPoint) -> CGPoint {
        // Switch the piece type
        switch nextPiece.type {
        case .bottomToTrailing:
            if currentPoint == nextPiece.bottomCenter {
                return nextPiece.trailingCenter
            } else {
                return nextPiece.bottomCenter
            }
        case .leadingToBottom:
            if currentPoint == nextPiece.leadingCenter {
                return nextPiece.bottomCenter
            } else {
                return nextPiece.leadingCenter
            }
        case .topToLeading:
            if currentPoint == nextPiece.topCenter {
                return nextPiece.leadingCenter
            } else {
                return nextPiece.topCenter
            }
        case .trailingToTop:
            if currentPoint == nextPiece.trailingCenter {
                return nextPiece.topCenter
            } else {
                return nextPiece.trailingCenter
            }
        case .horizontal, .vertical:
            // examine the current point, and return the opposite side
            switch currentPoint {
            case nextPiece.leadingCenter:
                return nextPiece.trailingCenter
            case nextPiece.trailingCenter:
                return nextPiece.leadingCenter
            case nextPiece.topCenter:
                return nextPiece.bottomCenter
            case nextPiece.bottomCenter:
                return nextPiece.topCenter
            default:
                print("bad")
                return CGPoint.zero
            }
        }
    }
    
    // MARK: CoasterBar Editings
    private func saveTrackPiece(trackType: TrackType, direction: TrackDirection, row: Int, col: Int) {
        let track = TrackTile(type: trackType, direction: direction, row: row, col: col)
        boardView.replaceTile(trackTile: track)
        tracks.append(track)
    }

    func undo() {
        if let lastTile = tracks.popLast() {
            nextCoasterTileRow = lastTile.row
            nextCoasterTileCol = lastTile.col
            boardView.eraseTile(row: lastTile.row, col: lastTile.col)
        }
    }

    func addPiece(trackDirection: TrackDirection) {
        if !hasAnchorTileBeenSet {
            fatalError("no anchor!")
        }
        if boardView.doesTileHaveCollision(row: nextCoasterTileRow, col: nextCoasterTileCol) {
            return
        }
        
        switch trackDirection {
        case .forward:
            addForward()
        case .left:
            addLeft()
        case .right:
            addRight()
        }
        
        // Check if the coaster is complete
        guard let first = tracks.first else {
            return
        }
        if first.row == nextCoasterTileRow && first.col == nextCoasterTileCol {
            addCar()
        }
        print("next is \(nextCoasterTileRow) \(nextCoasterTileCol)")
    }
    
    // Adding Pieces
    private func addForward() {
        var nextColTemp = nextCoasterTileCol
        var nextRowTemp = nextCoasterTileRow
        
        // if cols are same, then its vertical change and vertical track piece, vice versa
        if nextCoasterTileCol == currentCoasterTileCol {
            // find which way the track should go
            let direction = nextCoasterTileRow > currentCoasterTileRow ? 1 : -1
            nextRowTemp = nextCoasterTileRow + (1 * direction)
            
            saveTrackPiece(trackType: .vertical, direction: .forward, row: nextCoasterTileRow, col: nextCoasterTileCol)
        } else {
            // find which way the next track should go
            let direction = nextCoasterTileCol > currentCoasterTileCol ? 1 : -1
            nextColTemp = nextCoasterTileCol + (1 * direction)
            
            saveTrackPiece(trackType: .horizontal, direction: .forward, row: nextCoasterTileRow, col: nextCoasterTileCol)
        }
        
        nextCoasterTileCol = nextColTemp
        nextCoasterTileRow = nextRowTemp
    }
    
    private func addRight() {
        var nextColTemp = nextCoasterTileCol
        var nextRowTemp = nextCoasterTileRow
        
        // find which way to turn based on current position
        if nextCoasterTileCol > currentCoasterTileCol {
            saveTrackPiece(trackType: .leadingToBottom, direction: .right, row: nextCoasterTileRow, col: nextCoasterTileCol)
            nextRowTemp += 1
        } else if nextCoasterTileCol < currentCoasterTileCol {
            saveTrackPiece(trackType: .trailingToTop, direction: .right, row: nextCoasterTileRow, col: nextCoasterTileCol)
            nextRowTemp -= 1
        } else if nextCoasterTileRow > currentCoasterTileRow {
            saveTrackPiece(trackType: .topToLeading, direction: .right, row: nextCoasterTileRow, col: nextCoasterTileCol)
            nextColTemp -= 1
        } else if nextCoasterTileRow < currentCoasterTileRow {
            saveTrackPiece(trackType: .bottomToTrailing, direction: .right, row: nextCoasterTileRow, col: nextCoasterTileCol)
            nextColTemp += 1
        }
        
        nextCoasterTileRow = nextRowTemp
        nextCoasterTileCol = nextColTemp
    }
    
    private func addLeft() {
        var nextColTemp = nextCoasterTileCol
        var nextRowTemp = nextCoasterTileRow
        
        // find which way to turn based on current position
        if nextCoasterTileCol > currentCoasterTileCol {
            saveTrackPiece(trackType: .topToLeading, direction: .left, row: nextCoasterTileRow, col: nextCoasterTileCol)
            nextRowTemp -= 1
        } else if nextCoasterTileCol < currentCoasterTileCol {
            saveTrackPiece(trackType: .bottomToTrailing, direction: .left, row: nextCoasterTileRow, col: nextCoasterTileCol)
            nextRowTemp += 1
        } else if nextCoasterTileRow > currentCoasterTileRow {
            saveTrackPiece(trackType: .trailingToTop, direction: .left, row: nextCoasterTileRow, col: nextCoasterTileCol)
            nextColTemp += 1
        } else if nextCoasterTileRow < currentCoasterTileRow {
            saveTrackPiece(trackType: .leadingToBottom, direction: .left, row: nextCoasterTileRow, col: nextCoasterTileCol)
            nextColTemp -= 1
        }
        
        nextCoasterTileRow = nextRowTemp
        nextCoasterTileCol = nextColTemp
    }
}
