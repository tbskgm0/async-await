//
//  Structs.swift
//  AsyncAwait
//
//  Created by tsubasa.kogoma on 2022/03/26.
//

import Foundation


struct ItemSearchResultSet: Codable {
    var results: [Item]
    
    private enum CodingKeys: String, CodingKey {
        case results = "hits"
    }
}

struct Item: Codable, Identifiable {
    let id = UUID()
    var index: Int
    var name: String
    var image: ItemImage
    var price: Int
    
    private enum CodingKeys: String, CodingKey {
        case index
        case name
        case image
        case price
    }
}

struct ItemImage: Codable {
    var small: String
    var medium: String
}
