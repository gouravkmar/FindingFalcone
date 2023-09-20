//
//  VehicleListView.swift
//  FindingFalcone
//
//  Created by Gourav Kumar on 18/09/23.
//

import UIKit

protocol VehicleSelectionProtocol{
    func didSelectVehicle(vehicleIndex : Int)
    func didDeselectVehicle(vehicleIndex:Int)
}
class VehicleListView: UIView {
    var selectedIndex : Int?
    var delegate : VehicleSelectionProtocol?
    var availableVehicles : [Vehicle]
    let planetIndex : Int
    let collectionView : UICollectionView
    init(frame: CGRect, planetIndex : Int) {
        collectionView = UICollectionView(frame: .zero,collectionViewLayout:  UICollectionViewFlowLayout())
        self.planetIndex = planetIndex
        self.availableVehicles = DataManager.shared.getVehiclesForPlanet(planetIndex: planetIndex)
        
        if let selectedVehicle = DataManager.shared.planets[planetIndex].vehicle {
            selectedIndex = selectedVehicle
        }
        
        super.init(frame: frame)
        collectionView.frame = bounds
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VehicleViewCell.self, forCellWithReuseIdentifier:VehicleViewCell.identifier)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 150 , bottom: 0, right: 0)
        collectionView.backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func refreshData(){
        self.availableVehicles = DataManager.shared.getVehiclesForPlanet(planetIndex: planetIndex)
        self.collectionView.reloadData()
    }
    
}
extension VehicleListView : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.availableVehicles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VehicleViewCell.identifier, for: indexPath) as! VehicleViewCell
        
        
        
        if let index = selectedIndex,
           DataManager.shared.vehicles[index].name == self.availableVehicles[indexPath.row].name
            {
            cell.isSelected = true
        }else {
            cell.isSelected = false
        }
        cell.vehicle = self.availableVehicles[indexPath.row]
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.height / 1.2 - 20.0, height: collectionView.bounds.height - 20.0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(availableVehicles[indexPath.row])
        var currentSelection = indexPath.row
        let vehicleName = availableVehicles[indexPath.row].name
        for (index,vehicle) in DataManager.shared.vehicles.enumerated() {
            if vehicle.name == vehicleName {
                currentSelection = index
            }
        }
        
        if selectedIndex == currentSelection {
            selectedIndex = nil
            if let delegate = delegate {
                delegate.didDeselectVehicle(vehicleIndex: currentSelection)
            }
        }else {
            
            if selectedIndex == nil , !DataManager.shared.canAddPlanet(){
                return
            }
            
            if selectedIndex != nil ,let delegate = delegate {
                delegate.didDeselectVehicle(vehicleIndex: currentSelection)
            }
            selectedIndex = currentSelection
            if let delegate = delegate {
                delegate.didSelectVehicle(vehicleIndex: currentSelection)
            }
        }
        self.refreshData()
            
    }
    
}
