//
//  Result.swift
//  Aftown
//
//  Created by Created by Hosny Ben Savage on 04/01/2018.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import Foundation

struct CoreError: Error {
	var localizedDescription: String {
		return message
	}
	
	var message = ""
}

// See https://github.com/antitypical/Result
enum Result<T> {
	case success(T)
	case failure(Error)
	
	public func dematerialize() throws -> T {
		switch self {
		case let .success(value):
			return value
		case let .failure(error):
			throw error
		}
	}
}

enum FetchError: Error{
	case NetworkFailed()
	case DeserialisingFailed()
	case ApiError(message:String)
}

