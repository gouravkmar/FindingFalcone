//
//  HomeView.swift
//  FindingFalcone
//
//  Created by Gourav Kumar on 17/09/23.
//

import UIKit

class HomeView: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        view.backgroundColor = .gray
        setupUI()
        
    }
    var currentPlanetIndex = 0
    var vehicleView : VehicleListView!
    var refreshCount = 0
    var planetView : PlanetsSelectionView!
    let mainHeader = MainHeader()
    let data = DataManager.shared
    let loader = UIActivityIndicatorView()
    var selectedVehicleView : SelectedVehicleDetails!
    var vehicleDetailView = UIView()
    var hitButton = UIView()
    var timeView = UILabel()
    var totalTime = 0
    func setupUI(){
        data.dataDelegate = self
        let overlap = 5.0
        let yPos = mainHeader.frame.height - overlap
        let width = UIScreen.main.bounds.width / 3
        let height = UIScreen.main.bounds.height - yPos - 400
        let planetSelector = PlanetsSelectionView(frame: CGRect(x: 0, y: yPos, width: width, height: height))
        
        
        vehicleDetailView.frame = CGRect(x: 0 , y: yPos, width: UIScreen.main.bounds.width  - 20 , height: height)
        vehicleDetailView.backgroundColor = .clear
        planetView = planetSelector
        planetView.backgroundColor = .clear
        planetSelector.planetDelegate = self
        
        
        loader.frame = CGRect(x: 0, y: yPos, width: UIScreen.main.bounds.width, height: height)
        loader.backgroundColor = UIColor(white: 0.7, alpha: 0.8)
        loader.startAnimating()
        loader.color = UIColor.green
        loader.style = .large
        
        selectedVehicleView = SelectedVehicleDetails(frame: CGRect(x: 0, y: yPos + height + 20, width: UIScreen.main.bounds.width, height: 240  ))
        selectedVehicleView.backgroundColor = .clear
        selectedVehicleView.delegate = self
        
        let timeHeight =  selectedVehicleView.frame.maxY + 10
        timeView = UILabel(frame: CGRect(x: 0, y: timeHeight, width: UIScreen.main.bounds.width, height: 30))
        timeView.backgroundColor = .cyan.withAlphaComponent(0.8)
        timeView.text = "Total Time : 0"
        timeView.textAlignment = .center
        timeView.layer.cornerRadius = 15
        timeView.layer.masksToBounds = true
        
        let buttonHeight = UIScreen.main.bounds.height - timeView.frame.maxY - 50
        hitButton.frame =  CGRect(x: 0, y: timeView.frame.maxY + 5  , width:UIScreen.main.bounds.width , height: buttonHeight)
        hitButton.layer.cornerRadius = buttonHeight / 2
        hitButton.backgroundColor = .gray
        hitButton.isUserInteractionEnabled = false
        
        let hitLabel = UILabel(frame: hitButton.bounds)
        hitLabel.textAlignment = .center
        hitLabel.numberOfLines = 1
        hitLabel.text = "Try A Hit!!"
        hitLabel.font = UIFont.boldSystemFont(ofSize: 20)
        hitLabel.backgroundColor = .clear
        hitButton.addSubview(hitLabel)
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(didPressHit))
        hitButton.addGestureRecognizer(gestureRecogniser)
        
        
        view.addSubview(vehicleDetailView)
        view.addSubview(planetSelector)
        view.addSubview(loader)
        view.addSubview(mainHeader)
        view.addSubview(selectedVehicleView)
        view.addSubview(timeView)
        view.addSubview(hitButton)
    }
}
extension HomeView : DataProtocol {
    
    func didGetFetchError(error: Error?) {
        let errorDisc = error?.localizedDescription ?? "Error in API fetch"
        let alertController = UIAlertController(
            title: "Error in fetching data",
            message: errorDisc,
            preferredStyle: .alert
        )
        
        if refreshCount < 3 {
            let apiAction = UIAlertAction(
                title: "Try again",
                style: .default,
                handler: { action in
                    DataManager.shared.refreshData(withFetch: true)
                }
            )
            refreshCount += 1
            alertController.addAction(apiAction)
        }
        let offlineAction = UIAlertAction(
            title: "Use Dummy Data",
            style: .default,
            handler: { action in
                DataManager.shared.vehicles = getVehicleArray()
                DataManager.shared.planets = getPlanetArray()
                DataManager.shared.refreshData(withFetch: false)
            }
        )
        alertController.addAction(offlineAction)
        present(alertController, animated: true, completion: nil)
    }
        
    
    func didFetchAllData() {
        loader.stopAnimating()
        planetView.reloadData()
    }
    
    @objc func didPressHit() {
        print("Hit pressed")
        let vc = ResultVC()
        vc.timeTaken = totalTime
        self.present(vc, animated: true)
    }
    
    
}
extension HomeView : PlanetPickerProtocol {
    func didChangeFocusTo(index: Int) {
        currentPlanetIndex = index
        if DataManager.shared.planets.count > index{
            vehicleView = VehicleListView(frame: vehicleDetailView.bounds, planetIndex: index)
            vehicleView.delegate = self
            for subview in vehicleDetailView.subviews {
                subview.removeFromSuperview()
            }
            vehicleDetailView.addSubview(vehicleView)
            
        }
    }
}
extension HomeView :  VehicleSelectionProtocol {
    func didSelectVehicle(vehicleIndex: Int) {
        DataManager.shared.selectVehicle(vehicleIndex: vehicleIndex, planetIndex: currentPlanetIndex)
        planetView.reloadData()
        totalTime = 0
        let vehicleArr = DataManager.shared.vehicles
        selectedVehicleView.changeSelection(selectedPlanets: DataManager.shared.planets.filter({
            planet in
            if(planet.vehicle != nil) {
                totalTime += planet.distance / vehicleArr[planet.vehicle!].speed
            }
            return planet.vehicle != nil
        }))
        timeView.text = "Total Time : \(totalTime)"
        if DataManager.shared.totalSelectedPlanets == 4 {
            hitButton.backgroundColor = .orange
            hitButton.isUserInteractionEnabled = true
        }else {
            hitButton.backgroundColor = .gray
            hitButton.isUserInteractionEnabled = false
        }
        
    }
    func didDeselectVehicle(vehicleIndex: Int) {
        DataManager.shared.deselectVehicle(planetIndex: currentPlanetIndex)
        totalTime = 0
        let vehicleArr = DataManager.shared.vehicles
        selectedVehicleView.changeSelection(selectedPlanets: DataManager.shared.planets.filter({
            planet in
            if(planet.vehicle != nil) {
                totalTime += planet.distance / vehicleArr[planet.vehicle!].speed
            }
            return planet.vehicle != nil
        }))
        timeView.text = "Total Time : \(totalTime)"
        hitButton.backgroundColor = .gray
        hitButton.isUserInteractionEnabled = false
        planetView.reloadData()
    }
}
extension HomeView : VehicleViewProtocol {
    func didPressSubmit() {
        
    }
    
    
}
