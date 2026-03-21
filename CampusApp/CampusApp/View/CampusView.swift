//
//  CampusView.swift
//  CampusApp
//
//  Created by Haley Parker on 3/19/26.
//

import SwiftUI
import MapKit

enum MapType {
    case standard
    case hybrid
}

struct CampusView: View {
    @Bindable var viewModel: BuildingViewModel
    @Environment(LocationManager.self) var LM: LocationManager
    @Binding var selectedTab: Int

    @State private var cameraPos: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.7982, longitude: -77.8599),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    )

    @State private var mapType: MapType = .standard

    var body: some View {
        ZStack {
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
                        .stroke(
                            index == viewModel.selectedRouteIndex ? .blue : .gray.opacity(0.5),
                            lineWidth: index == viewModel.selectedRouteIndex ? 6 : 4
                        )
                }

                if let step = viewModel.currentStep {
                    MapPolyline(step.polyline)
                        .stroke(.orange, lineWidth: 8)
                }
            }
            .mapStyle(mapType == .standard ? .standard : .hybrid)
            .onAppear {
                LM.requestLocation()
            }
            .sheet(item: $viewModel.selectedBuilding) { building in
                BuildingDetailView(building: building, viewModel: viewModel)
            }

            VStack {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.and.ellipse")
                        Text("Penn State")
                            .font(.headline)
                    }
                    .foregroundStyle(.white)

                    Spacer()

                    HStack(spacing: 0) {
                        Button {
                            mapType = .standard
                        } label: {
                            Image(systemName: "map")
                                .frame(width: 44, height: 36)
                                .foregroundStyle(mapType == .standard ? .blue : .black)
                                .background(mapType == .standard ? .white : .clear)
                        }

                        Button {
                            mapType = .hybrid
                        } label: {
                            Image(systemName: "location")
                                .frame(width: 44, height: 36)
                                .foregroundStyle(mapType == .hybrid ? .blue : .black)
                                .background(mapType == .hybrid ? .white : .clear)
                        }

                        Button {
                            selectedTab = 0
                        } label: {
                            Image(systemName: "building.2")
                                .frame(width: 44, height: 36)
                                .foregroundStyle(.black)
                        }
                    }
                    .background(.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.95), Color.blue.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

                Spacer()
            }

            VStack {
                Spacer()

                if viewModel.showDirectionsPanel {
                    DirectionsPopUpView(viewModel: viewModel)
                }
            }

            VStack {
                Spacer()

                HStack {
                    Spacer()

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
                            .font(.title3)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding(.trailing)
                    .padding(.bottom, viewModel.showDirectionsPanel ? 210 : 24)
                }
            }
        }
    }
}

