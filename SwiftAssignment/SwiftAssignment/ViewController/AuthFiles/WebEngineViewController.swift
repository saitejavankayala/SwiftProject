//
//  WebEngineViewController.swift
//  SwiftAssignment
//
//  Created by MA-31 on 21/03/23.
//

import UIKit
import WebKit
class WebEngineViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var url: String = "";
    override func viewDidLoad() {
        super.viewDidLoad() // Do any additional setup after loading the view, typically from a nib.
        let url = URL(string: url)!
        webView.load(URLRequest(url: url))
   }
}
