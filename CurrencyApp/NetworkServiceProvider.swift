//
//  NetworkServiceProvider.swift
//  CurrencyApp
//
//  Created by RazvanB on 16/02/2020.
//  Copyright © 2020 RazvanB. All rights reserved.
//

import Foundation
import Alamofire

struct ErrorImplementation: LocalizedError {
    let code: Int
    let description: String
}

struct ApiConstants {
    static let mimeType = "text/html"
    static let baseUrl = "http://gnb.dev.airtouchmedia.com/"
}

protocol ApiConfiguration {
	var path: String { get }
	var method: HTTPMethod { get }
	var headers: [String : String] { get }
}

extension ApiConfiguration {
	var method: HTTPMethod {
		.get
	}

	var headers: [String : String] {
		["Accept" : ApiConstants.mimeType]
	}
}

enum TransactionsRouter: ApiConfiguration {
	case getRates
	case getTransactions

	var path: String {
		switch self {
		case .getRates:
			return ApiConstants.baseUrl + "rates.json"
		case .getTransactions:
			return ApiConstants.baseUrl + "transactions.json"
		}
	}
}

class NetworkServiceProvider {
	static let sharedInstance = NetworkServiceProvider()

	private init() {}

	func performRequest<T: Decodable>(expectedType: T.Type, configuration: ApiConfiguration, completionHandler: @escaping (Result<T, Error>) -> Void) {
		guard let url = URL(string: configuration.path) else {
			completionHandler(.failure(ErrorImplementation(code: 0, description: "Could not construct url from path")))
			return
		}

		AF.request(url, method: configuration.method, headers: HTTPHeaders(configuration.headers))
			.validate()
			.responseJSON(completionHandler: { response in
				switch response.result {
				case .success:
					do{
						let decodedData = try JSONDecoder().decode(expectedType, from: response.data!)
						completionHandler(.success(decodedData))
					} catch (let error) {
						completionHandler(.failure(error))
					}
				case .failure(let error):
					completionHandler(.failure(error))
				}
			})
	}
}
