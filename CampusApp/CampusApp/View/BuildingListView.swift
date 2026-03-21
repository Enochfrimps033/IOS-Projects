//
//  BuildingListView.swift
//  CampusApp
//
//  Created by Haley Parker on 3/19/26.
//

import SwiftUI

struct BuildingListView: View {
    @Bindable var viewModel: BuildingViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Filter", selection: $viewModel.filter) {
                    Text("All").tag(BuildingViewModel.FilterType.all)
                    Text("Selected").tag(BuildingViewModel.FilterType.selected)
                    Text("Favorites").tag(BuildingViewModel.FilterType.favorites)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List {
                    ForEach(viewModel.filteredBuildings, id: \.id) { building in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(building.name)
                                    .font(.headline)

                                Text(building.code)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Button {
                                viewModel.toggleSelected(for: building)
                            } label: {
                                Image(systemName: building.isSelected ? "checkmark.circle.fill" : "circle")
                            }
                            .buttonStyle(.plain)

                            Button {
                                viewModel.toggleFavorite(for: building)
                            } label: {
                                Image(systemName: building.isFavorite ? "star.fill" : "star")
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("Buildings")
            .searchable(text: $viewModel.searchText, prompt: "Search buildings")
        }
    }
}
