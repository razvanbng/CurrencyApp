//
//  ConversionEngine.swift
//  CurrencyApp
//
//  Created by RazvanB on 16/02/2020.
//  Copyright © 2020 RazvanB. All rights reserved.
//

import Foundation

struct ConversionRequest {
	let from: String
	let to: String
	let amount: String
}

class ConversionEngine {
	private let availableConversions: [Conversion]
	private lazy var decimalNumberHandler: NSDecimalNumberHandler = {
		NSDecimalNumberHandler(roundingMode: .bankers,
							   scale: 2,
							   raiseOnExactness: true,
							   raiseOnOverflow: true,
							   raiseOnUnderflow: true,
							   raiseOnDivideByZero: true)
	}()

	init(availableConversions: [Conversion]) {
		self.availableConversions = availableConversions
	}

	func convert(input: ConversionRequest) throws -> NSDecimalNumber {
		if let conversion = availableConversions.first(where: { $0.from == input.from && $0.to == input.to }) {
			return performConversion(amount: input.amount, rate: conversion.rate)
		} else {
			guard let fromConversion = availableConversions.first(where: { $0.from == input.from }) else {
				throw(ErrorImplementation(code: 0, description: "Conversion not available"))
			}

			let amount = performConversion(amount: input.amount, rate: fromConversion.rate)
			return try convert(input: ConversionRequest(from: fromConversion.to, to: input.to, amount: amount.stringValue))
		}
	}

	private func performConversion(amount: String, rate: String) -> NSDecimalNumber {
		let amountDecimalNumber = NSDecimalNumber(string: amount)
		let rateDecimalNumber = NSDecimalNumber(string: rate)

		return amountDecimalNumber.multiplying(by: rateDecimalNumber, withBehavior: decimalNumberHandler)
	}
}
