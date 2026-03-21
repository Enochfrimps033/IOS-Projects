//
//  DirectionsPopUp.swift
//  CampusApp
//
//  Created by Haley Parker on 3/20/26.
//

import SwiftUI
import MapKit

struct DirectionsPopUpView: View {
    @Bindable var viewModel: BuildingViewModel

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Trip Directions")
                    .font(.headline)

                Spacer()

                Button("Close") {
                    viewModel.clearDirections()
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(viewModel.routes.enumerated()), id: \.offset) { index, route in
                        Button {
                            viewModel.selectRoute(at: index)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Route \(index + 1)")
                                    .font(.subheadline)
                                    .bold()

                                Text(viewModel.formattedTravelTime(for: route))
                                    .font(.caption)

                                Text("ETA \(viewModel.formattedETA(for: route))")
                                    .font(.caption2)

                                Text("\(Int(route.distance)) m")
                                    .font(.caption2)
                            }
                            .padding()
                            .frame(width: 130, alignment: .leading)
                            .background(index == viewModel.selectedRouteIndex ? .blue.opacity(0.15) : .gray.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            if !viewModel.routeSteps.isEmpty {
                TabView(selection: $viewModel.selectedStepIndex) {
                    ForEach(Array(viewModel.routeSteps.enumerated()), id: \.offset) { index, step in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(step.instructions.isEmpty ? "Continue" : step.instructions)
                                .font(.headline)

                            Text("\(Int(step.distance)) m")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .tag(index)
                    }
                }
                .frame(height: 110)
                .tabViewStyle(.page(indexDisplayMode: .automatic))
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding()
    }
}
