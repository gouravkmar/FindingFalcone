//
//  VehicleViewCellCollectionViewCell.swift
//  FindingFalcone
//
//  Created by Gourav Kumar on 18/09/23.
//

import UIKit

class VehicleViewCell: UICollectionViewCell {
    
    static let identifier = "VehicleViewCell"
    let imageSize = 100.0
    let textheight = 15.0
    var vehicle : Vehicle! {
        didSet {
            
            setupCell()
        }
    }
    override func prepareForReuse() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        isSelected = false
    }
    
    func setupCell(){
        
        let frame = self.frame
        let stack = UIStackView()
        stack.backgroundColor = .clear
        stack.alignment = .center
        stack.spacing = 5.0
        stack.axis = .vertical
        
        
        let imageView = UIImageView()
        let image =  UIImage(named: vehicle.name)
        imageView.image = image
        imageView.layer.cornerRadius = 20.0
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .brown
        imageView.contentMode = .scaleToFill
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: imageSize, height: imageSize)
        stack.addArrangedSubview(imageView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: textheight))
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.text = vehicle.name
        
        let speedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: textheight))
        speedLabel.font = UIFont.systemFont(ofSize: 12)
        speedLabel.text = String(" Speed: \(vehicle.speed)")
        
        let distLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: textheight))
        distLabel.font = UIFont.systemFont(ofSize: 12)
        distLabel.text = String("Max Range: \(vehicle.maxDist)")
        
        
        let numLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: textheight))
        numLabel.font = UIFont.systemFont(ofSize: 12)
        numLabel.text = String("Total Vechicles: \(vehicle.totalNumber)")
        
        let remainingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: textheight))
        remainingLabel.font = UIFont.systemFont(ofSize: 12)
        remainingLabel.text = String("Free Vechicles: \(vehicle.remainingNumber)")
        
        let outerview = UIView(frame: bounds)
        if isSelected {
            outerview.backgroundColor = .green
        }else {
            outerview.backgroundColor = .white
        }
        
        let innerview = UIView(frame: CGRect(x: 5, y: 5, width: frame.width - 10.0 , height: frame.height - 10.0))
        innerview.backgroundColor = .white
    
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(numLabel)
        stack.addArrangedSubview(remainingLabel)
        stack.addArrangedSubview(distLabel)
        stack.addArrangedSubview(speedLabel)
        
        stack.frame = CGRect(x: 10, y: 10, width: innerview.frame.width - 20.0 , height: innerview.frame.height - 20.0)
        
        outerview.layer.cornerRadius = 60.0
        innerview.layer.cornerRadius = 55.0
        outerview.addSubview(innerview)
        innerview.addSubview(stack)
        innerview.contentMode = .center
        self.addSubview(outerview)
    }
    
    
}
