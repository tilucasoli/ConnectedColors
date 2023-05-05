//
//  TvSessionController.swift
//  TVMacConnection
//
//  Created by Lucas Oliveira on 05/05/23.
//

import Foundation
import MultipeerConnectivity
import os

class TvSessionController: NSObject, ObservableObject {
  private let serviceType = "example-color"

  private let session: MCSession
  private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
  private let serviceAdvertiser: MCNearbyServiceAdvertiser
  private let log = Logger()

  @Published var currentColor: NamedColor? = nil
  @Published var connectedPeers: [MCPeerID] = []

  override init() {
    precondition(Thread.isMainThread)
    self.session = MCSession(peer: myPeerId)
    self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)

    super.init()

    session.delegate = self
    serviceAdvertiser.delegate = self

    serviceAdvertiser.startAdvertisingPeer()
  }

  deinit {
    self.serviceAdvertiser.stopAdvertisingPeer()
  }
}

extension TvSessionController: MCNearbyServiceAdvertiserDelegate {
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    precondition(Thread.isMainThread)
    log.error("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
  }

  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    precondition(Thread.isMainThread)
    log.info("didReceiveInvitationFromPeer \(peerID)")
    invitationHandler(true, session)
  }
}

extension TvSessionController: MCSessionDelegate {
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    log.info("peer \(peerID) didChangeState: \(state.debugDescription)")
    print("DEBUG MODE: \(peerID)")
    DispatchQueue.main.async {
      self.connectedPeers = session.connectedPeers
    }
  }

  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    if let string = String(data: data, encoding: .utf8), let color = NamedColor(rawValue: string) {
      log.info("didReceive color \(string)")
      DispatchQueue.main.async {
        self.currentColor = color
      }
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
