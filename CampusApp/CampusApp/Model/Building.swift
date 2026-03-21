//
//  Buildings.swift
//  CampusApp
//
//  Created by Haley Parker on 3/18/26.
//
import Foundation
import CoreLocation

struct Building: Identifiable, Codable, Equatable {
    let name: String
    let oppBldgCode: Int
    let latitude: Double
    let longitude: Double
    let yearConstructed: Int?
    let photo: String?

    var isSelected: Bool = false
    var isFavorite: Bool = false

    var id: Int { oppBldgCode }

    var code: String {
        String(oppBldgCode)
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case oppBldgCode = "opp_bldg_code"
        case latitude
        case longitude
        case yearConstructed = "year_constructed"
        case photo
        case isSelected
        case isFavorite
    }

    init(
        name: String,
        oppBldgCode: Int,
        latitude: Double,
        longitude: Double,
        yearConstructed: Int? = nil,
        photo: String? = nil,
        isSelected: Bool = false,
        isFavorite: Bool = false
    ) {
        self.name = name
        self.oppBldgCode = oppBldgCode
        self.latitude = latitude
        self.longitude = longitude
        self.yearConstructed = yearConstructed
        self.photo = photo
        self.isSelected = isSelected
        self.isFavorite = isFavorite
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        oppBldgCode = try container.decode(Int.self, forKey: .oppBldgCode)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        yearConstructed = try container.decodeIfPresent(Int.self, forKey: .yearConstructed)
        photo = try container.decodeIfPresent(String.self, forKey: .photo)
        isSelected = try container.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }
}
