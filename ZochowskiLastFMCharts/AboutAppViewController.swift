//
//  AboutAppViewController.swift
//  ZochowskiLastFMCharts
//
//  Created by Jason Zochowski on 4/18/19.
//  Copyright © 2019 Jason Zochowski. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {
    @IBOutlet weak var AboutAppTextView: UITextView!
    
    @IBAction func DoneButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = UIColor.black //customize color of naviagation bar
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.red]
        navigationItem.title = "About App" //view title
        AboutAppTextView.text = "This is my final iOS app in CSCI 321/521, iOS device programmming at NIU. This app features the following:\n- Display a table view cell that contains the artist picture, artist name text label, track name text label, and playcount label that are read in from the charting tracks api on Last.FM\n- When a cell is clicked, it takes you to a detail view that contains more the same information on the previous view, along with the artist description and total playcount that are read in from the artist info api on Last.FM.\n- The detail view also contains 3 buttons. One takes you to the song on Last.FM, the second button takes you to the artist's profile on Last.FM, and the third takes you to another table view with similar artists to the selected artist.\n- The similar artist table view is read in from the similar artists method on Last.FM\n- A infolight button that take you to the About App View.\n- A done button that will take you back to the first view.\n- A button in the About App View that will take you to the About Author View when pressed\n\nDate: 4/24/2019\nVersion 1.0" //about app text
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
