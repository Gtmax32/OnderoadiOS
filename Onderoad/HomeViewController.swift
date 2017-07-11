//
//  HomeViewController.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 26/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeViewController: UITableViewController {
	
	//MARK: Properties
	
	var travels = [TravelInfo]()
	var travelKeys = [String]()
	var travelRef: DatabaseReference!
	
	var message = UILabel()
	var messageContainer: UIView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		travelRef = Database.database().reference().child("travels")
		
		travelRef.observe(DataEventType.value, with: { snapshot in
			self.travels.removeAll()
			self.travelKeys.removeAll()
			self.tableView.reloadData()
			
			for child in snapshot.children.allObjects as! [DataSnapshot]{
				//let travelDict = child.value as? [String:Any] ?? [:]
				let currentUserID = Auth.auth().currentUser?.uid
				
				let travelDict = child.value as? [String:Any] ?? [:]
				let idOwnerTravel = (travelDict["ownerTravel"] as! [String : String])["idUser"] ?? "Error reading user from serverDict"
				
				if idOwnerTravel !=  currentUserID{
					let serverTravel = TravelInfo.init(travelDict: travelDict)
					//print("Server Travel: \(serverTravel?.description ?? "Error on converting TravelInfo Object")")
					let isPassenger = serverTravel!.passengersTravel.contains(where: {$0.idUser == currentUserID})
					
					if !isPassenger{
						let newIndexPath = IndexPath(row: self.travels.count, section: 0)
						
						self.travels.append(serverTravel!)
						self.travelKeys.append(child.key)
						
						self.tableView.insertRows(at: [newIndexPath], with: .automatic)
					}
				}
			}
		})
		let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
		messageContainer = UIView(frame: frame)
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		print("In prepareForSegue")
		
		super.prepare(for: segue, sender: sender)
		
		guard let travelDetailViewController = segue.destination as? TravelInfoViewController else {
		fatalError("Unexpected destination: \(segue.destination)")
		}
		
		guard let selectedTravelCell = sender as? HomeTravelDetailTableCell else {
		fatalError("Unexpected sender: \(String(describing: sender))")
		}
		
		guard let indexPath = tableView.indexPath(for: selectedTravelCell) else {
		fatalError("The selected cell is not being displayed by the table")
		}
		
		let selectedTravel = travels[indexPath.row]
		let selectedTravelKey = travelKeys[indexPath.row]
		travelDetailViewController.travelToShow = selectedTravel
		travelDetailViewController.travelToShowKey = selectedTravelKey
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let count = travels.count
		
		if count == 0 {
			message.center = self.view.center
			
			message.text = "Non ci sono viaggi? Vai in MyTravel e crea il tuo viaggio!"
			message.lineBreakMode = .byWordWrapping
			message.numberOfLines = 0
			message.sizeToFit()
			message.translatesAutoresizingMaskIntoConstraints = false
			
			messageContainer.addSubview(message)
			messageContainer.addConstraint(NSLayoutConstraint(item: message, attribute: .leading, relatedBy: .equal, toItem: messageContainer, attribute: .leading, multiplier: 1, constant: 15))
			messageContainer.addConstraint(NSLayoutConstraint(item: message, attribute: .trailing, relatedBy: .equal, toItem: messageContainer, attribute: .trailing, multiplier: 1, constant: -15))
			messageContainer.addConstraint(NSLayoutConstraint(item: message, attribute: .top, relatedBy: .equal, toItem: messageContainer, attribute: .top, multiplier: 1, constant: self.view.bounds.height/2 - 20))
			messageContainer.isHidden = false
			
			tableView.backgroundView = messageContainer
			tableView.separatorStyle = .none
		} else {
			messageContainer.isHidden = true
			tableView.separatorStyle = .singleLine
		}
		
		return count

    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {		
		let cellIdentifier = "HomeTravelDetailTableCell"
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HomeTravelDetailTableCell else{
			fatalError("La cella non è di tipo HomeTravelDetailTableCell")
		}
		
		let travel = travels[indexPath.row]
		
		//print("In tableView:cellForRowAt: " + travel.description)
		
		cell.travelDetailDateTimeLabel.text = travel.fromMillisToString()
		cell.travelDetailPriceLabel.text = String(travel.priceTravel)
		cell.travelDetailDepartureLabel.text = travel.addressDeparture.provinceInfo
		cell.travelDetailDestinationLabel.text = travel.spotDestination.nameSpot
		
		return cell
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
