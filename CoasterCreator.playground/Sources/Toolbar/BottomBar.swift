import UIKit

public class BottomBar: UIView {
    public var mainToolbar: MainToolbar!
    public var coasterToolbar: CoasterToolbar!
    public var label: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not using IB")
    }
    
    func initialize() {
        backgroundColor = UIColor.gray.withAlphaComponent(0.25)
        layer.cornerRadius = 10.0
        coasterToolbar = CoasterToolbar(frame: CGRect(x: 0, y: 0, width: frame.width, height: 30))
        coasterToolbar.isHidden = true
        mainToolbar = MainToolbar(frame: CGRect(x: 0, y: 100 - 70, width: frame.width, height: 70))
        
        label = UILabel(frame: CGRect(x: 0, y: -30, width: frame.width, height: 30))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Courier", size: 11.0)
        label.text = "Welcome to Coaster Creator!"
        label.textColor = .white
        
        addSubview(label)
        addSubview(mainToolbar)
        addSubview(coasterToolbar)
    }
    
    func showCoasterBar() {
        coasterToolbar.isHidden = false
    }
    
    func hideSubBar() {
        coasterToolbar.isHidden = true
    }
}

