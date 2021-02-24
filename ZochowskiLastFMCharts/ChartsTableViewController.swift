//
//  ChartsTableViewController.swift
//  ZochowskiLastFMCharts
//
//  Created by Jason Zochowski on 4/12/19.
//  Copyright © 2019 Jason Zochowski. All rights reserved.
//

import UIKit

//structs to load JSON data of the charting songs api on Last.FM
struct Root: Decodable { //root struct
    private enum CodingKeys: String, CodingKey {
        case tracks = "tracks"
    }
    let tracks: Tracks?
}
struct Tracks: Decodable { //tracks:
    private enum CodingKeys: String, CodingKey {
        case track = "track"
    }
    let track: [Track]?
}
struct Track: Decodable { //track: []
    let name:String?
    let playcount:String?
    let url:String?
    let artist: Artist?
    let image: [ImageFile]?
    
    init(name: String, playCount : String, url : String, artist : Artist, image: [ImageFile]) {
        self.name = name
        self.playcount = playCount
        self.url = url
        self.artist = artist
        self.image = image
    }
}
struct Artist: Decodable { //artist:
    let name:String?
    let url:String?
}

struct ImageFile { //image: []
    
    let text : String?
    let size : String?
    
    init(text: String, size: String) {
        self.text = text
        self.size = size
    }
}

extension ImageFile : Decodable {
    enum CodingKeys:  String, CodingKey{
        case text = "#text"
        case size = "size"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let text : String = try container.decode(String.self, forKey: .text)
        let size : String = try container.decode(String.self, forKey: .size)
        
        self.init(text: text, size: size)
    }
}

class ChartsTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var chartSearchBar: UISearchBar!
    
    var rootObject = [Root]() //root object array
    var chartObject = [Track]() //track object array
    var searchResults = [Track]() //same as chartObject, but with only searched elements
    var searchIsActive = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationController?.navigationBar.barTintColor = UIColor.black //edit navigation bar color and text
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.red]
        self.navigationItem.title = "Last.FM Top Tracks"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 175
        self.chartSearchBar.delegate = self
        loadJSON()
        addRightNavigationBarInfoButton()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func loadJSON()
    {
        //Create an optional variable to hold the URL
        let jsonURL = "http://ws.audioscrobbler.com/2.0/?method=chart.gettoptracks&api_key=8cc56eb58445b9408634b6626ea1b151&format=json"
        //Create a string of typed URL
        let api_url = URL(string: jsonURL)
        //Create a URLSession to get the json data
        let task = URLSession.shared.dataTask(with: api_url!) {(data, response, err) in
            //if the data is not empty store it in jsonData
            if (data != nil) {
                guard let jsonData = data else {return}
                //parse through json data using JSONDecoder
                do {
                    let decoder = JSONDecoder()
                    let root = try decoder.decode(Root.self, from: jsonData)
                    for trck in (root.tracks?.track)!
                    {
                        let trackname = trck.name
                        let trackurl = trck.url
                        let playcount = trck.playcount
                        let artistname = trck.artist
                        let imagename = trck.image
                        
                        self.chartObject.append(Track(name: trackname!, playCount: playcount!, url: trackurl!, artist: artistname!, image: imagename!)) //append to chartObject
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch let jsonErr {
                    print("Error Reading JSON: ",jsonErr)
                }
            }
        }
        task.resume()
    }
    //function that adds an info light button
    func addRightNavigationBarInfoButton()
    {
        // Create an Info Light button
        let button = UIButton(type: .infoLight)
        button.addTarget(self, action: #selector(self.showAboutAppView), for: .touchUpInside)
        
        // Place the button at the top right corner of the navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    //function that sets the destination of the info light button to about app view controller
    @objc func showAboutAppView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AboutAppViewController") as! UINavigationController
        self.present(controller, animated: false, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        self.searchResults = self.chartObject.filter ({($0.name?.lowercased().contains(searchText.lowercased()))! || ($0.artist?.name?.lowercased().contains(searchText.lowercased()))!}) //filter the searchResults to only the searched text and append those elements from chartObject into searchResults
        searchIsActive = true
        tableView.reloadData()
    }
    //cancel button
    func searchBarCancelButtonClicked(_ chartSearchBar: UISearchBar)
    {
        searchIsActive = false
        chartSearchBar.text = nil
        tableView.reloadData()
        chartSearchBar.resignFirstResponder()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchIsActive
        {
            return searchResults.count //searched elements only
        }
        else
        {
            return chartObject.count //all elements
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! ChartTableViewCell
        if searchIsActive //if you are searching for track
        {
            let charts: Track = self.searchResults[indexPath.row]
            let chartImageURL = URL(string: (charts.image?[3].text!)!)
            DispatchQueue.global().async { //download and display image in ChartImageView
                let data = try? Data(contentsOf: chartImageURL!)
                DispatchQueue.main.async {
                    cell.ChartImageView.image = UIImage(data: data!)
                }
            }
       
            cell.TrackNameLabel.text = charts.name!
            cell.ArtistNameLabel.text = charts.artist?.name!
            cell.PlayCountLabel.text = "Track Streams: " + charts.playcount!
        }
        else
        {
            let charts: Track = self.chartObject[indexPath.row]
            let chartImageURL = URL(string: (charts.image?[3].text!)!)
            DispatchQueue.global().async { //download and display image in ChartImageView
                let data = try? Data(contentsOf: chartImageURL!)
                DispatchQueue.main.async {
                    cell.ChartImageView.image = UIImage(data: data!)
                }
            }
            
            cell.TrackNameLabel.text = charts.name!
            cell.ArtistNameLabel.text = charts.artist?.name!
            cell.PlayCountLabel.text = "Track Streams: " + charts.playcount!
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "SHOWDETAIL") //ChartDetailViewController
        {
            let destVC = segue.destination as! ChartDetailViewController
            var chart: Track
            if (searchIsActive)
            {
                chart = searchResults[(self.tableView.indexPathForSelectedRow?.row)!]
            }
            else
            {
                chart = chartObject[(self.tableView.indexPathForSelectedRow?.row)!]
            }
            //pass variables to ChartDetailViewController
            destVC.detailTrackName = chart.name
            destVC.detailTrackUrl = chart.url
            destVC.detailPlayCount = chart.playcount
            destVC.detailArtistName = chart.artist?.name
            destVC.detailArtistUrl = chart.artist?.url
            destVC.detailImageName = chart.image?[3].text
        }
    }
}
