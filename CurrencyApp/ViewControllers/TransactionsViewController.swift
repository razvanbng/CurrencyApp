//
//  TransactionsViewController.swift
//  CurrencyApp
//
//  Created by RazvanB on 16/02/2020.
//  Copyright © 2020 RazvanB. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController {
	var viewModel: TransactionsViewModel!
	var connector: TransactionsConnector!
	
	@IBOutlet private weak var sumLabel: UILabel!
	@IBOutlet private weak var transactionsTableView: UITableView!
	@IBOutlet private weak var currencySegmentedControl: UISegmentedControl!

	@IBAction func didSelectCurrency(_ sender: UISegmentedControl) {
		viewModel.didSelectCurrency(atIndex: sender.selectedSegmentIndex)
	}

	override func viewDidLoad() {
        super.viewDidLoad()
		configureView()
		viewModel.viewReady()
		for index in 0..<viewModel.numberOfCurrencies() {
			currencySegmentedControl.setTitle(viewModel.titleForCurrency(atIndex: index), forSegmentAt: index)
		}
		viewModel.didSelectCurrency(atIndex: 0)
    }

	private func configureView() {
		navigationItem.title = "Transactions"
		transactionsTableView.register(UINib(nibName: String(describing: TransactionTableViewCell.self), bundle: nil),
									   forCellReuseIdentifier: String(describing: TransactionTableViewCell.self))
		transactionsTableView.dataSource = self
		transactionsTableView.rowHeight = 30
	}
}

extension TransactionsViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.numberOfTransactions()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TransactionTableViewCell.self), for: indexPath) as! TransactionTableViewCell
		viewModel.configure(cell: cell, forRow: indexPath.row)
		return cell
	}
}

extension TransactionsViewController: TranscationsView {
	func reload() {
		transactionsTableView.reloadData()
	}

	func display(totalAmout: String?) {
		sumLabel.text = totalAmout
	}
}
