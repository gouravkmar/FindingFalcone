//
//  SelectedVehicleDetails.swift
//  FindingFalcone
//
//  Created by Gourav Kumar on 19/09/23.
//

import UIKit

protocol VehicleViewProtocol {
    func didPressSubmit()
    
}

class SelectedVehicleDetails: UIView {
    var delegate : VehicleViewProtocol?
    var selectedPlanets: [Planet]
    var tableView : UITableView
    override init(frame: CGRect) {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height),style: .insetGrouped)
        self.selectedPlanets = []
        super.init(frame: frame)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.isUserInteractionEnabled = false
        self.addSubview(tableView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func changeSelection(selectedPlanets:[Planet]){
        self.selectedPlanets = selectedPlanets
        tableView.reloadData()
    }
}
extension SelectedVehicleDetails: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedPlanets.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !selectedPlanets.isEmpty{
            return "Selected Planets and Vehicles"
        }
        return ""
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = cell.defaultContentConfiguration()
        let vehicles = DataManager.shared.vehicles
        let planet = selectedPlanets[indexPath.row]
        config.text = planet.name + " -> "  + vehicles[planet.vehicle!].name
        cell.contentConfiguration = config
        cell.backgroundColor = .gray
        return cell
    }
    
    
}
