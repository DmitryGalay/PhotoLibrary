//
//  MainModel.swift
//  PhotoLibrary
//
//  Created by Dima on 16.05.22.
//

import Foundation

typealias MainModel = [String: Strain]


struct Strain: Codable {
    let photo_url: String
    let user_name: String
    let user_url: String
    let colors: [String]

}
