//
//  MainHeader.swift
//  FindingFalcone
//
//  Created by Gourav Kumar on 18/09/23.
//

import UIKit

class MainHeader: UIView {
    init(){
        
        let imageSize = 70.0
        let padding = 5.0
        let labelHeight = 30.0
        var ypos = 100.0 //default
        let maxwidth = UIScreen.main.bounds.width
        var safeY = 0.0
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let safeAreaInsets = keyWindow.safeAreaInsets
            safeY = safeAreaInsets.top
        }
        safeY = 0
        
        
        let headingLabel = UILabel(frame: CGRect(x: imageSize + 3 * padding, y: ypos + padding, width: maxwidth - imageSize - 4 * padding, height: labelHeight))
        ypos += labelHeight + padding
        
        let falconeImage = UIImage(named: "falcone")
        let falconeImageView = UIImageView(frame: CGRect(x: padding, y: ypos,  width: imageSize , height: imageSize))
        falconeImageView.layer.cornerRadius = imageSize / 2
        falconeImageView.image = falconeImage
        falconeImageView.layer.masksToBounds = true
        
        
        let descriptionLabel = UILabel(frame: CGRect(x: imageSize + 3 * padding, y: ypos + padding, width: maxwidth - imageSize - 4 * padding, height: labelHeight))
        ypos += labelHeight + padding
        let extraInfoLabel = UILabel(frame: CGRect(x: imageSize + 3 *  padding, y: ypos + padding, width: maxwidth - imageSize - 4 * padding, height: labelHeight))
        
        ypos += labelHeight + padding
        

        ypos += padding
        
        
        
        let header = UIView(frame: CGRect(x: 0, y: safeY, width: maxwidth, height: ypos))
        header.layer.cornerRadius = 20.0
        header.backgroundColor = UIColor.clear
        
        let gradientView = CAGradientLayer()
        gradientView.frame = header.bounds
        gradientView.colors = [UIColor.clear.cgColor,UIColor.blue.cgColor]
        gradientView.endPoint = CGPoint(x: 0, y: 0)
        gradientView.startPoint = CGPoint(x: 0, y: 1)
        
        header.layer.addSublayer(gradientView)
        
        super.init(frame: header.frame)
        
        headingLabel.attributedText = getHeading()
        headingLabel.numberOfLines = 1
        headingLabel.minimumScaleFactor = 0.5
        headingLabel.adjustsFontSizeToFitWidth = true
        headingLabel.textAlignment = .center
        
        descriptionLabel.attributedText = getDesc()
        descriptionLabel.numberOfLines = 1
        descriptionLabel.minimumScaleFactor = 0.5
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.textAlignment = .center
        
        extraInfoLabel.attributedText = getExtraInfo()
        extraInfoLabel.numberOfLines = 1
        extraInfoLabel.minimumScaleFactor = 0.5
        extraInfoLabel.adjustsFontSizeToFitWidth = true
        extraInfoLabel.textAlignment = .center
        
        
        header.addSubview(falconeImageView)
        header.addSubview(headingLabel)
        header.addSubview(descriptionLabel)
        header.addSubview(extraInfoLabel)
        self.addSubview(header)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getHeading()->NSAttributedString {
        let headingLabel = "Welcome to Finding Falcone"
        let attributes : [NSAttributedString.Key:Any] = [
            .font : UIFont.boldSystemFont(ofSize: 30),
            .foregroundColor : UIColor.cyan
        ]
        let attrib = NSAttributedString(string: headingLabel,attributes: attributes)
        return attrib
    }
    func getDesc()->NSAttributedString {
        let descriptionLabel = "Select 4 Planets and 4 vehicles for them"
        let attributes : [NSAttributedString.Key:Any] = [
            .font : UIFont.systemFont(ofSize: 12),
            .foregroundColor : UIColor.white,
        ]
        let attr = NSAttributedString(string: descriptionLabel, attributes: attributes)
        return attr
    }
    func getExtraInfo()->NSAttributedString {
        let extraInfoLabel = "Try to use the least time and optimum vehicles"
        let attributes : [NSAttributedString.Key:Any] = [
            .font : UIFont.systemFont(ofSize: 14),
            .foregroundColor : UIColor.black
        ]
        let attr = NSAttributedString(string: extraInfoLabel, attributes: attributes)
        return attr
    }
   
}
