//
//  Tick.swift
//  dollarbit
//
//  Created by Andrey Posnov on 22.01.2020.
//  Copyright © 2020 Andrey Posnov. All rights reserved.
//

import Foundation

struct responseModelChart: Decodable {
    let ticks: [Tick]?
}

struct Tick: Decodable {
    let stockName: String?
    let bidPrice: String?
    let askPrice: String?

    enum CodingKeys: String, CodingKey {
        case s = "stockName"
        case b = "bidPrice"
        case a = "askPrice"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stockName = try values.decodeIfPresent(String.self, forKey: .s)
        bidPrice = try values.decodeIfPresent(String.self, forKey: .b)
        askPrice = try values.decodeIfPresent(String.self, forKey: .a)
    }
}
