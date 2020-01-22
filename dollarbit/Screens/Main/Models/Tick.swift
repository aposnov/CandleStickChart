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
        case stockName = "s"
        case bidPrice = "b"
        case askPrice = "a"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stockName = try values.decodeIfPresent(String.self, forKey: .stockName)
        bidPrice = try values.decodeIfPresent(String.self, forKey: .bidPrice)
        askPrice = try values.decodeIfPresent(String.self, forKey: .askPrice)
    }
}
