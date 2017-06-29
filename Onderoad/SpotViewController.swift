//
//  SpotViewController.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 26/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit
import GoogleMaps

class SpotViewController: UIViewController, GMUClusterManagerDelegate, GMSMapViewDelegate {
	
	private var mapView: GMSMapView!
	private var clusterManager: GMUClusterManager!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Set up the cluster manager with default icon generator and renderer.
		let iconGenerator = GMUDefaultClusterIconGenerator()
		let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
		let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
		clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
		
		setSpotMap()
		
		// Call cluster() after items have been added to perform the clustering and rendering on map.
		clusterManager.cluster()
		
		// Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
		clusterManager.setDelegate(self, mapDelegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func loadView() {
		let camera = GMSCameraPosition.camera(withLatitude: 42.416055, longitude: 12.848037, zoom: 5.3)
		mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
		self.view = mapView
	}
	
	// MARK: - GMUClusterManagerDelegate
	func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool{
		let newCamera = GMSCameraPosition.camera(withTarget: cluster.position, zoom: mapView.camera.zoom + 1)
		let update = GMSCameraUpdate.setCamera(newCamera)
		
		mapView.moveCamera(update)
		
		return false
	}
	
	// MARK: - GMUMapViewDelegate
	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
		/*if let spot = marker.userData as? SpotInfo {
			NSLog("Did tap marker for cluster item \(spot.nameSpot)")
		} else {
			NSLog("Did tap a normal marker")
		}*/
		
		return false
	}
	
	//MARK: Private Methods
	
	private func setSpotMap(){
		let regionList = Array(RegionSpotDict.DICT.keys).sorted()
		
		for region in regionList{
			
			let spotList = RegionSpotDict.getSpotFromKey(key: region)
			
			if (spotList != nil) {
				clusterManager.add(spotList!)
			}
		}
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
