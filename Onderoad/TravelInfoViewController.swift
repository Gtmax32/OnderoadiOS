//
//  TravelInfoViewController.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 30/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit

class TravelInfoViewController: UIViewController {
	
	//MARK: Properties
	var travelToShow: TravelInfo?
	
	@IBOutlet weak var mapContainerView: GMSMapView!
	
	@IBOutlet weak var departureDateTimeLabel: UILabel!
	
	@IBOutlet weak var addressRouteLabel: UILabel!
	
	@IBOutlet weak var addressProvince: UILabel!
	
	@IBOutlet weak var spotNameLabel: UILabel!
	
	@IBOutlet weak var spotProvinceLabel: UILabel!
	
	@IBOutlet weak var passengerNumberLabel: UILabel!
	
	@IBOutlet weak var priceTravelLabel: UILabel!
	
	@IBOutlet weak var surfboardNumberLabel: UILabel!
	
	@IBOutlet weak var supportTypeLabel: UILabel!
	
	@IBOutlet weak var noteTravel: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		//self.tabBarController?.tabBar.isHidden = true
		
		let camera: GMSCameraPosition
		
		if let travel = travelToShow {
			
			departureDateTimeLabel.text = travel.fromMillisToString()
			addressRouteLabel.text = travel.addressDeparture.streetInfo
			addressProvince.text = travel.addressDeparture.provinceInfo
			
			spotNameLabel.text = travel.spotDestination.nameSpot + ", " + travel.spotDestination.citySpot
			spotProvinceLabel.text = travel.spotDestination.provinceSpot + ", " + travel.spotDestination.regionSpot
			
			var passengers = 0
			
			if travel.passengersTravel != nil {
				passengers = travel.passengersTravel!.count
			}
			
			passengerNumberLabel.text = String(passengers) + "/" + String(travel.carTravel.passengerNumber) + " posti occupati"
			
			priceTravelLabel.text = String(travel.priceTravel) + " €"
			
			//TODO: Sistemare la visualizzazione del numero di tavole trasportabili, dopo aver capito come tener traccia di questo, magari facendo diventare la lista dei passegeri un hashmap composto da <User,Bool>, dove il bool indica se porta o meno la tavola.
			
			surfboardNumberLabel.text = String(travel.carTravel.surfboardNumber)
			
			supportTypeLabel.text = travel.carTravel.surfboardType
			
			noteTravel.text = travel.noteTravel
			
			camera = GMSCameraPosition.camera(withLatitude: travel.spotDestination.position.latitude, longitude: travel.spotDestination.position.longitude, zoom: 7)
			self.mapContainerView.camera = camera
			
			let marker = GMSMarker()
			marker.position = CLLocationCoordinate2D(latitude: travel.spotDestination.position.latitude, longitude: travel.spotDestination.position.longitude)
			marker.title = travel.spotDestination.nameSpot
			marker.snippet = travel.spotDestination.descriptionSpot
			marker.map = self.mapContainerView
		}
		else {
			camera = GMSCameraPosition.camera(withLatitude: 42.416055, longitude: 12.848037, zoom: 5)
			self.mapContainerView.camera = camera
		}
		
		setupBottomToolbar()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func shareTravelButtonPressed(_ sender: UIBarButtonItem) {
		print("Share Travel Button Pressed")
	}
	
	private func setupBottomToolbar(){
		let toolbarPosition = CGRect(x: 0, y: self.view.bounds.height - 44, width: self.view.bounds.width, height: 44)
		let bottomToolbar = UIToolbar(frame: toolbarPosition)
		
		bottomToolbar.barStyle = UIBarStyle.default
		bottomToolbar.isTranslucent = true
		bottomToolbar.sizeToFit()
		
		let contactButton = UIBarButtonItem(title: "Contatta", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TravelInfoViewController.contactButtonClicked))
		let spotMapButton = UIBarButtonItem(title: "Vai allo spot", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TravelInfoViewController.spotMapButtonClicked))
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		
		bottomToolbar.setItems([contactButton, spaceButton, spotMapButton], animated: false)
		bottomToolbar.isUserInteractionEnabled = true
		
		self.view.addSubview(bottomToolbar)
	}
	
	func contactButtonClicked(sender: UIBarButtonItem){
		print("Contact button pressed")
	}
	
	func spotMapButtonClicked(sender: UIBarButtonItem){
		print("SpotMap button pressed")
	}
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
