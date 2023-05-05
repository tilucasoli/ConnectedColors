//
//  TVApp.swift
//  TVMacConnection
//
//  Created by Lucas Oliveira on 05/05/23.
//

import SwiftUI
import Combine

struct TVApp: View {
  @ObservedObject var sessionController = TvSessionController()

  var body: some View {
    ZStack {
      sessionController.currentColor?.color ?? .gray
      Text(sessionController.connectedPeers.map(\.displayName).description)
        .font(.title)
        .fontWeight(.semibold)
    }
    .ignoresSafeArea()
  }
}

struct TVApp_Previews: PreviewProvider {
  static var previews: some View {
    TVApp()
  }
}
