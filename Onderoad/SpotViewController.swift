//
//  SpotViewController.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 26/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit
import GoogleMaps

class SpotViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		loadView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func loadView() {
		let camera = GMSCameraPosition.camera(withLatitude: 42.416055, longitude: 12.848037, zoom: 5)
		let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
		self.view = mapView
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
