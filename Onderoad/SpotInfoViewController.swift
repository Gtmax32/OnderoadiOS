//
//  SpotInfoViewController.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 02/07/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit

class SpotInfoViewController: UIViewController {
	
	var spotToShow: SpotInfo?
	
	@IBOutlet weak var spotLocationLabel: UILabel!
	
	@IBOutlet weak var spotContainerMap: GMSMapView!
	
	@IBOutlet weak var waveValueLabel: UILabel!
	
	@IBOutlet weak var windValueLabel: UILabel!
	
	@IBOutlet weak var swellValueLabel: UILabel!
	
	@IBOutlet weak var seabedValueLabel: UILabel!
	
	@IBOutlet weak var noteValue: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let camera: GMSCameraPosition
		
		if let spot = spotToShow {
			spotLocationLabel.text = spot.nameSpot + ", " + spot.citySpot + ", " + spot.provinceSpot + ", " + spot.regionSpot
			
			waveValueLabel.text = spot.tableSpot.waveSpot
			windValueLabel.text = spot.tableSpot.windSpot
			swellValueLabel.text = spot.tableSpot.swellSpot
			seabedValueLabel.text = spot.tableSpot.seabedSpot
			
			noteValue.text = spot.descriptionSpot
			
			camera = GMSCameraPosition.camera(withLatitude: spot.position.latitude, longitude: spot.position.longitude, zoom: 7)
			self.spotContainerMap.camera = camera
			
			let marker = GMSMarker()
			marker.position = CLLocationCoordinate2D(latitude: spot.position.latitude, longitude: spot.position.longitude)
			marker.title = spot.nameSpot
			marker.snippet = spot.descriptionSpot
			marker.map = self.spotContainerMap
		}
		else {
			camera = GMSCameraPosition.camera(withLatitude: 42.416055, longitude: 12.848037, zoom: 5)
			self.spotContainerMap.camera = camera
		}
		
		setupBottomToolbar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func setupBottomToolbar(){
		let toolbarPosition = CGRect(x: 0, y: self.view.bounds.height - 44, width: self.view.bounds.width, height: 44)
		let bottomToolbar = UIToolbar(frame: toolbarPosition)
		
		bottomToolbar.barStyle = UIBarStyle.default
		bottomToolbar.isTranslucent = true
		bottomToolbar.sizeToFit()
		
		let contactButton = UIBarButtonItem(title: "Crea un viaggio qui", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SpotInfoViewController.createButtonClicked))
		let spotMapButton = UIBarButtonItem(title: "Vai allo spot", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SpotInfoViewController.spotMapButtonClicked))
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		
		bottomToolbar.setItems([contactButton, spaceButton, spotMapButton], animated: false)
		bottomToolbar.isUserInteractionEnabled = true
		
		self.view.addSubview(bottomToolbar)
	}
	
	func createButtonClicked(sender: UIBarButtonItem){
		print("Creation button pressed")
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
