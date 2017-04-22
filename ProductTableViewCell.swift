//
//  ProductTableViewCell.swift
//  Caue
//
//  Created by Cauê Almeida on 4/22/17.
//  Copyright © 2017 Usuário Convidado. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var tfName: UILabel!
    @IBOutlet weak var tfPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
