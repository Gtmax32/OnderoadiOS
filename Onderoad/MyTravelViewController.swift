//
//  MyTravelViewController.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 17/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit

class MyTravelViewController: UITableViewController {
	
	//MARK: Properties
	
	var travels = [TravelInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//MARK: Action Methods
	@IBAction func unwindToTravelList(sender: UIStoryboardSegue){
		print("In unwindToTravelList")
		
		if let sourceViewController = sender.source as? CreateViewController, let travel = sourceViewController.travel {
			let newIndexPath = IndexPath(row: travels.count, section: 0)
			
			travels.append(travel)
			
			tableView.insertRows(at: [newIndexPath], with: .automatic)
		}
	}	
	
	//MARK: Table View Methods
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		//TODO: Forse dovrei mettere 2, per visualizzare i viaggi creati da me e quelli di cui sono passeggero
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return travels.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "TravelDetailTableViewCell"
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TravelDetailTableViewCell else{
			fatalError("La cella non è di tipo TravelDetailTableViewCell")
		}
		
		let travel = travels[indexPath.row]
		
		//TODO: Implementare il resto della modifica dell'interfaccia
		cell.travelDetailDepartureLabel.text = travel.addressDeparture.provinceInfo
		cell.travelDetailDestinationLabel.text = travel.spotDestination.nameSpot
		
		return cell
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
