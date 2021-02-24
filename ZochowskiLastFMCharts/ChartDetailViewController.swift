//
//  ChartDetailViewController.swift
//  ZochowskiLastFMCharts
//
//  Created by Jason Zochowski on 4/17/19.
//  Copyright © 2019 Jason Zochowski. All rights reserved.
//

import UIKit

//structs to load JSON data from about artist api on Last.FM
struct ArtistRoot: Decodable { //root struct
    private enum CodingKeys: String, CodingKey {
        case artist = "artist"
    }
    let artist: ArtistInfo?
}
struct ArtistInfo: Decodable { //artist:
    private enum CodingKeys: String, CodingKey {
        case stats = "stats"
        case bio = "bio"
    }
    let stats: Stats?
    let bio: Bio
    init(initstats: Stats, initbio: Bio) {
        self.stats = initstats
        self.bio = initbio
    }
}
struct Stats: Decodable { //stats:
    let playcount:String?
}
struct Bio: Decodable //bio:
{
    let content: String?
}


class ChartDetailViewController: UIViewController {
    
    @IBOutlet weak var ArtistArtImageView: UIImageView!
    
    @IBOutlet weak var TrackNameLabel: UILabel!
    
    @IBOutlet weak var PlayCountLabel: UILabel!
    
    @IBOutlet weak var TotalPlayCountLabel: UILabel!
    
    @IBOutlet weak var ArtistDescriptionTextView: UITextView!
    
    var detailTrackName:String! //variables to hold passed data from ChartsTableViewController
    var detailTrackUrl:String!
    var detailPlayCount:String!
    var detailArtistName:String!
    var detailArtistUrl:String!
    var detailImageName:String!
    var artistinfourl:String = "http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=Cher&api_key=8cc56eb58445b9408634b6626ea1b151&format=json" //api url
    
    var artistRootObject = [ArtistRoot]() //root object array
    override func viewDidLoad() {
        super.viewDidLoad()
        artistinfourl = artistinfourl.replacingOccurrences(of: "Cher", with: detailArtistName!) //insert artist name into url
        artistinfourl = artistinfourl.replacingOccurrences(of: " ", with: "+")
        loadJSON()
        let url = URL(string: detailImageName)
        downloadImage(from: url!)
        // Do any additional setup after loading the view.
        navigationItem.title = detailArtistName
        TrackNameLabel.text = detailTrackName
        PlayCountLabel.text = "Track Streams: " + detailPlayCount
        
    }
    func downloadImage(from url: URL) //download and display image in ArtistArtImageView
    {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.ArtistArtImageView.image = UIImage(data: data!)
            }
        }
    }
    func loadJSON()
    {
        //Create a string of typed URL
        let api_url = URL(string: artistinfourl)
        //Create a URLSession to get the json data
        let task = URLSession.shared.dataTask(with: api_url!) {(data, response, err) in
            //if the data is not empty store it in jsonData
            if (data != nil) {
                guard let jsonData = data else {return}
                //parse through json data using JSONDecoder
                do {
                    let decoder = JSONDecoder()
                    let root = try decoder.decode(ArtistRoot.self, from: jsonData)
                    let totalplaycount = root.artist?.stats?.playcount!
                    var content = root.artist?.bio.content!
                    if let index = content!.range(of: "<a href")?.lowerBound { //remove html links within artist discription
                        let substring = content?[..<index]
                        content = String(substring!)
                    }
                    DispatchQueue.main.async {
                        self.TotalPlayCountLabel.text = "Artist Streams: " + totalplaycount!
                        self.ArtistDescriptionTextView.text = content
                    }
                }catch let jsonErr {
                    print("Error Reading JSON: ",jsonErr)
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "SONG") //play song view
        {
            let destVC = segue.destination as! PlaySongWebViewController
            //pass song url and track name
            destVC.TrackUrl = self.detailTrackUrl
            destVC.TrackName = self.detailTrackName
        }
        else if (segue.identifier == "ARTIST") //artist profile view
        {
            let destVC = segue.destination as! ArtistProfileWebViewController
            //pass artist profile url and artist name
            destVC.ArtistUrl = self.detailArtistUrl
            destVC.ArtistName = self.detailArtistName
        }
        else if (segue.identifier == "SIMILAR ARTISTS") //similar artists table view
        {
            let destVC = segue.destination as! SimilarArtistsTableViewController
            //Pass API link to similar artists for selected artist
            destVC.ArtistName = self.detailArtistName
        }
    }


}
