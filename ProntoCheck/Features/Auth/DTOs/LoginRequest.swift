//
//  LoginRequest.swift
//  ProntoCheck
//
//  Created by luisr on 04/07/26.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}
