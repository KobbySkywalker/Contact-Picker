//
//  ErrorModels.swift
//  Chumi
//
//  Created by Fitzgerald Afful on 02/02/2021.
//

import Foundation

struct ErrorResponse: Codable, LocalizedError {
    let error: String?
    let errorMessage: String?
    var errorDescription: String?
    var detail: String?

    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
        case errorMessage = "errorMessage"
        case detail
    }
}

struct NetworkError {
    let message: String

    init(message: String) {
        self.message = message
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? { return message }
}
