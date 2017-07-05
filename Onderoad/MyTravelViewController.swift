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
	var passengerTravels = [TravelInfo]()
	var travelRef: DatabaseReference!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		travelRef = Database.database().reference().child("travels")
    }
	
	override func viewWillAppear(_ animated: Bool) {
		
		driverTravels.removeAll()
		
		travelRef.observe(DataEventType.value, with: { snapshot in
			for child in snapshot.children.allObjects as! [DataSnapshot]{
				//let travelDict = child.value as? [String:Any] ?? [:]
				
				let serverTravel = TravelInfo.init(snapshot: child)
				//print("Server Travel: \(serverTravel?.description ?? "Error on converting TravelInfo Object")")
				if serverTravel?.ownerTravel.idUser == Auth.auth().currentUser?.uid{
					let newIndexPath = IndexPath(row: self.driverTravels.count, section: 0)
					
					self.driverTravels.append(serverTravel!)
					
					self.tableView.insertRows(at: [newIndexPath], with: .automatic)
				}
			}
		})
		
		tableView.reloadData()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//MARK: Action Methods
	/*@IBAction func unwindToTravelList(sender: UIStoryboardSegue){
		print("In unwindToTravelList")
		
		if let sourceViewController = sender.source as? CreateViewController, let travel = sourceViewController.travel {
			let newIndexPath = IndexPath(row: travels.count, section: 0)
			
			
			
			travels.append(travel)
			
			tableView.insertRows(at: [newIndexPath], with: .automatic)
		}
	}*/
	
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
			
			let selectedTravel = driverTravels[indexPath.row]
			travelDetailViewController.travelToShow = selectedTravel
			
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
