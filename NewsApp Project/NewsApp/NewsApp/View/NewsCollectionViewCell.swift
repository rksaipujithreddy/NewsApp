//
//  NewsCollectionViewCell.swift
//  NewsApp
//
//  Created by Saipujith on 29/03/21.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var labelNews: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with imageName: String, labelName:String) {

        labelNews?.text  = labelName
        
        DispatchQueue.global(qos: .userInteractive).async {
            if let url = URL(string:imageName) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    
                    DispatchQueue.main.async { /// execute on main thread
                        self.imageNews?.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }

        imageNews.layer.cornerRadius = 5
        viewShadow.layer.cornerRadius = 15
        viewShadow.layer.masksToBounds = false
        viewShadow.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        viewShadow.layer.shadowOffset = CGSize(width: 15, height: 15)
        viewShadow.layer.shadowOpacity = 0.8
        
        
    }
}
