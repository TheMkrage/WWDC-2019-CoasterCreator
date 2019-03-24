import UIKit

enum State {
    case move, addPath, addCoaster, addFlatRide, erase
}

public class GameManager: NSObject {
    var boardView: BoardView
    var bottomBar: BottomBar
    
    // Game State
    var state: State = .move
    
    var coaster: Coaster?
    var completeCoasters = [Coaster]()
    
    public init(boardView: BoardView, bottomBar: BottomBar) {
        self.bottomBar = bottomBar
        self.boardView = boardView
    }
}

extension GameManager: BoardInteractionDelegate {
    public func tileTapped(row: Int, col: Int, isCollision: Bool) {
        switch state {
        case .move:
            print("Move")
        case .addPath:
            if !isCollision {
                boardView.replaceTile(row: row, col: col, newTile: PathTile(frame: .zero))
            }
        case .addCoaster:
            if !(coaster?.hasAnchorTileBeenSet ?? false) && !isCollision {
                // check if valid start
                if col == 0 || col == boardView.cols - 1 {
                    bottomBar.label.text = "Invalid starting location! Try somewhere else"
                    return
                }
                coaster = Coaster(boardView: boardView, row: row, col: col)
                coaster?.completionHandler = { (coaster) -> Void in
                    self.completeCoasters.append(coaster)
                    self.coaster = nil
                    self.bottomBar.mainToolbar.movePressed()
                }
                bottomBar.label.text = "Use the below buttons to place track!"
            }
        case .erase:
            let tile = boardView.tiles[col][row]
            if let track = tile as? TrackTile {
                // if trying to erase a coaster, erase all of its tiles
                // first check the coaster under construction
                if let coaster = self.coaster, coaster.containsTile(tile: track) {
                    coaster.erase()
                    self.coaster = nil
                    return
                }
                var i = 0
                for coaster in self.completeCoasters {
                    if coaster.containsTile(tile: track) {
                        coaster.erase()
                        self.completeCoasters.remove(at: i)
                        return
                    }
                    i += 1
                }
            } else {
                boardView.eraseTile(row: row, col: col)
            }
        default:
            print("everything else")
        }
    }
}

extension GameManager: MainToolerbarDelegate {
    public func movePressed() {
        state = .move
        bottomBar.hideSubBar()
        bottomBar.label.text = "Click and Drag to Pan your View"
    }
    
    public func addPathPressed() {
        state = .addPath
        bottomBar.hideSubBar()
        bottomBar.label.text = "Tap to Place down Path. People will walk here"
    }
    
    public func addCoasterPressed() {
        state = .addCoaster
        bottomBar.hideSubBar()
        bottomBar.showCoasterBar()
        bottomBar.label.text = "Tap anywhere to start the coaster"
    }
    
    public func addFlatRidePressed() {
        state = .addFlatRide
        bottomBar.hideSubBar()
    }
    
    public func erasePressed() {
        state = .erase
        bottomBar.hideSubBar()
        bottomBar.label.text = "Tap to Erase"
    }
}
