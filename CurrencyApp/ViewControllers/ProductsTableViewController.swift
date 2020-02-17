//
//  ProductsTableViewController.swift
//  CurrencyApp
//
//  Created by RazvanB on 16/02/2020.
//  Copyright © 2020 RazvanB. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController {
	struct SegueIdentifier {
        static let showTransactions = "ShowTransactions"
    }

	var viewModel: ProductsListViewModel!
	var connector: ProductsListConnector!

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.title = "Products"
		viewModel.viewReady()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
		1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.numberOfProducts()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCellId", for: indexPath)
		cell.textLabel?.text = viewModel.product(atRow: indexPath.row)
        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.select(row: indexPath.row)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == SegueIdentifier.showTransactions {
			connector.navigateToTransactionsScreen(viewController: segue.destination, viewModel: viewModel)
		}
	}
}

extension ProductsTableViewController: ProductsListView {
	func reload() {
		tableView.reloadData()
	}

	func navigateToTransactionsScreen() {
		performSegue(withIdentifier: SegueIdentifier.showTransactions, sender: self)
	}
}
