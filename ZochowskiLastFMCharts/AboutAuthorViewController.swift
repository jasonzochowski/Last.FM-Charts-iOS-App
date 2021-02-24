//
//  AboutAuthorViewController.swift
//  ZochowskiLastFMCharts
//
//  Created by Jason Zochowski on 4/18/19.
//  Copyright © 2019 Jason Zochowski. All rights reserved.
//

import UIKit
import WebKit

class AboutAuthorViewController: UIViewController {
    @IBOutlet weak var aboutAuthorWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "About Author" //view title
        
        let path = Bundle.main.path(forResource: "index", ofType: "html")
        
        let data: Data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        
        let html = NSString(data: data, encoding:String.Encoding.utf8.rawValue)
        
        //load the content
        aboutAuthorWebView.loadHTMLString(html! as String, baseURL: Bundle.main.bundleURL)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
