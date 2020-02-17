//
//  ProductsListConnector.swift
//  CurrencyApp
//
//  Created by RazvanB on 16/02/2020.
//  Copyright © 2020 RazvanB. All rights reserved.
//

import UIKit

class ProductsListConnector {
	private let entityGateway: EntityGateway
	lazy var transactionsConnectorInit: (EntityGateway, String) -> TransactionsConnector = { entityGateway, sku in
		TransactionsConnector(entityGateway: entityGateway, sku: sku)
    }

	init(entityGateway: EntityGateway) {
		self.entityGateway = entityGateway
	}

	func assembleModule(view: ProductsTableViewController) {
		let viewModel = ProductsListViewModel(entityGateway: entityGateway)
		view.viewModel = viewModel
		view.connector = self
		viewModel.view = view
	}

	func navigateToTransactionsScreen(viewController: UIViewController, viewModel: ProductsListViewModel) {
		guard let sku = viewModel.selectedSku else {
			return
		}

		let transactionsViewController = viewController as! TransactionsViewController
		let connector = transactionsConnectorInit(entityGateway, sku)
		connector.assembleModule(view: transactionsViewController)
	}
}
