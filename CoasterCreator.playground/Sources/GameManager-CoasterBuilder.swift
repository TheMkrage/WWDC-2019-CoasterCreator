import UIKit

extension GameManager: CoasterToolerbarDelegate {
    public func forwardPressed() {
        if !(coaster?.hasAnchorTileBeenSet ?? false) {
            bottomBar.label.text = "Hey! Tap somewhere to start the coaster!"
        }
        coaster?.addPiece(trackDirection: .forward)
    }
    
    public func rightPressed() {
        if !(coaster?.hasAnchorTileBeenSet ?? false) {
            bottomBar.label.text = "Hey! Tap somewhere to start the coaster!"
        }
        coaster?.addPiece(trackDirection: .right)
    }
    
    public func leftPressed() {
        if !(coaster?.hasAnchorTileBeenSet ?? false) {
            bottomBar.label.text = "Hey! Tap somewhere to start the coaster!"
        }
        coaster?.addPiece(trackDirection: .left)
    }
    
    public func undoPressed() {
        if !(coaster?.hasAnchorTileBeenSet ?? false) {
            bottomBar.label.text = "Hey! Tap somewhere to start the coaster!"
        }
        coaster?.undo()
    }
}
