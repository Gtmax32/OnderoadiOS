//
//  TravelInfoViewController.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 30/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit
import MapKit
import MessageUI
import FirebaseDatabase
import Social

class TravelInfoViewController: UIViewController, MFMailComposeViewControllerDelegate {
	
	//MARK: Properties
	var travelToShow: TravelInfo?
	var travelToShowKey: String?
	
	private var isPassenger = false
	private var isOwner = false
	
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
			//print("Travel Showed: \(travel.description)")
			let currentUserID = Auth.auth().currentUser?.uid
			
			isOwner = travel.ownerTravel.idUser == currentUserID
			
			departureDateTimeLabel.text = travel.fromMillisToString()
			addressRouteLabel.text = travel.addressDeparture.streetInfo
			addressProvince.text = travel.addressDeparture.provinceInfo
			
			spotNameLabel.text = travel.spotDestination.nameSpot + ", " + travel.spotDestination.citySpot
			spotProvinceLabel.text = travel.spotDestination.provinceSpot + ", " + travel.spotDestination.regionSpot
			
			let passengers = travel.passengersTravel.count
			
			isPassenger = travel.passengersTravel.contains(where: {$0.idUser == currentUserID})
			
			passengerNumberLabel.text = String(passengers) + "/" + String(travel.carTravel.passengersNumber) + " posti occupati"
			
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
		
		if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
			vc.setInitialText("Look at this great picture!")
			
			vc.add(URL(string: "https://travelsharing.com/info_travel/" + travelToShowKey!))
			self.present(vc, animated: true)
		}
	}
	
	private func setupBottomToolbar(){
		let toolbarPosition = CGRect(x: 0, y: self.view.bounds.height - 44, width: self.view.bounds.width, height: 44)
		let bottomToolbar = UIToolbar(frame: toolbarPosition)
		
		bottomToolbar.barStyle = UIBarStyle.default
		bottomToolbar.isTranslucent = false
		bottomToolbar.sizeToFit()
		
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		
		var contactButton: UIBarButtonItem, mapButton: UIBarButtonItem, passengerButton: UIBarButtonItem
		
		if isOwner {
			contactButton = UIBarButtonItem(title: "Contatta passeggeri", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TravelInfoViewController.contactPassengerButtonClicked))
			mapButton = UIBarButtonItem(title: "Vai allo spot", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TravelInfoViewController.spotMapButtonClicked))
			
			bottomToolbar.setItems([contactButton, spaceButton, mapButton], animated: false)
			
		} else {
			contactButton = UIBarButtonItem(title: "Contatta guidatore", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TravelInfoViewController.contactDriverButtonClicked))
			mapButton = UIBarButtonItem(title: "Vai al punto d'incontro", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TravelInfoViewController.meetingMapButtonClicked))
			
			if isPassenger {
				passengerButton = UIBarButtonItem(title: "Rinuncia", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TravelInfoViewController.removeButtonClicked))
			} else {
				passengerButton = UIBarButtonItem(title: "Parti", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TravelInfoViewController.addButtonClicked))
			}
			
			bottomToolbar.setItems([contactButton, spaceButton, passengerButton, spaceButton, mapButton], animated: false)
		}
		
		bottomToolbar.isUserInteractionEnabled = true
		
		self.view.addSubview(bottomToolbar)
	}
	
	func contactPassengerButtonClicked(sender: UIBarButtonItem){
		print("Contact passenger button pressed")
		let list = travelToShow!.passengersTravel
		
		if list.count > 0{
			var array = [String]()
			
			for user in list{
				array.append(user.emailUser)
			}
			
			let mailComposeViewController = configuredMailComposeViewController(mailArray: array)
			
			if MFMailComposeViewController.canSendMail() {
				self.present(mailComposeViewController, animated: true, completion: nil)
			} else {
				self.showSendMailErrorAlert()
			}
		} else {
			let message = "Non ci sono passeggeri a cui inviare la mail."
			
			let alertController = UIAlertController(title: "Attenzione", message: message, preferredStyle: .alert)
			
			let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: {(action:UIAlertAction!) in
				print("Dismissing UIAlertController")
			})
			alertController.addAction(cancelAction)
			
			self.present(alertController, animated: true, completion: nil)
		}
	}
	
	func contactDriverButtonClicked(sender: UIBarButtonItem){
		print("Contact driver button pressed")
		let array = [travelToShow!.ownerTravel.emailUser]
		
		let mailComposeViewController = configuredMailComposeViewController(mailArray: array)
		
		if MFMailComposeViewController.canSendMail() {
			self.present(mailComposeViewController, animated: true, completion: nil)
		} else {
			self.showSendMailErrorAlert()
		}
	}
	
	func spotMapButtonClicked(sender: UIBarButtonItem){
		print("SpotMap button pressed")
		
		let regionDistance:CLLocationDistance = 10000
		let coordinates = travelToShow!.spotDestination.position
		let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
		let options = [
			MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
			MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
		]
		let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
		let mapItem = MKMapItem(placemark: placemark)
		mapItem.name = "Spot"
		mapItem.openInMaps(launchOptions: options)
	}
	
	func meetingMapButtonClicked(sender: UIBarButtonItem){
		print("MeetingPointMap button pressed")
		
		let latitude: CLLocationDegrees = travelToShow!.addressDeparture.latitudeInfo
		let longitude: CLLocationDegrees = travelToShow!.addressDeparture.longitudeInfo
		
		let regionDistance:CLLocationDistance = 10000
		let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
		let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
		let options = [
			MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
			MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
		]
		let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
		let mapItem = MKMapItem(placemark: placemark)
		mapItem.name = "Punto d'incontro"
		mapItem.openInMaps(launchOptions: options)
	}
	
	func addButtonClicked(sender: UIBarButtonItem){
		print("Add button pressed")
		
		let ref = Database.database().reference().child("travels").child(travelToShowKey!)
		let occupiedPlace = travelToShow!.passengersTravel.count
		let maxPlaces = travelToShow!.carTravel.passengersNumber
		
		if occupiedPlace < maxPlaces{
			if let FIRUser = Auth.auth().currentUser{
				let user = User.init(id: FIRUser.uid, name: FIRUser.displayName!, email: FIRUser.email!, notificationId: "abcdefghilmnopqrstuvz")
				
				travelToShow!.passengersTravel.append(user)
				print(travelToShow!.description)
				//ref.updateChildValues(travelToShow!.toServer())
				ref.setValue(travelToShow!.toServer())
				let message = "Sei stato aggiunto al viaggio. Inizia a preparare i bagagli!"
				
				let alertController = UIAlertController(title: "Informazioni", message: message, preferredStyle: .alert)
				
				let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: {(action:UIAlertAction!) in
					print("Dismissing UIAlertController")
				})
				alertController.addAction(cancelAction)
				
				self.present(alertController, animated: true, completion: nil)
				
				let passengers = travelToShow!.passengersTravel.count
				
				passengerNumberLabel.text = String(passengers) + "/" + String(maxPlaces) + " posti occupati"
				
				if let toolbar = self.view.subviews.last as? UIToolbar{
					toolbar.items?[2].isEnabled = false
				}
				/*ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
					if let dict = currentData.value as? [String : Any], let travel = TravelInfo.init(travelDict: dict){
						travel.passengersTravel.append(user)
						
						// Set value and report transaction success
						currentData.value = travel.toServer()
						
						return TransactionResult.success(withValue: currentData)
					}
					return TransactionResult.success(withValue: currentData)
				}) { (error, committed, snapshot) in
					if let error = error {
						print(error.localizedDescription)
						let message = "Errore nell'aggiunta al viaggio.\nRiprova tra un po'."
						
						let alertController = UIAlertController(title: "Attenzione", message: message, preferredStyle: .alert)
						
						let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: {(action:UIAlertAction!) in
							print("Dismissing UIAlertController")
						})
						alertController.addAction(cancelAction)
						
						self.present(alertController, animated: true, completion: nil)
					} else {
						//Suppongo che, se error=nil, sia andato tutto a posto
						let message = "Sei stato aggiunto al viaggio. Inizia a preparare i bagagli!"
						
						let alertController = UIAlertController(title: "Informazioni", message: message, preferredStyle: .alert)
						
						let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: {(action:UIAlertAction!) in
							print("Dismissing UIAlertController")
						})
						alertController.addAction(cancelAction)
						
						self.present(alertController, animated: true, completion: nil)
					}
				}*/
				
				
				
			} else {
				print("Error in reading currentUser")
				let message = "Errore nell'aggiunta al viaggio.\nRiprova tra un po'."
				
				let alertController = UIAlertController(title: "Attenzione", message: message, preferredStyle: .alert)
				
				let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: {(action:UIAlertAction!) in
					print("Dismissing UIAlertController")
				})
				alertController.addAction(cancelAction)
				
				self.present(alertController, animated: true, completion: nil)
			}
		} else {
			let message = "Il viaggio è già completo purtroppo.\nCerca nella Home altri viaggi!"
			
			let alertController = UIAlertController(title: "Attenzione", message: message, preferredStyle: .alert)
			
			let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: {(action:UIAlertAction!) in
				print("Dismissing UIAlertController")
			})
			alertController.addAction(cancelAction)
			
			self.present(alertController, animated: true, completion: nil)
		}
		
	}
	
	func removeButtonClicked(sender: UIBarButtonItem){
		print("Remove button pressed")
		let message = "Sei sicuro di voler rinunciare al tuo posto?"
		
		let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
		
		let cancelAction = UIAlertAction(title: "Annulla", style: .cancel) { (action:UIAlertAction!) in
			print("Dismissing UIAlertController")
		}
		alertController.addAction(cancelAction)
		
		let destroyAction = UIAlertAction(title: "Conferma", style: .destructive) { (action:UIAlertAction!) in
			self.removePassenger()
		}
		alertController.addAction(destroyAction)
		
		self.present(alertController, animated: true, completion: nil)		
	}
	
	private func removePassenger(){
		let ref = Database.database().reference().child("travels").child(travelToShowKey!)
		
		if let FIRUser = Auth.auth().currentUser{
			let user = travelToShow!.passengersTravel.first(where: {$0.idUser == FIRUser.uid})
			//print("User to remove: \(user?.description)")			
			
			let index = travelToShow!.passengersTravel.index(of: user!)
			print("Index: \(index!)")
			travelToShow!.passengersTravel.remove(at: index!)
			
			//print(travelToShow!.description)
			//ref.updateChildValues(travelToShow!.toServer())
			ref.setValue(travelToShow!.toServer())
			
			let passengers = travelToShow!.passengersTravel.count
			
			passengerNumberLabel.text = String(passengers) + "/" + String(travelToShow!.carTravel.passengersNumber) + " posti occupati"
			
			if let toolbar = self.view.subviews.last as? UIToolbar{
				toolbar.items?[2].isEnabled = false
			}
			
			/*ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
			if let dict = currentData.value as? [String : Any], let travel = TravelInfo.init(travelDict: dict){
			travel.passengersTravel.append(user)
			
			// Set value and report transaction success
			currentData.value = travel.toServer()
			
			return TransactionResult.success(withValue: currentData)
			}
			return TransactionResult.success(withValue: currentData)
			}) { (error, committed, snapshot) in
			if let error = error {
			print(error.localizedDescription)
			let message = "Errore nell'aggiunta al viaggio.\nRiprova tra un po'."
			
			let alertController = UIAlertController(title: "Attenzione", message: message, preferredStyle: .alert)
			
			let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: {(action:UIAlertAction!) in
			print("Dismissing UIAlertController")
			})
			alertController.addAction(cancelAction)
			
			self.present(alertController, animated: true, completion: nil)
			} else {
			//Suppongo che, se error=nil, sia andato tutto a posto
			let message = "Sei stato aggiunto al viaggio. Inizia a preparare i bagagli!"
			
			let alertController = UIAlertController(title: "Informazioni", message: message, preferredStyle: .alert)
			
			let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: {(action:UIAlertAction!) in
			print("Dismissing UIAlertController")
			})
			alertController.addAction(cancelAction)
			
			self.present(alertController, animated: true, completion: nil)
			}
			}*/
		} else {
			print("Error in reading currentUser")
			let message = "Errore nella rimozione dal viaggio.\nRiprova tra un po'."
			
			let alertController = UIAlertController(title: "Attenzione", message: message, preferredStyle: .alert)
			
			let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: {(action:UIAlertAction!) in
				print("Dismissing UIAlertController")
			})
			alertController.addAction(cancelAction)
			
			self.present(alertController, animated: true, completion: nil)
		}
	}
	
	func configuredMailComposeViewController(mailArray: [String]) -> MFMailComposeViewController {
		let mailComposerVC = MFMailComposeViewController()
		mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
		
		mailComposerVC.setToRecipients(mailArray)
		mailComposerVC.setSubject("Comunicazione")
		//mailComposerVC.setMessageBody("Prova", isHTML: false)
		
		return mailComposerVC
	}
	
	func showSendMailErrorAlert() {
		let message = "Errore nell'invio della mail.\nControlla di avere una connessione attiva."
		
		let alertController = UIAlertController(title: "Attenzione", message: message, preferredStyle: .alert)
		
		let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: {(action:UIAlertAction!) in
			print("Dismissing UIAlertController")
		})
		alertController.addAction(cancelAction)
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	// MARK: MFMailComposeViewControllerDelegate
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
		controller.dismiss(animated: true, completion: nil)
		
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
