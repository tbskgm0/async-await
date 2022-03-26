//
//  AsyncAwaitApp.swift
//  AsyncAwait
//
//  Created by tsubasa.kogoma on 2022/03/19.
//

import SwiftUI

@main
struct AsyncAwaitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
        }
    }
}
