//
//  dataManager.swift
//  FindingFalcone
//
//  Created by Gourav Kumar on 17/09/23.
//

import Foundation
protocol DataProtocol{
   func didFetchAllData()
    func didGetFetchError(error : Error?)
}
class DataManager{
    var dataDelegate : DataProtocol?
    static let shared  = DataManager()
    var vehicles = [Vehicle]()
    var planets = [Planet]()
    var token = ""
    let tokenKey = "Finding.falcone.token"
    var totalTime = 0
    var totalSelectedPlanets = 0
    let group = DispatchGroup()
    init() {
        initData()
    }
    
    func refreshData(){
        refreshData(withFetch: true)
    }
    func refreshData(withFetch:Bool){
        if withFetch { initData()}
        else {
            if let delegate = self.dataDelegate {
                delegate.didFetchAllData()
            }
        }
    }
    
    private func initData(){
    
        fetchToken()
        fetchPlanets()
        fetchVehicle()
        group.notify(queue: .main){
            if let delegate = self.dataDelegate {
                delegate.didFetchAllData()
            }
        }
    }
    
    func fetchVehicle(){
        group.enter()
        APIManager.fetchData(for: .vehicles){ (type: [Vehicle]) in
            self.vehicles = type
            self.group.leave()
        }onFailure: { error in
            self.dataDelegate?.didGetFetchError(error: error)
            self.group.leave()
        }
    }
    func fetchPlanets(){
        group.enter()
        APIManager.fetchData(for: .planets){ (type: [Planet]) in
            self.planets = type
            self.group.leave()
        }onFailure: { error in
            self.dataDelegate?.didGetFetchError(error: error)
            self.group.leave()
        }
    }
    
    func fetchToken(forceRefresh : Bool = false,completion:(()->Void)? = nil){
        group.enter()
        
        if let key = UserDefaults.standard.string(forKey: tokenKey) , !forceRefresh{
            token = key
            group.leave()
            
        }else {
            APIManager.fetchData(for: .token, completion: { (token : [String:String]?) in
                self.token = (token?["token"])!
                UserDefaults.standard.set(self.token, forKey: self.tokenKey)
                if forceRefresh, let block = completion {
                    block()
                }
                self.group.leave()
            },onFailure: { error in
                self.dataDelegate?.didGetFetchError(error: error)
                self.group.leave()
            })
            
        }
    }
    
    func fetchResult(completion : @escaping([String:String])->Void){
        guard totalSelectedPlanets == 4 else {return}
        var finalPlanet = [String]()
        var finalVehicle = [String]()
        for planet in planets {
            if planet.vehicle != nil {
                finalPlanet.append("\(planet.name)")
                finalVehicle.append("\(vehicles[planet.vehicle!])")
            }
        }
        let dict = [
            "token":"\(String(describing: self.token))",
            "planet_names":finalPlanet,
            "vehicle_names":finalVehicle
        ] as [String : Any]
        APIManager.fetchData(for: .search, data: dict, completion: { (dict : [String:String]) in
            completion(dict)
        })
        
    }
    func canAddPlanet()->Bool{
        return totalSelectedPlanets < 4
    }
    func selectVehicle(vehicleIndex:Int,planetIndex:Int){
        guard planets.count > planetIndex, vehicles.count>vehicleIndex else { return }
        planets[planetIndex].vehicle = vehicleIndex
        vehicles[vehicleIndex].remainingNumber -= 1
        let speed = vehicles[vehicleIndex].speed
        let dist = planets[planetIndex].distance
        totalTime += dist / speed
        totalSelectedPlanets += 1
    }
    func deselectVehicle(planetIndex:Int){
        guard planets.count > planetIndex else { return }
        let vehicleIndex = planets[planetIndex].vehicle!
        vehicles[vehicleIndex].remainingNumber += 1
        let dist = planets[planetIndex].distance
        let speed = vehicles[vehicleIndex].speed
        totalTime -= dist / speed
        planets[planetIndex].vehicle = nil
        totalSelectedPlanets -= 1
    }
    func getVehiclesForPlanet(planetIndex:Int)->[Vehicle]{
        guard planets.count > planetIndex else { return []}
        var occupiedVehicles = [Int]()
        var restVehicles = [Vehicle]()
        if vehicles.count == 0 {
            return restVehicles
        }
        
        for (index,vehicle) in vehicles.enumerated(){
            if vehicle.remainingNumber > 0 , vehicle.maxDist >= planets[planetIndex].distance {
                restVehicles.append(vehicle)
            }else if index == planets[planetIndex].vehicle {
                restVehicles.append(vehicle)
            }
        }
        
        return restVehicles
    }
    func clearAllVehicleSelection(){
        for index in 0..<planets.count{
            planets[index].vehicle = nil
        }
        totalSelectedPlanets = 0
        totalTime = 0
    }
    func getTotalTime()->Int{
        return totalTime
    }
    
    
    
    
}
