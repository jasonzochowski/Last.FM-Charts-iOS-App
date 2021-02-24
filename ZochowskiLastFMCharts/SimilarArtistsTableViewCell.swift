//
//  SimilarArtistsTableViewCell.swift
//  ZochowskiLastFMCharts
//
//  Created by Jason Zochowski on 4/18/19.
//  Copyright © 2019 Jason Zochowski. All rights reserved.
//

import UIKit

class SimilarArtistsTableViewCell: UITableViewCell {

    @IBOutlet weak var ArtistArtImageView: UIImageView!
    
    @IBOutlet weak var ArtistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
