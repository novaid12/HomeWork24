//
//  UserModel.swift
//  HomeWork24
//
//  Created by  NovA on 11.10.23.
//

import CoreLocation
import Foundation

struct User: Codable {
    let id: Int
    let name: String?
    let username: String?
    let email: String?
    let phone: String?
    let website: String?
    let address: Address?
    let company: Company?
}

struct Address: Codable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    let geo: Geo?
}

struct Geo: Codable {
    let lat: String?
    let lng: String?
}

struct Company: Codable {
    let name: String?
    let catchPhrase: String?
    let bs: String?
}

struct Album: Codable {
    let id: Int
    let userId: Int?
    let title: String?
}

struct Photo: Codable {
    let id: Int
    let albumId: Int?
    let title: String?
    let url: String?
    let thumbnailUrl: String?
}

struct Post: Codable {
    let userId: Int?
    let id: Int
    let title: String?
    let body: String?
}
