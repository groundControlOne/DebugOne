
import UIKit
import WebKit

class WKWebViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate, WKUIDelegate {
    @IBOutlet weak var progressView: UIProgressView!

    var webView: WKWebView
    var viewIsloaded = false

    
    required init(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRect(x:0,y:20,width:1,height:1))
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(self.webView)
        view.insertSubview(self.webView, belowSubview: progressView)
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        
        self.webView.translatesAutoresizingMaskIntoConstraints=false
        let height = NSLayoutConstraint(item: self.webView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: -50)
        let width = NSLayoutConstraint(item: self.webView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: self.webView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20)
        view.addConstraints([top,height, width])

        self.webView.isOpaque = false
        self.webView.backgroundColor = UIColor .clear
        self.webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        if(self.viewIsloaded == false){
            self.loadWebView()
        }

    }
    
    override func viewDidAppear(_ animated:Bool){
        super.viewDidAppear(animated)
        if !self.viewIsloaded {
            self.viewIsloaded=true
        }
    }
    
    
    
    
    func loadWebView() {
        var request = URLRequest(url: URL(string:"https://groundcontrolone.github.io/DebugOne/")!)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        self.webView.load(request)
    }


    
    @objc
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }

    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if error._code == NSURLErrorNotConnectedToInternet {
            self.dismiss(animated: false, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didAppear navigation: WKNavigation!) {
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(1.0, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.progressView.isHidden = true
            self.progressView.setProgress(0.0, animated: false)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    

}

