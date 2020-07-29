//
//  ViewController.swift
//  Bitcoinify
//
//  Created by Nwachukwu Ejiofor on 28/07/2020.
//  Copyright © 2020 Nwachukwu Ejiofor. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	@IBOutlet weak var bitcoinPriceLabel: UILabel!
	@IBOutlet weak var currencyPicker: UIPickerView!
	
	let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
	var row = 0
	var finalURL = ""
	let parameter = ["x-ba-key": "MzYzMjQxYjg3N2MxNGU4NGFhNTg4YjViYzNjZWU0ZmI"] as [String : Any]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		currencyPicker.delegate = self
		currencyPicker.dataSource = self
	}

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return currencyArray.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return currencyArray[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		finalURL = baseURL + currencyArray[row]
		self.row = row
		getBitcoinPrice(url: finalURL)
	}
	
	func getBitcoinPrice(url: String) {
		Alamofire.request(url, method: .get, parameters: parameter)
			.responseString { response in
				if response.result.isSuccess {
					let bitcoinJSON: JSON = JSON(response.result.value!)
					print(bitcoinJSON)
					self.updateBitcoinPrice(json: bitcoinJSON)
				} else {
					print("Error: \(String(describing: response.result.error))")
					self.bitcoinPriceLabel.text = "Connection Issues"
				}
		}
	}
	
	func updateBitcoinPrice(json: JSON) {
		if let bitcoinPrice = json["ask"].double {
			bitcoinPriceLabel.text = "\(currencySymbolArray[row])\(bitcoinPrice)"
		} else {
			bitcoinPriceLabel.text = "Price unavailable"
		}
	}
	
}

