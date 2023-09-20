//
//  Vehicle.swift
//  FindingFalcone
//
//  Created by Gourav Kumar on 17/09/23.
//

import Foundation
struct Vehicle : Decodable{
    let name : String
    let totalNumber : Int
    let maxDist : Int
    let speed : Int
    enum CodingKeys: String , CodingKey {
        case name
        case totalNumber = "total_no"
        case maxDist = "max_distance"
        case speed 
    }
    var isAssigned =  false
    var remainingNumber = 0
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.totalNumber = try container.decode(Int.self, forKey: .totalNumber)
        self.maxDist = try container.decode(Int.self, forKey: .maxDist)
        self.speed = try container.decode(Int.self, forKey: .speed)
        self.remainingNumber = self.totalNumber
    }
    
    init(name: String, totalNumber: Int, maxDist: Int, speed: Int, isAssigned: Bool = false) {
        self.name = name
        self.totalNumber = totalNumber
        self.maxDist = maxDist
        self.speed = speed
        self.isAssigned = isAssigned
        self.remainingNumber = totalNumber
    }
    
}
