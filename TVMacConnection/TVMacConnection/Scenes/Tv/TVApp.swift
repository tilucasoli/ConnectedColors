//
//  TVApp.swift
//  TVMacConnection
//
//  Created by Lucas Oliveira on 05/05/23.
//

import SwiftUI
import Combine

struct TVApp: View {

  @StateObject var sessionController = TvSessionController()

  var body: some View {
    VStack (alignment: .leading) {
      Text(sessionController.connectedPeers.map(\.displayName).description)
        .fontDesign(.monospaced)
        .foregroundColor(.green)
      Text("Residentes")
        .font(.largeTitle)
        .fontWeight(.semibold)
      HStack(spacing: 8) {
        ForEach(sessionController.connectedUser.map(\.name), id: \.description) { message in
          Text(message)
            .foregroundColor(.black)
            .padding(8)
            .background {
              Color.white.opacity(0.9)
                .cornerRadius(8)
            }
        }
      }
    }
  }
}

struct TVApp_Previews: PreviewProvider {
  static var previews: some View {
    TVApp()
  }
}
