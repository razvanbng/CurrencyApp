//
//  TransactionTableViewCell.swift
//  CurrencyApp
//
//  Created by RazvanB on 16/02/2020.
//  Copyright © 2020 RazvanB. All rights reserved.
//

import UIKit

protocol TransactionsTableViewCellDisplayHandler {
	func display(sku: String)
	func display(amount: String)
	func display(currency: String)
}

class TransactionTableViewCell: UITableViewCell, TransactionsTableViewCellDisplayHandler {
	@IBOutlet private weak var skuLabel: UILabel!
	@IBOutlet private weak var amountLabel: UILabel!
	@IBOutlet private weak var currencyLabel: UILabel!

	func display(sku: String) {
		skuLabel.text = sku
	}

	func display(amount: String) {
		amountLabel.text = amount
	}

	func display(currency: String) {
		currencyLabel.text = currency
	}
}
