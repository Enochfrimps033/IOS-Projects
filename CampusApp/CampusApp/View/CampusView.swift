//
//  CampusView.swift
//  CampusApp
//
//  Created by Haley Parker on 3/19/26.
//

import SwiftUI
import MapKit

struct CampusView: View {
    @Bindable var viewModel: BuildingViewModel
    @Environment(LocationManager.self) var LM: LocationManager

    @State private var cameraPos: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.7982, longitude: -77.8599),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    )

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack(alignment: .bottom) {
                Map(position: $cameraPos) {
                    UserAnnotation()

                    ForEach(viewModel.buildings.filter { $0.isSelected }, id: \.id) { building in
                        Annotation("", coordinate: building.coordinate) {
                            VStack(spacing: 5) {
                                Image(systemName: building.isFavorite ? "star.circle.fill" : "mappin.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(building.isFavorite ? .yellow : .red)

                                Text(building.name)
                                    .font(.caption2)
                                    .padding(5)
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                            .onTapGesture {
                                viewModel.selectedBuilding = building
                            }
                        }
                    }

                    ForEach(Array(viewModel.routes.enumerated()), id: \.offset) { index, route in
                        MapPolyline(route.polyline)
                            .stroke(index == viewModel.selectedRouteIndex ? .blue : .gray.opacity(0.5),
                                    lineWidth: index == viewModel.selectedRouteIndex ? 6 : 4)
                    }

                    if let step = viewModel.currentStep {
                        MapPolyline(step.polyline)
                            .stroke(.orange, lineWidth: 8)
                    }
                }
                .onAppear {
                    LM.requestLocation()
                }
                .onChange(of: viewModel.selectedRouteIndex) { _, _ in
                    if let region = viewModel.regionForCurrentRoute() {
                        cameraPos = .region(region)
                    }
                }
                .onChange(of: viewModel.routes.count) { _, newCount in
                    if newCount > 0, let region = viewModel.regionForCurrentRoute() {
                        cameraPos = .region(region)
                    }
                }
                .sheet(item: $viewModel.selectedBuilding) { building in
                    BuildingDetailView(building: building, viewModel: viewModel)
                }

                if viewModel.showDirectionsPanel {
                    DirectionsPopUpView(viewModel: viewModel)
                }
            }

            Button {
                if let userLoc = LM.userLoc {
                    cameraPos = .region(
                        MKCoordinateRegion(
                            center: userLoc,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                    )
                }
            } label: {
                Image(systemName: "location.fill")
                    .font(.title2)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .padding()
        }
    }
}
