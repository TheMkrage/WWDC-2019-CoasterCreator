import UIKit

public protocol MainToolerbarDelegate {
    func movePressed()
    func addPathPressed()
    func addCoasterPressed()
    func addFlatRidePressed()
    func erasePressed()
}

public class MainToolbar: UIView {
    
    public var delegate: MainToolerbarDelegate?
    
    var moveButton: UIImageView!
    var addPathButton: UIImageView!
    var addCoasterButton: UIImageView!
    var eraseButton: UIImageView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not using IB")
    }
    
    func initialize() {
        backgroundColor = UIColor.gray.withAlphaComponent(0.25)
        moveButton = UIImageView(image: UIImage.init(named: "Move"))
        moveButton.isUserInteractionEnabled = true
        moveButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(movePressed)))
        
        addPathButton = UIImageView(image: UIImage.init(named: "AddPath"))
        addPathButton.frame = CGRect(x: 40, y: 0, width: 40, height: 70)
        addPathButton.isUserInteractionEnabled = true
        addPathButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPathPressed)))
        
        addCoasterButton = UIImageView(image: UIImage.init(named: "AddCoaster"))
        addCoasterButton.contentMode = .center
        addCoasterButton.frame = CGRect(x: 80, y: 0, width: 40, height: 70)
        addCoasterButton.isUserInteractionEnabled = true
        addCoasterButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addCoasterPressed)))
        
        eraseButton = UIImageView(image: UIImage.init(named: "Erase"))
        eraseButton.contentMode = .center
        eraseButton.frame = CGRect(x: 120, y: 0, width: 40, height: 70)
        eraseButton.isUserInteractionEnabled = true
        eraseButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(erasePressed)))
        
        addSubview(moveButton)
        addSubview(addPathButton)
        addSubview(addCoasterButton)
        addSubview(eraseButton)
    }
    
    @objc func movePressed() {
        clearSelection()
        selectButton(button: moveButton)
        delegate?.movePressed()
    }
    
    @objc func addPathPressed() {
        clearSelection()
        selectButton(button: addPathButton)
        delegate?.addPathPressed()
    }
    
    @objc func addCoasterPressed() {
        clearSelection()
        selectButton(button: addCoasterButton)
        delegate?.addCoasterPressed()
    }
    
    @objc func erasePressed() {
        clearSelection()
        selectButton(button: eraseButton)
        delegate?.erasePressed()
    }
    
    func clearSelection() {
        clearSelection(button: moveButton)
        clearSelection(button: addPathButton)
        clearSelection(button: addCoasterButton)
        clearSelection(button: eraseButton)
    }
    
    func selectButton(button: UIImageView) {
        print(button.frame)
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
