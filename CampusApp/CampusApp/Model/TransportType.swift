//
//  TransportType.swift
//  CampusApp
//
//  Created by Haley Parker on 3/20/26.
//

import Foundation

import MapKit

enum TransportType: String, CaseIterable, Identifiable {
    case walking = "walking"
    case biking = "biking"
    case driving = "driving"
    case transit = "transit"
    
    var id: String { rawValue }
    
    var mapKitType: MKDirectionsTransportType{
        switch self {
        case .walking:
            return .walking
        case .biking:
            return .walking
        case .driving:
            return .automobile
        case .transit:
            return .transit
        }
    }
    
    var systemImage: String {
        switch self {
        case .walking:
            return "figure.walk"
        case .biking:
            return "bicycle"
        case .driving:
            return "car"
        case .transit:
            return "bus.fill"
        }
    }
}
