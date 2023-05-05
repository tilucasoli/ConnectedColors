import SwiftUI

struct ColorSwitchView: View {
  @StateObject var colorSession = ColorMultipeerSession()

  var body: some View {
    VStack(alignment: .leading) {
      Text("Connected Devices:")
        .bold()
      Text(String(describing: colorSession.connectedPeers.map(\.displayName)))
      Divider()
      HStack {
        ForEach(NamedColor.allCases, id: \.self) { color in
          Button(color.rawValue) {
            colorSession.send(color: color)
          }
          .padding()
        }
      }
      Spacer()
    }
    .padding()
    .background((colorSession.currentColor.map(\.color) ?? .clear).ignoresSafeArea())
  }
}

extension NamedColor {
  var color: Color {
    switch self {
    case .red:
      return .red
    case .green:
      return .green
    case .yellow:
      return .yellow
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ColorSwitchView()
  }
}
