//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MainViewController : UIViewController {
    
    var boardView = BoardView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000), cols: 40, rows: 40)
    var bottomBar = BottomBar(frame: CGRect(x: 150, y: 300, width: 200, height: 100))
    lazy var manager = GameManager(boardView: self.boardView, bottomBar: self.bottomBar)
    
    override func viewDidLoad() {
        
    }
    
    override func loadView() {
        boardView.delegate = manager
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 500, height: 400))
        scrollView.backgroundColor = .black
        scrollView.contentSize = boardView.frame.size
        scrollView.addSubview(boardView)
        scrollView.flashScrollIndicators()
        scrollView.backgroundColor = .white
        
        bottomBar.mainToolbar.delegate = manager
        bottomBar.coasterToolbar.delegate = manager
        
        let view = UIView()
        view.addSubview(scrollView)
        view.backgroundColor = .black
        view.addSubview(bottomBar)
        self.view = view
    }
}

// Present the view controller in the Live View window
let viewController = MainViewController()
viewController.preferredContentSize = CGSize(width: 500, height: 400)
PlaygroundPage.current.liveView = viewController
