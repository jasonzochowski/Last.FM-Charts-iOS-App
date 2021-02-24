//
//  ChartTableViewCell.swift
//  ZochowskiLastFMCharts
//
//  Created by Jason Zochowski on 4/12/19.
//  Copyright © 2019 Jason Zochowski. All rights reserved.
//

import UIKit

class ChartTableViewCell: UITableViewCell {

    @IBOutlet weak var ChartImageView: UIImageView!
    
    @IBOutlet weak var TrackNameLabel: UILabel!
    
    @IBOutlet weak var ArtistNameLabel: UILabel!
    
    @IBOutlet weak var PlayCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
