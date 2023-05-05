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
  @State var name: String = ""

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Spacer()
      TextField(text: $name) {
        Text("")
          .foregroundColor(.black)
      }
      .padding(16)
      .background {
        RoundedRectangle(cornerRadius: 10)
          .foregroundColor(.gray.opacity(0.2))
      }
      HStack {
        Spacer()
        Text(UIDevice.current.identifierForVendor?.description ?? "")
          .foregroundColor(.gray)
          .fontWeight(.bold)
        Spacer()
      }
      .padding(16)
      .background {
        RoundedRectangle(cornerRadius: 10)
          .foregroundColor(.gray.opacity(0.2))
      }
      Spacer()
      CustomButton(title: "Send", color: .blue) {
        sessionController.send(text: name)
      }
    }
    .padding(16)
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
    .frame(maxWidth: .infinity, maxHeight: 50)
    .background {
      Color.blue
        .cornerRadius(10)
    }
//    .buttonStyle(.borderedProminent)
//    .tint(color)
  }
}
#endif
