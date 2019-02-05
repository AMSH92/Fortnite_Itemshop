//
//  PlanetEndPoint.swift
//  Endpoint
//
//  Created by adam smith on 5/11/17.
//  Copyright © 2017 adamontherun. All rights reserved.
//

import Foundation
import Alamofire

/// Models the Planets endpoint from the StarWars API.
enum FortniteEndPoint: AlamofireEndPoint {
    
    case searchPlanets(forTerm: String, page: Int)
    case dailyItem()
    case weeklyChallanges()
    
    // MARK: - AlamofireEndPoint conforming methods
    
    func provideValues()->(url: String, httpMethod: HTTPMethod, parameters:[String:Any]?,encoding: ParameterEncoding) {
       
        switch self {
            
        case .dailyItem():
            return (url: dailyStoreURL, httpMethod: .get, parameters: nil, encoding: URLEncoding.default)
        case let .searchPlanets(forTerm: searchTerm, page: page):
            let params = parameters(for: page, searchTerm: searchTerm)
            return (url: "\(baseURL)/planets", httpMethod: .get, parameters: params, encoding: URLEncoding.default)
        case .weeklyChallanges():
            return (url: challangesURL , httpMethod: .get, parameters: nil, encoding: URLEncoding.default)
        }
    }
    
    // MARK: - Private methods
    
    private func parameters(for page: Int)->[String : String] {
        return [
            "page" : String(page)
        ]
    }
    
    private func parameters(for page: Int, searchTerm: String)->[String : String] {
        return [
            "search" : searchTerm,
            "page"   : String(page)
        ]
    }
}
