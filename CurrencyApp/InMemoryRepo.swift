//
//  InMemoryRepo.swift
//  CurrencyApp
//
//  Created by RazvanB on 16/02/2020.
//  Copyright © 2020 RazvanB. All rights reserved.
//

import Foundation

struct Conversion: Decodable, Equatable {
	let from: String
	let to: String
	let rate: String
}

struct Transaction: Decodable {
	let sku: String
	let amount: String
	let currency: String
}

protocol EntityGateway {
	func create(transaction: Transaction)
	func create(conversion: Conversion)
	func fetchTransactions() -> [Transaction]
	func fetchConversions() -> [Conversion]
	func fetchTransactions(sku: String) -> [Transaction]
	func fetchSkus() -> [String]
}

class InMemoryRepo {
	var transactions: [Transaction] = []
	var conversions: [Conversion] = []
}

extension InMemoryRepo: EntityGateway {
	func create(transaction: Transaction) {
		transactions.append(transaction)
	}

	func create(conversion: Conversion) {
		conversions.append(conversion)
	}

	func fetchTransactions() -> [Transaction] {
		transactions
	}

	func fetchConversions() -> [Conversion] {
		conversions
	}

	func fetchTransactions(sku: String) -> [Transaction] {
		transactions.filter { $0.sku == sku }
	}

	func fetchSkus() -> [String] {
		transactions.reduce([String]()) { result, transaction in
			var mutableResult = result

			if !mutableResult.contains(transaction.sku) {
				mutableResult.append(transaction.sku)
			}
			
			return mutableResult
		}
	}
}
