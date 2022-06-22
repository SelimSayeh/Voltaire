//
//  onBoardingCollectionViewCell.swift
//  Voltaire
//
//  Created by user210230 on 6/18/22.
//

import UIKit

class onBoardingCollectionViewCell : UICollectionViewCell{
    
    
    @IBOutlet weak var slideTitleLabel: UILabel!
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideDescriptionLabel: UILabel!
    static let identifier = String(describing:onBoardingCollectionViewCell.self)
    func setup(_ slide :onBoardingSlide) {
        slideImageView.image = slide.image
        slideTitleLabel.text = slide.title
        slideDescriptionLabel.text = slide.description
    }
    
}
