//
//  MyTravelViewController.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 17/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MyTravelViewController: UITableViewController {
	
	//MARK: Properties
	
	var driverTravels = [TravelInfo]()
	var driverTravelsKey = [String]()
	var passengerTravels = [TravelInfo]()
	var passengerTravelsKey = [String]()
	var travelRef: DatabaseReference!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		travelRef = Database.database().reference().child("travels")
		
		travelRef.observe(DataEventType.value, with: { snapshot in
			self.driverTravels.removeAll()
			self.driverTravelsKey.removeAll()
			
			self.passengerTravels.removeAll()
			self.passengerTravelsKey.removeAll()
			
			self.tableView.reloadData()
			
			for child in snapshot.children.allObjects as! [DataSnapshot]{
				let currentUserID = Auth.auth().currentUser?.uid
				//Leggo il viaggio, lo converto in dizionario
				let travelDict = child.value as? [String:Any] ?? [:]
				
				let serverTravel = TravelInfo.init(travelDict: travelDict)
				
				if serverTravel!.ownerTravel.idUser == currentUserID{
					
					//print("Server Travel: \(serverTravel?.description ?? "Error on converting TravelInfo Object")")
					
					self.driverTravels.append(serverTravel!)
					self.driverTravelsKey.append(child.key)
					
					let newIndexPath = IndexPath(row: self.driverTravels.count - 1, section: 0)
					
					self.tableView.insertRows(at: [newIndexPath], with: .automatic)
				} else if serverTravel!.passengersTravel.contains(where: {$0.idUser == currentUserID}){
					//print("Server Travel: \(serverTravel?.description ?? "Error on converting TravelInfo Object")")
					
					let newIndexPath = IndexPath(row: self.passengerTravels.count, section: 1)
					
					self.passengerTravels.append(serverTravel!)
					self.passengerTravelsKey.append(child.key)
					
					self.tableView.insertRows(at: [newIndexPath], with: .automatic)
				}
			}
		})
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//MARK: Action Methods
	@IBAction func unwindToTravelList(sender: UIStoryboardSegue){
		print("In unwindToTravelList")		
	}
	
	// MARK: - Navigation
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		
		switch(segue.identifier ?? "") {
			
		case "CreateTravel":
			print("Adding a new travel.")
			
		case "ShowTravel":
			guard let travelDetailViewController = segue.destination as? TravelInfoViewController else {
				fatalError("Unexpected destination: \(segue.destination)")
			}
			
			guard let selectedTravelCell = sender as? TravelDetailTableViewCell else {
				fatalError("Unexpected sender: \(String(describing: sender))")
			}
			
			guard let indexPath = tableView.indexPath(for: selectedTravelCell) else {
				fatalError("The selected cell is not being displayed by the table")
			}
			
			var selectedTravel: TravelInfo?
			var selectedTravelKey: String?
			
			if indexPath.section == 0 {
				selectedTravel = driverTravels[indexPath.row]
				selectedTravelKey = driverTravelsKey[indexPath.row]
			} else if indexPath.section == 1{
				selectedTravel = passengerTravels[indexPath.row]
				selectedTravelKey = passengerTravelsKey[indexPath.row]
			}
				
			travelDetailViewController.travelToShow = selectedTravel
			travelDetailViewController.travelToShowKey = selectedTravelKey
			
		default:
			fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
		}
	}
	
	//MARK: Table View Methods
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		//TODO: Forse dovrei mettere 2, per visualizzare i viaggi creati da me e quelli di cui sono passeggero
		return 2
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var rowCount = 0
		
		if section == 0{
			rowCount = driverTravels.count
		}
		else if section == 1{
			rowCount = passengerTravels.count
		}
		
		return rowCount
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "TravelDetailTableViewCell"
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TravelDetailTableViewCell else{
			fatalError("La cella non è di tipo TravelDetailTableViewCell")
		}
		
		var travel: TravelInfo? = nil
		
		if indexPath.section == 0{
			travel = driverTravels[indexPath.row]
		} else {
			travel = passengerTravels[indexPath.row]
		}
		
		cell.travelDetailDateTimeLabel.text = travel!.fromMillisToString()
		cell.travelDetailPriceLabel.text = String(travel!.priceTravel)
		cell.travelDetailDepartureLabel.text = travel!.addressDeparture.provinceInfo
		cell.travelDetailDestinationLabel.text = travel!.spotDestination.nameSpot
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		var title = ""
		
		if section == 0 {
			title = "Guido io"
		}
		else if section == 1 {
			title = "Sono un passeggero"
		}
		
		return title
	}
}
