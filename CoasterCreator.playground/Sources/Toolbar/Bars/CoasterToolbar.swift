import UIKit

public protocol CoasterToolerbarDelegate {
    func forwardPressed()
    func rightPressed()
    func leftPressed()
    func undoPressed()
}

public class CoasterToolbar: UIView {
    public var delegate: CoasterToolerbarDelegate?
    
    var forwardButton: UIImageView!
    var rightButton: UIImageView!
    var leftButton: UIImageView!
    var undoButton: UIImageView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not using IB")
    }
    
    func initialize() {
        forwardButton = UIImageView(image: UIImage.init(named: "Forward"))
        forwardButton.frame = CGRect(x: 94, y: 7, width: 12, height: 17)
        forwardButton.isUserInteractionEnabled = true
        forwardButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forwardPressed)))
        
        rightButton = UIImageView(image: UIImage.init(named: "Right"))
        rightButton.frame = CGRect(x: 116, y: 6, width: 17, height: 17)
        rightButton.isUserInteractionEnabled = true
        rightButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightPressed)))
        
        leftButton = UIImageView(image: UIImage.init(named: "Left"))
        leftButton.frame = CGRect(x: 67, y: 6, width: 17, height: 17)
        leftButton.isUserInteractionEnabled = true
        leftButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftPressed)))
        
        undoButton = UIImageView(image: UIImage.init(named: "undo"))
        undoButton.frame = CGRect(x: 180, y: 6, width: 17, height: 17)
        undoButton.isUserInteractionEnabled = true
        undoButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(undoPressed)))
        
        addSubview(forwardButton)
        addSubview(rightButton)
        addSubview(leftButton)
        addSubview(undoButton)
    }
    
    @objc func forwardPressed() {
        clearSelection()
        selectButton(button: forwardButton)
        delegate?.forwardPressed()
    }
    
    @objc func rightPressed() {
        clearSelection()
        selectButton(button: rightButton)
        delegate?.rightPressed()
    }
    
    @objc func leftPressed() {
        clearSelection()
        selectButton(button: leftButton)
        delegate?.leftPressed()
    }
    
    @objc func undoPressed() {
        clearSelection()
        selectButton(button: undoButton)
        delegate?.undoPressed()
    }
    
    func clearSelection() {
        clearSelection(button: forwardButton)
        clearSelection(button: rightButton)
        clearSelection(button: leftButton)
        clearSelection(button: undoButton)
    }
    
    func selectButton(button: UIImageView) {
        let shadowPath = UIBezierPath(rect: button.bounds)
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.yellow.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowPath = shadowPath.cgPath
    }
    
    func clearSelection(button: UIImageView) {
        button.layer.shadowOpacity = 0.0
    }
}
