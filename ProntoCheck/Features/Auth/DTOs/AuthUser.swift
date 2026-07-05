//
//  AuthUser.swift
//  ProntoCheck
//
//  Created by luisr on 04/07/26.
//


import Foundation

struct AuthUser: Decodable, Identifiable {
    let id: UUID
    let email: String
}
