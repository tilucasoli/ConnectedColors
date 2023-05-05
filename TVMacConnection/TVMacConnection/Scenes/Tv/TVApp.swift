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
    VStack (alignment: .leading) {
      Text("Residentes")
        .font(.largeTitle)
        .fontWeight(.semibold)
      Text(sessionController.connectedUser.map(\.name).description)
    }
  }
}

struct TVApp_Previews: PreviewProvider {
  static var previews: some View {
    TVApp()
  }
}
