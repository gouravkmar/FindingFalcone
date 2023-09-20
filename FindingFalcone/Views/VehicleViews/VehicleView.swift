//
//  VehicleView.swift
//  FindingFalcone
//
//  Created by Gourav Kumar on 18/09/23.
//

import UIKit

class VehicleView: UIView {


    var vehicle : Vehicle?
    var mainView : UIView?
    init(frame : CGRect,planet:Int) {
        super.init(frame: frame)
        if let vehicleIndex = DataManager.shared.planets[planet].vehicle {
            self.vehicle = DataManager.shared.vehicles[vehicleIndex]
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}



