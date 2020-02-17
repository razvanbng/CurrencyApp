//
//  ProductsListViewModel.swift
//  CurrencyApp
//
//  Created by RazvanB on 16/02/2020.
//  Copyright © 2020 RazvanB. All rights reserved.
//

import Foundation

protocol ProductsListView: class {
	func reload()
	func navigateToTransactionsScreen()
}

class ProductsListViewModel {
	private var products: [String] {
		entityGateway.fetchSkus()
	}
	private let entityGateway: EntityGateway
	weak var view: ProductsListView!
	var selectedSku: String?

	init(entityGateway: EntityGateway) {
		self.entityGateway = entityGateway
	}

	func viewReady() {
		NetworkServiceProvider.sharedInstance.performRequest(expectedType: Array<Transaction>.self,
															 configuration: TransactionsRouter.getTransactions,
															 completionHandler: { [weak self] result in
																switch result {
																case .success(let transactions):
																	transactions.forEach {
																		self?.entityGateway.create(transaction: $0)
																	}

																	DispatchQueue.main.async {
																		self?.view.reload()
																	}
																case .failure(let error):
																	print(error)
																}
		})

		NetworkServiceProvider.sharedInstance.performRequest(expectedType: Array<Conversion>.self,
															 configuration: TransactionsRouter.getRates,
															 completionHandler: { [weak self] result in
																switch result {
																case .success(let conversions):
																	conversions.forEach {
																		self?.entityGateway.create(conversion: $0)
																	}
																case .failure(let error):
																	print(error)
																}
		})
	}

	func numberOfProducts() -> Int {
		products.count
	}

	func product(atRow row: Int) -> String {
		products[row]
	}

	func select(row: Int) {
		selectedSku = products[row]
		view.navigateToTransactionsScreen()
	}
}
