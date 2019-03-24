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
    
    public init(boardView: BoardView, bottomBar: BottomBar) {
        self.bottomBar = bottomBar
        self.boardView = boardView
    }
}

extension GameManager: BoardInteractionDelegate {
    public func tileTapped(row: Int, col: Int, isCollision: Bool) {
        switch state {
        case .move:
            print("MOVINGN")
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
                bottomBar.label.text = "Use the below buttons to place track!"
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
    }
    
    public func addPathPressed() {
        state = .addPath
        bottomBar.hideSubBar()
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
    }
}
