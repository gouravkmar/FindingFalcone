//
//  APIManager.swift
//  FindingFalcone
//
//  Created by Gourav Kumar on 17/09/23.
//

import Foundation
import UIKit
class APIManager{
    static let baseURL = "https://findfalcone.geektrust.com"
    enum Endpoint: String {
        case planets  = "planets"
        case vehicles = "vehicles"
        case search = "find"
        case token = "token"
    }
    enum ApiMethods : String {
        case get = "GET"
        case post = "POST"
    }
    static func getAPIRequest(for item: Endpoint,data:[String:Any]?,apiMethod : ApiMethods)->URLRequest {
        let urlString = baseURL + "/" + item.rawValue
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = apiMethod.rawValue
        if apiMethod == .post {
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        if let data = data {
            do {
                let dict = try JSONSerialization.data(withJSONObject: data)
                request.httpBody = dict
            }catch let error{
                print(error)
            }
        }
        return request
    }
    
    static func makeAPICalls<T:Decodable>(for item: Endpoint,data:[String:Any]?,apiMethod : ApiMethods, forDataType type:T.Type,completion :@escaping (T)->Void ,onFailure: ((Error?)->Void)?=nil){
        let urlRequest = getAPIRequest(for: item,data: data, apiMethod: apiMethod)
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data,response,error in
            DispatchQueue.main.async {
                parseData(data: data, response: response, error: error, forDataType: type,completion :completion,onFailure: onFailure)
            }
            
        }).resume()
    }
    static func fetchData<T:Decodable>(for endpoint: Endpoint ,data:[String:Any]? = nil, completion forType :@escaping (T)->Void,onFailure: ((Error?)->Void)?=nil){
        switch endpoint{
        case .search:
            makeAPICalls(for: endpoint,data: data, apiMethod: .post, forDataType: T.self, completion: forType,onFailure: onFailure)
        case .token:
            makeAPICalls(for: endpoint,data: nil, apiMethod: .post, forDataType: T.self, completion: forType,onFailure: onFailure)
        default:
            makeAPICalls(for: endpoint,data: nil, apiMethod: .get, forDataType: T.self,completion: forType,onFailure: onFailure)
        }
       
    }
    static func parseData<T:Decodable>(data : Data? , response: URLResponse? , error: Error?,forDataType : T.Type,completion :@escaping (T)->Void,onFailure: ((Error?)->Void)?=nil){
        if error == nil ,let parsedata = data{
            if let decodedData = try? JSONDecoder().decode(T.self, from: parsedata){
                completion(decodedData)
                print(decodedData)
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: parsedata)
                    print(decodedData)
            }catch let error{
                print(error)
                if let fblock = onFailure {
                    (fblock)(error)
                }
            }
            let data  = try? JSONSerialization.jsonObject(with: parsedata)
            print(data)
            
        }
    
        
    }
}


