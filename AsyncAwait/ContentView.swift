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
                print("通信開始")
                viewModel.fetchItemData(itemName: "nike")
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
    var items: [Item]
    
    var body: some View {
        List() {
            ForEach(items) { item in
                ItemView(item: item)
            }
        }
    }
}


struct ItemView: View {
    var item: Item
    var small: URL
    var medium: URL
    
    init(item: Item) {
        self.item = item
        small = URL(string: item.image.small)!
        medium = URL(string: item.image.medium)!
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: small)
            AsyncImage(url: medium)
            VStack {
                Text(item.name)
                Text("\(item.price)")
            }
        }
    }
}
