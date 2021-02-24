//
//  SimilarArtistsTableViewController.swift
//  ZochowskiLastFMCharts
//
//  Created by Jason Zochowski on 4/18/19.
//  Copyright © 2019 Jason Zochowski. All rights reserved.
//

import UIKit

//structs to load the JSON data for the similar artists api from Last.FM
struct SimilarArtistsRoot: Decodable { //Root struct
    private enum CodingKeys: String, CodingKey {
        case similarartists = "similarartists"
    }
    let similarartists: SimilarArtists?
}
struct SimilarArtists: Decodable { //similarartists:
    private enum CodingKeys: String, CodingKey {
        case artist = "artist"
    }
    let artist: [Artist2]?
}
struct Artist2: Decodable { //artist:
    let name:String?
    let url:String?
    let image: [ImageFile2]?
    
    init(name: String, url : String, image: [ImageFile2]) {
        self.name = name
        self.url = url
        self.image = image
    }
}

struct ImageFile2 { //image: []
    
    let text : String?
    let size : String?
    
    init(text: String, size: String) {
        self.text = text
        self.size = size
    }
}

extension ImageFile2 : Decodable {
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

class SimilarArtistsTableViewController: UITableViewController {

    var ArtistName:String!
    var similarartistsapi:String = "http://ws.audioscrobbler.com/2.0/?method=artist.getsimilar&artist=cher&api_key=8cc56eb58445b9408634b6626ea1b151&format=json" //api from last.fm
    
    var rootObject = [SimilarArtistsRoot]() //root object array
    var similarArtistObject = [Artist2]() //Artist2 object array

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = ArtistName + ": Similar Artists"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 175
        loadJSON()
    }
    
    func loadJSON() //load JSON from link
    {
        //Create an optional variable to hold the URL
        similarartistsapi = similarartistsapi.replacingOccurrences(of: "cher", with: ArtistName!) //insert artist name into url
        similarartistsapi = similarartistsapi.replacingOccurrences(of: " ", with: "+")
        //Create a string of typed URL
        let api_url = URL(string: similarartistsapi)// else {return}
        //Create a URLSession to get the json data
        let task = URLSession.shared.dataTask(with: api_url!) {(data, response, err) in
            //if the data is not empty store it in jsonData
            if (data != nil) {
                guard let jsonData = data else {return}
                //parse through json data using JSONDecoder
                do {
                    let decoder = JSONDecoder()
                    let root = try decoder.decode(SimilarArtistsRoot.self, from: jsonData)
                    for trck in (root.similarartists?.artist)!
                    {
                        let artistname = trck.name
                        let artisturl = trck.url
                        let imagename = trck.image
                        
                        self.similarArtistObject.append(Artist2(name: artistname!, url: artisturl!, image: imagename!)) //append to similarArtistObject array
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch let jsonErr {
                    print("Error Reading JSON: ",jsonErr)
                }
            }//resume()
        }
        
        task.resume()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return similarArtistObject.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL2", for: indexPath) as! SimilarArtistsTableViewCell
        let artist: Artist2 = self.similarArtistObject[indexPath.row]
        let artistImageURL = URL(string: (artist.image?[3].text)!)
        DispatchQueue.global().async { //download and display image in ArtistArtImageView
            let data = try? Data(contentsOf: artistImageURL!)
            DispatchQueue.main.async {
                cell.ArtistArtImageView.image = UIImage(data: data!)
            }
        }
        cell.ArtistNameLabel.text = artist.name! //artist name
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
        if (segue.identifier == "SIMILARARTISTPROFILE")
        {
            //set destination to ArtistProfileWebViewController
            let destVC = segue.destination as! ArtistProfileWebViewController
            //pass the website and artist name from this view
            let artist: Artist2 = similarArtistObject[(self.tableView.indexPathForSelectedRow?.row)!]
            destVC.ArtistName = artist.name
            destVC.ArtistUrl = artist.url
        }
    }
 

}
