//
//  TVMacConnectionApp.swift
//  TVMacConnection
//
//  Created by Lucas Oliveira on 05/05/23.
//

import SwiftUI

@main
struct TVMacConnectionApp: App {
    var body: some Scene {
        WindowGroup {
          #if os(tvOS)
            TVApp()
          #elseif os(iOS)
            iPhoneApp()
          #endif
        }
    }
}
