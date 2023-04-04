
import UIKit

class ViewController: UIViewController {

    let wkWebViewScene = WKWebViewController.instantiate(fromAppStoryboard: .WKWeb)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.presentView(viewInstance: self.wkWebViewScene)
        }
    }

    func presentView(viewInstance: UIViewController){
        if let topController = UIApplication.topViewController() {
            viewInstance.modalPresentationStyle = .fullScreen
            topController.present(viewInstance, animated: false, completion: nil)
        }
    }
}

