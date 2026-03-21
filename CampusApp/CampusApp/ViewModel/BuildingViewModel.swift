//
//  BuildingViewModel.swift
//  CampusApp
//
//  Created by Haley Parker on 3/18/26.
//

import Foundation
import Observation
import MapKit

@Observable
class BuildingViewModel {
    enum FilterType: Hashable {
        case all
        case selected
        case favorites
    }

    var buildings: [Building] = []
    var searchText = ""
    var filter: FilterType = .all

    var selectedBuilding: Building?

    var routes: [MKRoute] = []
    var selectedRouteIndex: Int = 0
    var routeSteps: [MKRoute.Step] = []
    var selectedStepIndex: Int = 0
    var showDirectionsPanel: Bool = false

    init() {
        loadSaveBuildings()
    }

    var currentRoute: MKRoute? {
        guard routes.indices.contains(selectedRouteIndex) else { return nil }
        return routes[selectedRouteIndex]
    }

    var currentStep: MKRoute.Step? {
        guard routeSteps.indices.contains(selectedStepIndex) else { return nil }
        return routeSteps[selectedStepIndex]
    }

    var filteredBuildings: [Building] {
        var result = buildings

        switch filter {
        case .all:
            break
        case .selected:
            result = result.filter { $0.isSelected }
        case .favorites:
            result = result.filter { $0.isFavorite }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.code.localizedCaseInsensitiveContains(searchText)
            }
        }

        return result
    }

    func loadFromJson() {
        let filename = "buildings"

        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Failed to locate \(filename).json in bundle.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            buildings = try decoder.decode([Building].self, from: data)
            buildings.sort { $0.name < $1.name }
            print("Loaded \(buildings.count) buildings")
        } catch {
            print("Failed to decode/load \(filename).json: \(error)")
        }
    }

    func loadSaveBuildings() {
        if let data = UserDefaults.standard.data(forKey: "buildings"),
           let decoded = try? JSONDecoder().decode([Building].self, from: data) {
            buildings = decoded
        } else {
            loadFromJson()
        }
    }

    func toggleSelected(for building: Building) {
        guard let index = buildings.firstIndex(of: building) else { return }
        buildings[index].isSelected.toggle()
        saveBuildings()
    }

    func toggleFavorite(for building: Building) {
        guard let index = buildings.firstIndex(of: building) else { return }
        buildings[index].isFavorite.toggle()
        saveBuildings()
    }

    func saveBuildings() {
        if let encoded = try? JSONEncoder().encode(buildings) {
            UserDefaults.standard.set(encoded, forKey: "buildings")
        }
    }

    func startDirection(for building: Building, transport: TransportType, userLoc: CLLocationCoordinate2D) {
        let end = building.coordinate

        let startPlacemark = MKPlacemark(coordinate: userLoc)
        let endPlacemark = MKPlacemark(coordinate: end)

        let startMapItem = MKMapItem(placemark: startPlacemark)
        let endMapItem = MKMapItem(placemark: endPlacemark)

        let request = MKDirections.Request()
        request.source = startMapItem
        request.destination = endMapItem

        switch transport {
        case .walking:
            request.transportType = .walking
        case .driving:
            request.transportType = .automobile
        case .transit:
            request.transportType = .transit
        case .biking:
            request.transportType = .walking
        }

        let directions = MKDirections(request: request)

        directions.calculate { response, error in
            if let error {
                print("error getting directions \(error)")
                return
            }

            guard let routes = response?.routes, !routes.isEmpty else {
                print("no route found")
                return
            }

            DispatchQueue.main.async {
                self.routes = routes
                self.selectedRouteIndex = 0
                self.routeSteps = routes[0].steps.filter { !$0.instructions.isEmpty }
                self.selectedStepIndex = 0
                self.selectedBuilding = nil
                self.showDirectionsPanel = true
            }
        }
    }

    func selectRoute(at index: Int) {
        guard routes.indices.contains(index) else { return }
        selectedRouteIndex = index
        routeSteps = routes[index].steps.filter { !$0.instructions.isEmpty }
        selectedStepIndex = 0
    }

    func clearDirections() {
        routes = []
        routeSteps = []
        selectedRouteIndex = 0
        selectedStepIndex = 0
        showDirectionsPanel = false
    }

    func formattedTravelTime(for route: MKRoute) -> String {
        let totalSeconds = Int(route.expectedTravelTime)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return "\(minutes)m \(seconds)s"
    }

    func formattedETA(for route: MKRoute) -> String {
        let arrival = Date().addingTimeInterval(route.expectedTravelTime)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: arrival)
    }

    func regionForCurrentRoute() -> MKCoordinateRegion? {
        guard let route = currentRoute else { return nil }

        let rect = route.polyline.boundingMapRect
        let region = MKCoordinateRegion(rect)

        return MKCoordinateRegion(
            center: region.center,
            span: MKCoordinateSpan(
                latitudeDelta: region.span.latitudeDelta * 1.4,
                longitudeDelta: region.span.longitudeDelta * 1.4
            )
        )
    }
}
