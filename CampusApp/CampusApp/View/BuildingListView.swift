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
                    Text("Favorited").tag(BuildingViewModel.FilterType.favorites)
                }
                .pickerStyle(.segmented)
                .padding()

                List {
                    ForEach(viewModel.filteredBuildings) { building in
                        HStack {

                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(building.isFavorite ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.2))
                                    .frame(width: 40, height: 40)

                                Image(systemName: "building.2")
                            }

                            Text(building.name)
                                .font(.headline)

                            Spacer()

                            Button {
                                viewModel.toggleFavorite(for: building)
                            } label: {
                                Image(systemName: building.isFavorite ? "star.fill" : "star")
                                    .foregroundStyle(building.isFavorite ? .yellow : .gray)
                            }

                            Button {
                                viewModel.toggleSelected(for: building)
                            } label: {
                                Image(systemName: building.isSelected ? "map.fill" : "map")
                                    .foregroundStyle(building.isSelected ? .blue : .gray)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
                .listStyle(.plain)

                TextField("Search buildings", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
            .navigationTitle("Buildings")
        }
    }
}
