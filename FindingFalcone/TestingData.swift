
let planetDict: [[String: Any]] = [
    [
        "name": "Donlon",
        "distance": 100
    ],
    [
        "name": "Enchai",
        "distance": 200
    ],
    [
        "name": "Jebing",
        "distance": 300
    ],
    [
        "name": "Sapir",
        "distance": 400
    ],
    [
        "name": "Lerbin",
        "distance": 500
    ],
    [
        "name": "Pingasor",
        "distance": 600
    ]
]



func getPlanetArray()->[Planet]{
    var planets: [Planet] = []
    for planetData in planetDict {
        if let name = planetData["name"] as? String, let distance = planetData["distance"] as? Int {
            let planet = Planet(name: name, distance: distance)
            planets.append(planet)
        }
    }
    return planets
}

let vehicleDict: [[String: Any]] = [
    [
        "name": "Space pod",
        "total_no": 2,
        "max_distance": 200,
        "speed": 2
    ],
    [
        "name": "Space rocket",
        "total_no": 1,
        "max_distance": 300,
        "speed": 4
    ],
    [
        "name": "Space shuttle",
        "total_no": 1,
        "max_distance": 400,
        "speed": 5
    ],
    [
        "name": "Space ship",
        "total_no": 2,
        "max_distance": 600,
        "speed": 10
    ]
]


func getVehicleArray()->[Vehicle]{
    var vehicles: [Vehicle] = []
    for vehicleData in vehicleDict {
        if
            let name = vehicleData["name"] as? String,
            let totalNo = vehicleData["total_no"] as? Int,
            let maxDistance = vehicleData["max_distance"] as? Int,
            let speed = vehicleData["speed"] as? Int
        {
            
            let vehicle = Vehicle(name: name, totalNumber: totalNo, maxDist: maxDistance, speed: speed)
            vehicles.append(vehicle)
        }
    }
    return vehicles
}


