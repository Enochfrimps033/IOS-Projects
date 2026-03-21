//
//  BuildingDetailView.swift
//  CampusApp
//
//  Created by Haley Parker on 3/19/26.
//

import SwiftUI

struct BuildingDetailView: View {
    let building: Building

    @Bindable var viewModel: BuildingViewModel
    @Environment(LocationManager.self) var LM: LocationManager

    @State private var selectedTransportation: TransportType = .walking

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                HStack {
                    Spacer()

                    Button {
                        viewModel.toggleFavorite(for: building)
                    } label: {
                        Image(systemName: building.isFavorite ? "star.fill" : "star")
                            .font(.title3)
                            .foregroundStyle(building.isFavorite ? .yellow : .gray)
                            .padding(10)
                            .background(.white)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                }

                Text(building.name)
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)

                Group {
                    if let buildingPic = building.photo {
                        Image(buildingPic)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    } else {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(.systemGray6))
                            .frame(height: 200)
                            .overlay {
                                VStack(spacing: 8) {
                                    Image(systemName: "building.2")
                                        .font(.system(size: 36))
                                        .foregroundStyle(.blue)
                                    Text("No Image Available")
                                        .foregroundStyle(.secondary)
                                }
                            }
                    }
                }

                VStack(spacing: 12) {
                    detailCard(
                        icon: "building.columns",
                        title: "Building Code",
                        value: building.code
                    )

                    if let year = building.yearConstructed {
                        detailCard(
                            icon: "calendar",
                            title: "Year Constructed",
                            value: "\(year)"
                        )
                    } else {
                        detailCard(
                            icon: "calendar",
                            title: "Year Constructed",
                            value: "Not Available"
                        )
                    }

                    detailCard(
                        icon: "location.north.line",
                        title: "Coordinates",
                        value: String(format: "%.4f, %.4f", building.latitude, building.longitude)
                    )
                }

                VStack(alignment: .leading, spacing: 10) {
                    Label("Choose Transportation", systemImage: "point.topleft.down.curvedto.point.bottomright.up")
                        .font(.headline)

                    HStack(spacing: 10) {
                        transportButton(.walking, icon: "figure.walk")
                        transportButton(.driving, icon: "car")
                        transportButton(.biking, icon: "bicycle")
                        transportButton(.transit, icon: "tram")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 18))

                Button {
                    if let userLoc = LM.userLoc {
                        viewModel.startDirection(
                            for: building,
                            transport: selectedTransportation,
                            userLoc: userLoc
                        )
                    } else {
                        print("user location not ready yet")
                    }
                } label: {
                    HStack {
                        Image(systemName: "location.fill")
                        Text("Get Directions")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    @ViewBuilder
    private func detailCard(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.blue)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.body.weight(.semibold))
            }

            Spacer()
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
    }

    @ViewBuilder
    private func transportButton(_ type: TransportType, icon: String) -> some View {
        Button {
            selectedTransportation = type
        } label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title3)
                Text(type.rawValue.capitalized)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(selectedTransportation == type ? Color.blue : Color.white)
            .foregroundStyle(selectedTransportation == type ? .white : .primary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
