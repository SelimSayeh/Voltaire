//
//  Localisation.swift
//  Voltaire
//
//  Created by user210230 on 6/20/22.

import Foundation
import UIKit

import Foundation

// MARK: - Welcome
struct Welcome: Decodable {
    let nhits: Int
    let parameters: Parameters
    let records: [records]
    let facetGroups: [FacetGroup]

    enum CodingKeys: String, CodingKey,Decodable {
        case nhits, parameters, records
        case facetGroups = "facet_groups"
    }
}
struct WelcomeResponse : Decodable{
    let welcome : [Welcome]
}

// MARK: - FacetGroup
struct FacetGroup: Codable {
    let name: String
    let facets: [FacetElement]
}

enum FacetElement: Codable {
    case facetClass(FacetClass)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(FacetClass.self) {
            self = .facetClass(x)
            return
        }
        throw DecodingError.typeMismatch(FacetElement.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for FacetElement"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .facetClass(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - FacetClass
struct FacetClass: Codable {
    let name: String
    let count: Int
    let state, path: String
}

// MARK: - Parameters
struct Parameters: Codable {
    let dataset: Dataset
    let rows, start: Int
    let facet: [String]
    let format, timezone: String
}

enum Dataset: String, Codable {
    case velibDisponibiliteEnTempsReel = "velib-disponibilite-en-temps-reel"
}

// MARK: - Record
struct records: Decodable {
    let datasetid: Dataset
    let recordid: String
    let fields: Fields
    let geometry: Geometry
    let recordTimestamp: RecordTimestamp

    enum CodingKeys: String, CodingKey,Decodable {
        case datasetid, recordid, fields, geometry
        case recordTimestamp = "record_timestamp"
    }
}
struct RecordResponse : Decodable{
    let records : [records]
}
// MARK: - Fields
struct Fields: Decodable {
    let name, stationcode: String
    let ebike, mechanical: Int
    let coordonneesGeo: [Double]
    let duedate: Date
    let numbikesavailable, numdocksavailable, capacity: Int
    let isRenting, isInstalled: Is
    let nomArrondissementCommunes: String
    let isReturning: Is

    enum CodingKeys: String, CodingKey {
        case name, stationcode, ebike, mechanical
        case coordonneesGeo = "coordonnees_geo"
        case duedate, numbikesavailable, numdocksavailable, capacity
        case isRenting = "is_renting"
        case isInstalled = "is_installed"
        case nomArrondissementCommunes = "nom_arrondissement_communes"
        case isReturning = "is_returning"
    }
}
struct FieldsResponse : Decodable{
    let fields : [Fields]
}
enum Is: String, Codable {
    case oui = "OUI"
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: TypeEnum
    let coordinates: [Double]
}

enum TypeEnum: String, Codable {
    case point = "Point"
}

enum RecordTimestamp: String, Codable {
    case the20220620T184400474Z = "2022-06-20T18:44:00.474Z"
}


