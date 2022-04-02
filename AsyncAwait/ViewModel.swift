//
//  ViewModel.swift
//  AsyncAwait
//
//  Created by tsubasa.kogoma on 2022/03/26.
//

import Foundation

protocol ViewModelProtocol: ObservableObject {
    var items: [Item] { get set }
    
    func fetchItemData(itemName: String) async throws
}

class ViewModel: ViewModelProtocol {
    @Published var items = [Item]()
    
    private let baseUrl = "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch"
    private let appId = "?appid=dj00aiZpPTZQNjRpZllCUWFMdSZzPWNvbnN1bWVyc2VjcmV0Jng9NTE-"
    
    func fetchItemData(itemName: String) async throws {
        let url = URL(string: baseUrl + appId + "&" + "query=\(itemName)")!
        let request = URLRequest(url: url)
        NSLog("通信開始")
        let (data, response) = try await URLSession.shared.data(for: request)
        NSLog("通信終了")
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return NSLog("response's status code is \(response.debugDescription).") }
        guard let itemSearchResults = try? JSONDecoder.init().decode(ItemSearchResultSet.self, from: data) else { return NSLog("データの形式が違います。") }
        DispatchQueue.main.async {
            self.items = itemSearchResults.results
        }
    }
}
    
