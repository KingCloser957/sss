//
//  PacketTunnelProvider.swift
//  PacketTunnelExtension
//
//  Created by huangrui on 2024/4/22.
//

import NetworkExtension
//import OpenVPNAdapter

//extension NEPacketTunnelFlow: OpenVPNAdapterPacketFlow {}

class PacketTunnelProvider: NEPacketTunnelProvider {
//    
//    let vpnReachability = OpenVPNReachability()
//    var startHandler: ((Error?) -> Void)?
//    var stopHandler: (() -> Void)?
//    
//    private lazy var vpnAdapter: OpenVPNAdapter = {
//        let adapter = OpenVPNAdapter()
//        adapter.delegate = self
//        return adapter
//    }()
    
    func LOGRedirect()  {
        let logFilePath  = "\(NSHomeDirectory())/Documents/xray.log"
        do {
            try FileManager.default.removeItem(at: URL(fileURLWithPath: logFilePath))
        } catch {
            debugPrint("删除xray日志失败:\(error)")
        }
        do {
            try FileManager.default.createFile(atPath: logFilePath, contents: nil)
        } catch {
            debugPrint("创建xray日志失败:\(error)")
        }
        freopen(logFilePath.cString(using: .ascii), "w+", stdout)
        freopen(logFilePath.cString(using: .ascii), "w+", stderr)
    }

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        // Add code here to start the process of connecting the tunnel.
        /*
        PacketTunnelProvider().LOGRedirect()
        var optionsConf:[String : Any]?
        if (options == nil) {
            let protocolConfig = self.protocolConfiguration as? NETunnelProviderProtocol
            let copyOptions = protocolConfig?.providerConfiguration as? [String:Any]
            optionsConf = copyOptions?["configuration"] as? [String : NSObject]
        }
        YDFutureManager.shared().setPacketTunnelProvider(self)
        YDFutureManager.shared().startTunnel(options: optionsConf, completionHandler: completionHandler) */
        
        /*
        guard
            let protocolConfiguration = protocolConfiguration as? NETunnelProviderProtocol,
            let providerConfiguration = protocolConfiguration.providerConfiguration
        else {
            fatalError()
        }

        guard let ovpnFileContent: Data = providerConfiguration["ovpn"] as? Data else {
            fatalError()
        }

        let configuration = OpenVPNConfiguration()
        configuration.fileContent = ovpnFileContent

        // Uncomment this line if you want to keep TUN interface active during pauses or reconnections
        // configuration.tunPersist = true

        do {
            try vpnAdapter.apply(configuration: configuration)
        } catch {
            completionHandler(error)
            return
        }

        // Checking reachability. In some cases after switching from cellular to
        // WiFi the adapter still uses cellular data. Changing reachability forces
        // reconnection so the adapter will use actual connection.
        vpnReachability.startTracking { [weak self] status in
            guard status == .reachableViaWiFi else { return }
             self?.vpnAdapter.reconnect(afterTimeInterval: 5)
        }

        // Establish connection and wait for .connected event
        startHandler = completionHandler
        vpnAdapter.connect(using: packetFlow)
         */
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code here to start the process of stopping the tunnel.
        /*
        completionHandler()
         */
        
//        stopHandler = completionHandler
//        if vpnReachability.isTracking {
//            vpnReachability.stopTracking()
//        }
//        vpnAdapter.disconnect()
    }
         
  
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        // Add code here to handle the message.
        
        YDFutureManager.setLogLevel(xLogLevelWarning)
        YDFutureManager.setGlobalProxyEnable(false)
        
        let app = try? JSONSerialization.jsonObject(with: messageData, options: []) as? [String:Any]
        let type = app?["type"] as? Int
        let version = YDFutureManager.version()
        if type == 0 {
            guard let configuration = app?["configuration"] as? String else { return }
            YDFutureManager.shared().setupURL(configuration)
        }
        let response = ["desc":200,"version":version,"tunnel_version":"1.0.7"] as [String : Any]
        let ack = try? JSONSerialization.data(withJSONObject: response, options: [])
        if let handler = completionHandler {
            handler(ack)
        }
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        // Add code here to get ready to sleep.
        completionHandler()
    }
    
    override func wake() {
        // Add code here to wake up.
    }
}

/*
extension PacketTunnelProvider: OpenVPNAdapterDelegate {

    // OpenVPNAdapter calls this delegate method to configure a VPN tunnel.
    // `completionHandler` callback requires an object conforming to `OpenVPNAdapterPacketFlow`
    // protocol if the tunnel is configured without errors. Otherwise send nil.
    // `OpenVPNAdapterPacketFlow` method signatures are similar to `NEPacketTunnelFlow` so
    // you can just extend that class to adopt `OpenVPNAdapterPacketFlow` protocol and
    // send `self.packetFlow` to `completionHandler` callback.
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, configureTunnelWithNetworkSettings networkSettings: NEPacketTunnelNetworkSettings?, completionHandler: @escaping (Error?) -> Void) {
        // In order to direct all DNS queries first to the VPN DNS servers before the primary DNS servers
        // send empty string to NEDNSSettings.matchDomains
        networkSettings?.dnsSettings?.matchDomains = [""]

        // Set the network settings for the current tunneling session.
        setTunnelNetworkSettings(networkSettings, completionHandler: completionHandler)
    }

    // Process events returned by the OpenVPN library
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleEvent event: OpenVPNAdapterEvent, message: String?) {
        switch event {
        case .connected:
            if reasserting {
                reasserting = false
            }

            guard let startHandler = startHandler else { return }

            startHandler(nil)
            self.startHandler = nil

        case .disconnected:
            guard let stopHandler = stopHandler else { return }

            if vpnReachability.isTracking {
                vpnReachability.stopTracking()
            }

            stopHandler()
            self.stopHandler = nil

        case .reconnecting:
            reasserting = true

        default:
            break
        }
    }

    // Handle errors thrown by the OpenVPN library
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleError error: Error) {
        // Handle only fatal errors
        guard let fatal = (error as NSError).userInfo[OpenVPNAdapterErrorFatalKey] as? Bool, fatal == true else {
            return
        }

        if vpnReachability.isTracking {
            vpnReachability.stopTracking()
        }

        if let startHandler = startHandler {
            startHandler(error)
            self.startHandler = nil
        } else {
            cancelTunnelWithError(error)
        }
    }

    // Use this method to process any log message returned by OpenVPN library.
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleLogMessage logMessage: String) {
        // Handle log messages
    }

}

*/
