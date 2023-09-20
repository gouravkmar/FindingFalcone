//
//  PlanetsSelectionView.swift
//  FindingFalcone
//
//  Created by Gourav Kumar on 18/09/23.
//

import UIKit
protocol PlanetPickerProtocol:AnyObject {
    func didChangeFocusTo(index : Int)
}
class PlanetsSelectionView: UIView {
    var planetDelegate : PlanetPickerProtocol?
    let pickerView : UIPickerView
    lazy var planetArray  = DataManager.shared.planets
    override init(frame: CGRect) {
        
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        super.init(frame: frame)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        addSubview(pickerView)
        layer.cornerRadius = 20.0
        layer.masksToBounds = true
        
    }
    func reloadData(){
       
        if planetArray.count == 0 {
            planetArray  = DataManager.shared.planets
            if let delegate = self.planetDelegate , !self.planetArray.isEmpty{
                delegate.didChangeFocusTo(index:0)
            }
        }
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
extension PlanetsSelectionView : UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        planetArray.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let delegate = planetDelegate {
            delegate.didChangeFocusTo(index: row)
        }
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if  planetArray.count  > row {
            let planet = DataManager.shared.planets[row]
            let isVehiclePresent = planet.vehicle != nil
            let attributes : [NSAttributedString.Key:Any] = [
                .font : UIFont.boldSystemFont(ofSize: 20),
                .foregroundColor : isVehiclePresent ? UIColor.green:UIColor.black,
            ]
            return NSAttributedString(string: planet.name,attributes: attributes)
        }
        return NSAttributedString(string: "No planets to look into")
    }
    
    
    
    
    
}
