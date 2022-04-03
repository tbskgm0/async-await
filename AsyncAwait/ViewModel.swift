//
//  ViewModel.swift
//  AsyncAwait
//
//  Created by tsubasa.kogoma on 2022/03/26.
//

import Foundation
import UIKit

protocol ViewModelProtocol: ObservableObject {
    var items: [ItemsResult] { get set }
    
    func fetchItemData(itemName: String) async throws
}

class ViewModel: ViewModelProtocol {
    @Published var items = [ItemsResult]()
    
    private let baseUrl = "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch"
    private let appId = "?appid=dj00aiZpPTZQNjRpZllCUWFMdSZzPWNvbnN1bWVyc2VjcmV0Jng9NTE-"
    
    func fetchItemData(itemName: String) async throws {
        items = []
        
        // 通信結果を受け取るまでの処理
        let url = URL(string: baseUrl + appId + "&" + "query=\(itemName)")!
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 値の加工
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return NSLog("response's status code is \(response.debugDescription).") }
        guard let itemSearchResults = try? JSONDecoder.init().decode(ItemSearchResultSet.self, from: data) else { return NSLog("データの形式が違います。") }
        
        for itemResult in itemSearchResults.results {
            let smallUrl: URL = URL(string: itemResult.image.small)!
            let mediumUrl: URL = URL(string: itemResult.image.medium)!
            let images = try await featchImages(smallUrl: smallUrl, mediumUrl: mediumUrl)
            let aaaa: ItemImages = ItemImages(smallImage: images.small, mediumImage: images.medium)
            
            let item = ItemsResult(name: itemResult.name, image: aaaa, price: itemResult.price)
            items.append(item)
        }
    }
    
    func featchImages(smallUrl: URL, mediumUrl: URL) async throws -> (small: UIImage, medium: UIImage) {
        async let smallData = try await URLSession.shared.data(from: smallUrl)
        async let mediumData = try await URLSession.shared.data(from: mediumUrl)
        
        let smallImage: UIImage = try await UIImage(data: smallData.0)!
        let mediumImage: UIImage = try await UIImage(data: mediumData.0)!
        
        let icon = (small: smallImage, medium: mediumImage)
        return icon
    }
}
    
