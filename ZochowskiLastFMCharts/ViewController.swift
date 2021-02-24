//
//  ViewController.swift
//  ZochowskiLastFMCharts
//
//  Created by Jason Zochowski on 4/9/19.
//  Copyright © 2019 Jason Zochowski. All rights reserved.
//
/*
import UIKit

struct Root: Decodable {
    private enum CodingKeys: String, CodingKey {
        case tracks = "tracks"
    }
    let tracks: Tracks?
}
struct Tracks: Decodable {
    private enum CodingKeys: String, CodingKey {
        case track = "track"
    }
    let track: [Track]?
    //let image: [Image]
}
struct Track: Decodable {
    /*private enum CodingKeys: String, CodingKey {
        case artist = "artist"
    }*/
    let name:String?
    let listeners:String?
    let playcount:String?
    let url:String?
    let artist: Artist?
    let image: [ImageFile]?
}
struct Artist: Decodable {
    /*private enum CodingKeys: String, CodingKey {
        case name = "NAME"
        case url = "URL"
    }*/
        let name:String?
        let url:String?
    }

struct ImageFile {
    
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

class ViewController: UITableViewController {
    
    var chartObject = [Root]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.rowHeight = 230
        loadJSON()
    }
    func loadJSON()
    {
        //Create an optional variable to hold the URL
        let jsonURL = "http://ws.audioscrobbler.com/2.0/?method=chart.gettoptracks&api_key=8cc56eb58445b9408634b6626ea1b151&format=json"
        //Create a string of typed URL
        let api_url = URL(string: jsonURL)// else {return}
        //Create a URLSession to get the json data
        let task = URLSession.shared.dataTask(with: api_url!) {(data, response, err) in
            //if the data is not empty store it in jsonData
            if (data != nil) {
                guard let jsonData = data else {return}
                //view data as string before parsing
                //let stringData = String(data:jsonData, encoding: .utf8)
                //print(stringData!)
                
                //https://stackoverflow.com/questions/46636533/json-parsing-in-swift-4-with-complex-nested-data
                //https://www.reddit.com/r/swift/comments/8iegdn/need_help_decoding_json_with_decodable/
                //https://stackoverflow.com/questions/48007348/expected-to-decode-arrayany-but-found-a-dictionary-instead
                //https://stackoverflow.com/questions/50664016/decoding-nested-json-with-swift-4
                //parse through json data using JSONDecoder
                do {
                    print ("entering do")
                    let decoder = JSONDecoder()
                    let root = try decoder.decode(Root.self, from: jsonData)
                    print ("TEST")
                    var i = 0
                    for _ in (root.tracks?.track)!
                    {
                        let trackname: String! = root.tracks?.track?[i].name
                        let trackurl: String! = root.tracks?.track?[i].url
                        let tracklisteners: String! = root.tracks?.track?[i].listeners
                        let trackplaycount: String! = root.tracks?.track?[i].playcount
                        let artistname: String! = root.tracks?.track?[i].artist?.name
                        let artisturl: String! = root.tracks?.track?[i].artist?.url
                        let image: String! = root.tracks?.track?[i].image?[3].text
                        
                        print ("Tracks name: \(trackname!)")
                        print ("Track url: \(trackurl!)")
                        print ("Track duration: \(tracklisteners!)")
                        print ("Track playcount: \(trackplaycount!)")
                        print ("Artist name: \(artistname!)")
                        print ("Artist url: \(artisturl!)")
                        print ("Image: \(image!)")
                        i = i + 1
                    }
                    //let trackdata = tracks.track?[0]
                    //print (trackdata?.name!)
                    //print ("track name",tracks.track?.first?.name!)
                    //print (tracks[0].artist.name!)
                    //print ("exiting do")
                    /*print ("tracks")
                    let tracks = try JSONDecoder().decode([Tracks].self, from: jsonData)
                    let track = try JSONDecoder().decode([Track].self, from: jsonData)
                    let artist = try JSONDecoder().decode([Artist].self, from: jsonData)
                    //print("firstname: \(jsonData.firstName)")
                    //check the data after parsing
                    //print(students)
                     */
                    /*var i = 0
                    for _ in tracks {
                        print ("Entering for loop")
                        let trackname = tracks[i].track.name!
                        //let duration = tracks[i].track.duration!
                        //let playcount = tracks[i].track.playcount!
                        let trackurl = tracks[i].track.url!
                        
                        let artistname = tracks[i].artist.name!
                        let artisturl = tracks[i].artist.url!
                        print (trackname, trackurl, artistname, artisturl, "\n")
                        i = i + 1
                        print ("End of for loop")
                    }*/
                    print ("Exiting for and do")
                    
                }catch let jsonErr {
                    print("Error Reading JSON: ",jsonErr)
                }
            }//resume()
        }
        
        task.resume()
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //return the amount of objects in the object array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartObject.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! ChartTableViewCell
        let charts: Root = chartObject[indexPath.row]
        let chartImageName = UIImage(named: (charts.tracks?.track?[indexPath.row].image?[3].text)!)
        cell.ChartImageView.image = chartImageName
        cell.TrackNameLabel.text = charts.tracks?.track?[indexPath.row].name!
        cell.ArtistNameLabel.text = charts.tracks?.track?[indexPath.row].artist?.name!
        cell.PlayCountLabel.text = charts.tracks?.track?[indexPath.row].playcount!
        return cell
    }

}
*/
