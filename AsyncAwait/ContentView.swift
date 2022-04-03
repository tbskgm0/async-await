//
//  ContentView.swift
//  AsyncAwait
//
//  Created by tsubasa.kogoma on 2022/03/19.
//

import SwiftUI

struct ContentView<ViewModel: ViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Button("通信開始", action: {
                Task {
                    try await viewModel.fetchItemData(itemName: "nike")
                }
            })
            ItemsView(items: viewModel.items)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}


struct ItemsView: View {
    var items: [ItemsResult]
    
    var body: some View {
        List() {
            ForEach(items) { item in
                ItemView(item: item)
            }
        }
    }
}


struct ItemView: View {
    var item: ItemsResult
    
    init(item: ItemsResult) {
        self.item = item
    }
    
    var body: some View {
        HStack {
            Image(uiImage: item.image.smallImage)
            Image(uiImage: item.image.mediumImage)
            VStack {
                Text(item.name)
                Text("\(item.price)")
            }
        }
    }
}
