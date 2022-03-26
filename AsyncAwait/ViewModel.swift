//
//  ViewModel.swift
//  AsyncAwait
//
//  Created by tsubasa.kogoma on 2022/03/26.
//

import Foundation
import SwiftUI

protocol ViewModelProtocol: ObservableObject {
    var items: [Item] { get set }
    
    func fetchItemData(itemName: String)
}

class ViewModel: ViewModelProtocol {
    @Published var items = [Item]()
    
    private let baseUrl = "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch"
    private let appId = "?appid=dj00aiZpPTZQNjRpZllCUWFMdSZzPWNvbnN1bWVyc2VjcmV0Jng9NTE-"
    
    func fetchItemData(itemName: String) {
        let urlString = baseUrl + appId + "&" + "query=\(itemName)"
        
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                NSLog("error: \(error)")
            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
                NSLog("response is not 200")
            } else {
                guard let data = data else { NSLog("dataが存在しません"); return }
                guard let itemSearchResults = try? JSONDecoder.init().decode(ItemSearchResultSet.self, from: data) else { NSLog("データの形式が違います。")
                    return
                }
                print(itemSearchResults)
                DispatchQueue.main.async {
                    self.items = itemSearchResults.results
                    NSLog("items count is \(self.items.count)")
                }
            }
        }
        task.resume()
    }
    
//    func fetchImage(url urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//        let request = URLRequest(url: url)
//        URLSession.shared.dataTask(with: request){ data, response, error in
//            if let error = error {
//                NSLog("error: \(error)")
//            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
//                NSLog("response is not 200😱")
//            } else {
//                guard let data = data else { return }
//                let image = Image(
//            }
//        }
//    }
}
