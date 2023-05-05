//
//  iPhoneSessionController.swift
//  TVMacConnection
//
//  Created by Lucas Oliveira on 05/05/23.
//

import Foundation
import MultipeerConnectivity
import os
import SwiftUI

enum NamedColor: String, CaseIterable {
  case red, green, blue

  var color: Color {
    get {
      switch self {
      case .red:
        return Color.red
      case .blue:
        return Color.blue
      case .green:
        return Color.green

      }
    }
  }

}

struct User: Codable {
  var name: String
  var serialNumber: String
}

class iPhoneSessionController: NSObject, ObservableObject {
  private let serviceType = "example-color"

  private let session: MCSession
  private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
  private let serviceBrowser: MCNearbyServiceBrowser
  private let log = Logger()

//  @Published var currentUser = User(name: "", serialNumber: UIDevice.current.identifierForVendor?.description ?? "")
  @Published var name: String = ""
  @Published var isConnected: Bool = false

  override init() {
    precondition(Thread.isMainThread)
    self.session = MCSession(peer: myPeerId)
    self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)

    super.init()

    session.delegate = self
    serviceBrowser.delegate = self

    serviceBrowser.startBrowsingForPeers()
  }

  deinit {
    self.serviceBrowser.stopBrowsingForPeers()
    self.session.disconnect()
  }

  func send(text: String) {
    precondition(Thread.isMainThread)
//    log.info("sendColor: \(String(describing: color)) to \(self.session.connectedPeers.count) peers")

    if !session.connectedPeers.isEmpty {
      do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(User(name: text, serialNumber: UIDevice.current.identifierForVendor?.description ?? ""))

        try session.send(jsonData, toPeers: session.connectedPeers, with: .reliable)
      } catch {
        log.error("Error for sending: \(String(describing: error))")
      }
    }
  }
}

extension iPhoneSessionController: MCNearbyServiceBrowserDelegate {
  func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
    log.error("ServiceBrowser didNotStartBrowsingForPeers: \(String(describing: error))")
  }

  func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
    log.info("ServiceBrowser found peer: \(peerID)")
    browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
  }

  func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    log.info("ServiceBrowser lost peer: \(peerID)")
  }
}

extension iPhoneSessionController: MCSessionDelegate {
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    log.info("peer \(peerID) didChangeState: \(state.debugDescription)")
  }

  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    if let string = String(data: data, encoding: .utf8) {
      log.info("didReceive color \(string)")
    } else {
      log.info("didReceive invalid value \(data.count) bytes")
    }
  }

  public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    log.error("Receiving streams is not supported")
  }

  public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    log.error("Receiving resources is not supported")
  }

  public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    log.error("Receiving resources is not supported")
  }
}

extension MCSessionState: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case .notConnected:
      return "notConnected"
    case .connecting:
      return "connecting"
    case .connected:
      return "connected"
    @unknown default:
      return "\(rawValue)"
    }
  }
}
