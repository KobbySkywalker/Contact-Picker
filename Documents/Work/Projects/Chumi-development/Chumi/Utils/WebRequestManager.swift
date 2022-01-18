//
//  WebRequestManager.swift
//  Chumi
//
//  Created by Fitzgerald Afful on 02/02/2021.
//

import Foundation
import Alamofire

public typealias CompletionHandler<ResultType> = ((Result<ResultType, Error>) -> Void)

class WebRequestManager {

    func load<T: Decodable>(url: String, parameters: [String: String], method: HTTPMethod = .post, authentication: Bool = true, completion: @ escaping CompletionHandler<T>) {
        var headers: HTTPHeaders = []
        if let accessToken = CredentialsManager.get(.accessToken) {
            if authentication == true {
                headers = [.authorization(bearerToken: accessToken)]
            }
        }
        headers.add(.contentType("application/json"))
        headers.add(.accept("application/json"))

        AF.request(url, method: method, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let result):
                    completion(.success(result))
                case .failure( let error):
                    if let data = response.data, let niceError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        completion(.failure(niceError))
                        return
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }

    func load(url: String, parameters: [String: String], method: HTTPMethod = .post, authentication: Bool = true, completion: @escaping (Result<Any, Error>) -> Void) {
        var headers: HTTPHeaders = []
        if let accessToken = CredentialsManager.get(.accessToken) {
            if authentication == true {
                headers = [.authorization(bearerToken: accessToken)]
            }
        }
        headers.add(.contentType("application/json"))
        headers.add(.accept("application/json"))
        AF.request(url, method: method, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .responseJSON { response in
                let code = response.response?.statusCode
                if code != nil && (code! >= 200 && code! <= 300) {
                    completion(.success(response))
                    return
                } else {
                    if let data = response.data, let niceError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        completion(.failure(niceError))
                        return
                    } else {
                        if let error = response.error {
                            completion(.failure(error))
                        } else {
                            completion(.failure(NetworkError(message: "Unable to reach server, please try again")))
                        }
                    }
                }
            }
    }
}
