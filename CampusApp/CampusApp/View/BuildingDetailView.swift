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
    
    @State private var selectedTransportation: TransportType = .driving
    
    var body: some View{
        
        VStack(spacing: 20){
            Picker("Transportation", selection: $selectedTransportation) {
                ForEach(TransportType.allCases) { type in
                    Text(type.rawValue).tag(type)
                    }
                        
            }
            
            .pickerStyle(.segmented)

            Text(building.name)
                .font(.title)
                .bold()
            
            if let buildingPic = building.photo{
                Image(buildingPic)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.5))
                        .frame(height: 180)
                        .overlay(
                            Text( "Image Not Available")
                                .foregroundStyle(.secondary)
                        )
                        .onAppear{
                            print("Building name is: \(self.building.name)")
                            print("Building value: \(String(describing: building.photo))")
                        }
                
            }
            
                
            
            VStack(alignment: .leading , spacing: 12 ){
                Text("Code: \(building.code)")
                Text("Coordinates: \(building.latitude), \(building.longitude)")
                
                if let year = building.yearConstructed{
                    Text("Year Constructed: \(year)")
                }else{
                    Text("Construction date not available for this building")
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button("Get Directions") {
                if let userLoc = LM.userLoc {
                    viewModel.startDirection(
                        for: building,
                        transport: selectedTransportation,
                        userLoc: userLoc
                    )
                } else {
                    print("user location not ready yet")
                }            }
            
            Button {
                viewModel.toggleFavorite(for: building)
            } label: {
                Label(
                    building.isFavorite ? "Remove from Favorites" : "Add to Favorites" ,
                    systemImage: building.isFavorite ? "star.fill" : "star"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
        
    }
}
