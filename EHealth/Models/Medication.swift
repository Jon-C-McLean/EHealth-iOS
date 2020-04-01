//
//  Medication.swift
//  EHealth
//
//  Created by Jon McLean on 2/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

struct Medication: Decodable {
    var id: Int
    var name: String
    var consumption: ConsumptionMethod
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case consumption
    }
}

enum ConsumptionMethod: String {
    case oral = "oral"
    case spray = "spray"
    case iv = "iv"
    case im = "im"
    
    func displayName() -> String {
        switch(self) {
        case .oral:
            return "Oral"
        case .spray:
            return "Spray"
        case .iv:
            return "Intravenous"
        case .im:
            return "Intramuscular"
        }
    }
    
    func description() -> String {
        switch(self) {
        case .oral:
            return "orally"
        case .spray:
            return "sprayed"
        case .iv:
            return "intravenously"
        case .im:
            return "intramuscular injection"
        }
    }
}

extension Medication {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        consumption = ConsumptionMethod(rawValue: try values.decode(String.self, forKey: .consumption)) ?? .oral
    }
}
