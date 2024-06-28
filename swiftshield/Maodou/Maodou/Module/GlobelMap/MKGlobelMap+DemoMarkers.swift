//
//  MKGlobelMap+DemoMarkers.swift
//  MonkeyKing
//
//  Created by huangrui on 2024/5/23.
//

import Foundation

extension MKGlobelMap {
    
    public func addDemoMarkers(with nodes:[MKNodeTempeleModel]) {
        for node in nodes {
            let lat = node.x
            let lon = node.y
            let id = node.id
            let icon = node.icon
            let sf = MKGlowingMarker(lat:Float(lon) ,lon: Float(lat), altitude: kGlobeRadius, markerZindex: 0, style: .dot,icon: icon)
            sf.node.geometry!.firstMaterial!.diffuse.contents = icon
            sf.addPulseAnimation()
            sf.node.name = id
            self.addMarker(sf)
        }
        
        let sf = MKGlowingMarker(lat: 37.7749,lon: -122.4194, altitude: kGlobeRadius, markerZindex: 0, style: .ribbon)
        sf.addPulseAnimation()
        self.addMarker(sf)
        
//        self.nodeList.removeAll()
//        //------------------------------------------
//        // make some glowing nodes
//        // x: 0.0, y: 0.0, z: 5.05
//        let zz = MKGlowingMarker(lat: 0.0, lon: 0.0, altitude: kGlobeRadius, markerZindex: 0, style: .dot)
//        // make this one white!
//        zz.node.geometry!.firstMaterial!.diffuse.contents = "whiteGlow-32x32.png"
//        zz.node.name = "zz"
//        self.addMarker(zz)
//                
//        let sf = MKGlowingMarker(lat: 37.7749,lon: -122.4194, altitude: kGlobeRadius, markerZindex: 0, style: .dot)
//        sf.addPulseAnimation()
//        self.addMarker(sf)
//                
//        let madagascar = MKGlowingMarker(lat: -18.91368, lon: 47.53613, altitude: kGlobeRadius, markerZindex: 0, style: .dot)
//        self.addMarker(madagascar)
//                
//        let madrid = MKGlowingMarker(lat: 40.4168, lon: -3.7038, altitude: kGlobeRadius, markerZindex: 0, style: .dot)
//        self.addMarker(madrid)
//        
//        let beijing = MKGlowingMarker(lat: 39.90, lon: 116.40, altitude: kGlobeRadius, markerZindex: 0, style: .beam(UIColor.red))
//        beijing.node.geometry!.firstMaterial!.diffuse.contents = "whiteGlow-32x32.png"
//        beijing.node.name = "beijing"
//        self.addMarker(beijing)

        // a row of dots down the 'noon' meridian
//        for i in stride(from:-90.0, through: 90.0, by: 10.0) {
//            let spot = GlowingMarker(lat: i, lon: 0.0)
//            if i != 0 {
//                self.addMarker(spot)
//            }
//        }

    }
}

