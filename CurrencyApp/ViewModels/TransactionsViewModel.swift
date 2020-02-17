//
//  TransactionsViewModel.swift
//  CurrencyApp
//
//  Created by RazvanB on 16/02/2020.
//  Copyright © 2020 RazvanB. All rights reserved.
//

import Foundation

enum Currency {
	case eur
	case usd

	var name: String {
		switch self {
		case .eur:
			return "EUR"
		case .usd:
			return "USD"
		}
	}
}

protocol TranscationsView: class {
	func reload()
	func display(totalAmout: String?)
}

class TransactionsViewModel {
	weak var view: TranscationsView!
	private let entityGateway: EntityGateway
	private let sku: String
	private let conversionEngine: ConversionEngine
	private var transactions: [Transaction] = []
	private var currencies: [Currency] = [.eur, .usd]

	init(entityGateway: EntityGateway, sku: String) {
		self.entityGateway = entityGateway
		self.sku = sku
		self.conversionEngine = ConversionEngine(availableConversions: entityGateway.fetchConversions())
	}

	func viewReady() {
		transactions = entityGateway.fetchTransactions(sku: sku)
		view.reload()


	}

	func numberOfTransactions() -> Int {
		transactions.count
	}

	func configure(cell: TransactionsTableViewCellDisplayHandler, forRow row: Int) {
		let transaction = transactions[row]
		cell.display(sku: "SKU: \(transaction.sku)")
		cell.display(amount: "Amount: \(transaction.amount)")
		cell.display(currency: "Currency: \(transaction.currency)")
	}

	func numberOfCurrencies() -> Int {
		currencies.count
	}

	func titleForCurrency(atIndex index: Int) -> String {
		currencies[index].name
	}

	func didSelectCurrency(atIndex index: Int) {
		let convertedValues = transactions.compactMap { try? conversionEngine.convert(input: ConversionRequest(from: $0.currency,
																											   to: titleForCurrency(atIndex: index),
																											   amount: $0.amount)) }
		let totalAmount = convertedValues.reduce(NSDecimalNumber.zero) { result, value in
			result.adding(value)
		}.stringValue
		view.display(totalAmout: "Total Value: \(totalAmount)")
	}
}
