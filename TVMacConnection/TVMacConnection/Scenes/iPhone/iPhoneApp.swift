//
//  iPhoneApp.swift
//  TVMacConnection
//
//  Created by Lucas Oliveira on 05/05/23.
//

import SwiftUI
#if os(iOS)
struct iPhoneApp: View {
  @ObservedObject var sessionController = iPhoneSessionController()

  var body: some View {
    VStack(spacing: 16) {
      CustomButton(title: "Red",
                   color: .red) {
        sessionController.send(color: .red)
      }
      CustomButton(title: "Green",
                   color: .green) {
        sessionController.send(color: .green)
      }
      CustomButton(title: "Blue",
                   color: .blue) {
        sessionController.send(color: .blue)
      }
    }
    .padding()
  }
}

struct iPhoneApp_Previews: PreviewProvider {
  static var previews: some View {
    iPhoneApp()
  }
}

struct CustomButton: View {
  let title: String
  let color: Color
  let action: () -> Void

  var body: some View {
    Button(action: action, label: {
      Text(title)
        .font(.headline)
        .fontWeight(.bold)
        .foregroundColor(.white)
    })
    .controlSize(.large)
    .buttonStyle(.borderedProminent)
    .tint(color)
  }
}
#endif
