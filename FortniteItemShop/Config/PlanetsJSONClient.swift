//
//  PlanetsJSONClient.swift
//  Endpoint
//
//  Created by adam smith on 5/11/17.
//  Copyright © 2017 adamontherun. All rights reserved.
//

import Foundation

enum FortniteJSONClient: StarwarsJSONClient {
    
    // MARK: - Public methods
    
    static func fetchDailyItemshop(_ completionHandler: @escaping ItemshopJSONCompletionHandler) {
        AlamoFireJSONClient.makeAPICall(to: FortniteEndPoint.dailyItem()) { (result) in
            self.handle(result: result, completionHandler: completionHandler)
        }
    }
    
    static func fetchWeeklyChallanges(_ completionHandler: @escaping ItemshopJSONCompletionHandler) {
        AlamoFireJSONClient.makeAPICall(to: FortniteEndPoint.weeklyChallanges()) { (result) in
            self.handle(result: result, completionHandler: completionHandler)
        }
    }
    
    static func searchPlanets(for term: String, page: Int = 1, _ completionHandler: @escaping ItemshopJSONCompletionHandler) {
        AlamoFireJSONClient.makeAPICall(to: FortniteEndPoint.searchPlanets(forTerm: term, page: page)) { (result) in
            self.handle(result: result, completionHandler: completionHandler)
        }
    }
}
