//
//  PlaySongWebViewController.swift
//  ZochowskiLastFMCharts
//
//  Created by Jason Zochowski on 4/18/19.
//  Copyright © 2019 Jason Zochowski. All rights reserved.
//

import UIKit
import WebKit

class PlaySongWebViewController: UIViewController {

    @IBOutlet weak var PlaySongWebView: WKWebView!
    
    var TrackUrl:String!
    var TrackName:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = TrackName
        //create a variable to hold the URL string
        let myURL = URL(string: TrackUrl)
        //create a URL request
        let urlRequest = URLRequest(url: myURL!)
        //place the web content on webView
        PlaySongWebView.load(urlRequest)
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
