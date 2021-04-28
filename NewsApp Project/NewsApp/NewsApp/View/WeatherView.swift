//
//  WeatherView.swift
//  NewsApp
//
//  Created by Saipujith on 30/03/21.
//

import UIKit

class WeatherView: UIView {

    @IBOutlet weak var labelWeather: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelCIty: UILabel!
    @IBOutlet weak var labelMin: UILabel!
    @IBOutlet weak var labelMax: UILabel!
    
    class func instanceFromNib() -> WeatherView {
        return UINib(nibName: "WeatherView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WeatherView
        }
    
    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.systemTeal.cgColor, UIColor.white.cgColor]
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

