//
//  TabCollectionViewCell.swift
//  NewsApp
//
//  Created by Saipujith on 28/03/21.
//

import UIKit

class TabCollectionViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    var indicatorView: UIView!
    
    override var isSelected: Bool {
        
        didSet{
            UIView.animate(withDuration: 0.30) { [self] in
                indicatorView.backgroundColor = self.isSelected ? UIColor.colorFromHex("#337ABC") : UIColor.clear
                titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
                self.layoutIfNeeded()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        addConstraintsWithFormatString(formate: "H:|[v0]|", views: titleLabel)
        addConstraintsWithFormatString(formate: "V:|[v0]|", views: titleLabel)
        titleLabel.textColor = UIColor.colorFromHex("#337ABC")
        addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        setupIndicatorView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }
    
    func setupIndicatorView() {
        indicatorView = UIView()
        addSubview(indicatorView)
        
        addConstraintsWithFormatString(formate: "H:|[v0]|", views: indicatorView)
        addConstraintsWithFormatString(formate: "V:[v0(3)]|", views: indicatorView)
    }
    
}

