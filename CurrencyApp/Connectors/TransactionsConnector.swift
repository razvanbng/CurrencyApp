//
//  TransactionsConnector.swift
//  CurrencyApp
//
//  Created by RazvanB on 16/02/2020.
//  Copyright © 2020 RazvanB. All rights reserved.
//

import Foundation

class TransactionsConnector {
	private let entityGateway: EntityGateway
	private let sku: String

	init(entityGateway: EntityGateway, sku: String) {
		self.entityGateway = entityGateway
		self.sku = sku
	}

	func assembleModule(view: TransactionsViewController) {
		let viewModel = TransactionsViewModel(entityGateway: entityGateway, sku: sku)
		view.viewModel = viewModel
		view.connector = self
		viewModel.view = view
	}
}
