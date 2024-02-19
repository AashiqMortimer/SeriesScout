//
//  UtellyModel.swift
//  SeriesScout
//
//  Created by Aashiq Mortimer on 14/02/2024.
//

import Foundation

struct UtellyModel: Codable {
    let results: [Results]
    
    struct Results: Codable {
        let locations: [Locations]
        let picture: String?
        let name: String
        
        struct Locations: Codable {
            let platformDisplayName: String
            let icon: String
            
            enum CodingKeys: String, CodingKey {
                case platformDisplayName = "display_name"
                case icon
            }
        }
    }
}
