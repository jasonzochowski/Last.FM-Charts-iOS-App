//
//  ArtistProfileWebViewController.swift
//  ZochowskiLastFMCharts
//
//  Created by Jason Zochowski on 4/18/19.
//  Copyright © 2019 Jason Zochowski. All rights reserved.
//

import UIKit
import WebKit

class ArtistProfileWebViewController: UIViewController {

    @IBOutlet weak var ArtistProfileWebView: WKWebView!
    
    var ArtistUrl:String!
    var ArtistName:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = ArtistName + " Artist Profile"
        //create a variable to hold the URL string
        let myURL = URL(string: ArtistUrl)
        //create a URL request
        let urlRequest = URLRequest(url: myURL!)
        //place the web content on webView
        ArtistProfileWebView.load(urlRequest)
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
