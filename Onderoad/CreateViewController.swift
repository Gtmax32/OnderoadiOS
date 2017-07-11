//
//  CreateViewController.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 19/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit
import GooglePlaces
import FirebaseDatabase

class CreateViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
	
	//MARK: Properties
	
	var travel: TravelInfo?
	
	var travelAddress: AddressInfo?
	
	var regionFromSpot: String?
	
	var nameFromSpot: String?
	
	var dateTimeMillis: Int64 = 0
	
	var locationManager: CLLocationManager?
	
	let regionPickerSource = Array(RegionSpotDict.DICT.keys).sorted()
	
	var namePickerSource: [String]?
	
	var passengerNumber = 4
	
	var isOutbound = false
	
	var boardNumber = 4
	
	let supportTypePickerSource = ["Barre porta pacchi", "Soft rack", "Dentro l'auto"]
	
	var selectedRegionSpots: [SpotInfo]?
	
	var selectedSpot: SpotInfo?
	
	//MARK: UI Reference
	
	var dateTimePickerView: UIDatePicker?
	
	var spotRegionPicker: UIPickerView?
	
	var spotNamePicker: UIPickerView?
	
	var carSupportTypePicker: UIPickerView?
	
	var textViewOffset: CGFloat = 0
	
	//MARK: IBOutlets
	
	@IBOutlet weak var mainScrollView: UIScrollView!
	
	@IBOutlet weak var navigationCancelButton: UIBarButtonItem!
	
	@IBOutlet weak var navigationSaveButton: UIBarButtonItem!
	
	@IBOutlet weak var autocompleteTextField: UITextField!
	
	@IBOutlet weak var dateTimeTextField: UITextField!
	
	@IBOutlet weak var spotRegionTextField: UITextField!
	
	@IBOutlet weak var spotNameTextField: UITextField!
	
	@IBOutlet weak var travelPriceStepper: PriceStepper!
	
	@IBOutlet weak var passengerNumberSegmentedControl: UISegmentedControl!
	
	@IBOutlet weak var isOutboundSwitch: UISwitch!
	
	@IBOutlet weak var boardNumberSegmentedControl: UISegmentedControl!
	
	@IBOutlet weak var carSupportTypeTextField: UITextField!
	
	@IBOutlet weak var travelNoteTextView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//self.hideKeyboardWhenTappedAround()
		
		print("In CreateViewController - regionSpot: \(regionFromSpot ?? "") nameSpot: \(nameFromSpot ?? "")")
		
		setupDateTimePicker()
		setupRegionNamePicker()
		setupSupportTypePicker()
		setupNoteTextView()
		
		locationManager = CLLocationManager()
		locationManager?.delegate = self
		locationManager?.requestWhenInUseAuthorization()
		locationManager?.startUpdatingLocation()
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    //MARK: Action Methods
	
	@IBAction func prepareForSave(_ sender: UIBarButtonItem) {
		print("In prepareForSave")
		
		var modMessage = [String]()
		
		modMessage = checkCanCreateTravel()
		
		if modMessage.count > 0 {
			var message = "Non è possibile salvare il viaggio perchè i seguenti campi sono vuoti:"
			
			for errorString in modMessage {
				message.append("\n - \(errorString)")
			}
			
			message.append("\nAssicurati di inserire tutti i dati prima di salvare.")
			
			let alertController = UIAlertController(title: "Attenzione", message: message, preferredStyle: .alert)
			
			let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: {(action:UIAlertAction!) in
				print("Dismissing UIAlertController")
			})
			alertController.addAction(cancelAction)
			
			self.present(alertController, animated: true, completion: nil)
		} else {
			print("Preparing travel to send")
			
			let car = CarInfo.init(passengers: passengerNumber, surfboards: boardNumber, type: carSupportTypeTextField.text!)
			if let currentUser = Auth.auth().currentUser {
				let user = User.init(id: currentUser.uid, name: currentUser.displayName!, email: currentUser.email!, notificationId: "abcdefgh")
				
				travel = TravelInfo.init(address: travelAddress!, dataTime: dateTimeMillis, destination: selectedSpot!, price: travelPriceStepper.value, car: car, outbounded: isOutbound, note: travelNoteTextView.text, owner: user, passengersList: [User]())
				
				let ref : DatabaseReference = Database.database().reference().child("travels")
				ref.childByAutoId().setValue(travel!.toServer())
				
				print(travel!.description )
				print(travel!.fromMillisToString())
				
				self.performSegue(withIdentifier: "unwindSegueToMyTravel", sender: self)
			}			
		}
	}
	
	@IBAction func cancelCreation(_ sender: UIBarButtonItem) {
		let message = "Sicuro di voler annullare la creazione del viaggio?\nI dati inseriti non verranno salvati."
		
		let alertController = UIAlertController(title: "Attenzione", message: message, preferredStyle: .alert)
		
		let noAction = UIAlertAction(title: "No", style: .cancel, handler: {(action:UIAlertAction!) in
			print("Dismissing UIAlertController")
		})
		
		let yesAction = UIAlertAction(title: "Si", style: .destructive, handler: {(action:UIAlertAction!) in
			print("Dismissing CreateViewController")
			self.dismiss(animated: true, completion: nil)
		})
		
		alertController.addAction(yesAction)
		alertController.addAction(noAction)
		
		self.present(alertController, animated: true, completion: nil)
		
	}
	
	@IBAction func autocompleteTextFieldClicked(_ sender: UITextField) {
		//Creo un GMSCoordinateBounds da assegnare al GMSAutocompleteViewController
		
		//print("Current latitude: \(locationManager?.location!.coordinate.latitude)\nCurrent Longitude: \(locationManager?.location!.coordinate.longitude)")
		
		let lat = locationManager?.location!.coordinate.latitude
		let long = locationManager?.location!.coordinate.longitude
		let offset = 200.0 / 1000.0;
		let latMax = lat! + offset;
		let latMin = lat! - offset;
		let lngOffset = offset * cos(lat! * Double.pi / 200.0);
		let lngMax = long! + lngOffset;
		let lngMin = long! - lngOffset;
		let initialLocation = CLLocationCoordinate2D(latitude: latMax, longitude: lngMax)
		let otherLocation = CLLocationCoordinate2D(latitude: latMin, longitude: lngMin)
		let bounds = GMSCoordinateBounds(coordinate: initialLocation, coordinate: otherLocation)
		
		//Creo il GMSAutocompleteViewController
		
		let autocompleteController = GMSAutocompleteViewController()
		autocompleteController.autocompleteBounds = bounds
		autocompleteController.delegate = self
		present(autocompleteController, animated: true, completion: nil)
	}
	
	@IBAction func passengerSCIndexChanged(_ sender: UISegmentedControl) {
		passengerNumber = sender.selectedSegmentIndex + 1
	}
	
	@IBAction func outboundSwitchValueChanged(_ sender: UISwitch) {
		isOutbound = sender.isOn
	}
	
	@IBAction func boardSCIndexChanged(_ sender: UISegmentedControl) {
		boardNumber = sender.selectedSegmentIndex + 1
	}

	//MARK: DatePicker Methods
	
	func setupDateTimePicker() {
		dateTimePickerView = UIDatePicker()
		
		dateTimePickerView?.datePickerMode = UIDatePickerMode.dateAndTime
		dateTimePickerView?.minuteInterval = 5
		
		let gregorian: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
		let currentDate: Date = Date()
		let minDate: Date = gregorian.date(byAdding: Calendar.Component.hour, value: +12, to: currentDate)!
		
		let maxDate: Date = gregorian.date(byAdding: Calendar.Component.day, value: +7, to: currentDate)!
		
		dateTimePickerView?.minimumDate = minDate
		dateTimePickerView?.maximumDate = maxDate
		
		dateTimePickerView?.locale = Locale.current
		dateTimePickerView?.timeZone = TimeZone.current
		
		let toolbar = UIToolbar()
		toolbar.barStyle = UIBarStyle.default
		toolbar.isTranslucent = true
		toolbar.sizeToFit()
		
		let doneButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateViewController.datePickerToolbarButtonClicked))
		let cancelButton = UIBarButtonItem(title: "Annulla", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateViewController.datePickerToolbarButtonClicked))
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		
		toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
		toolbar.isUserInteractionEnabled = true
		
		dateTimeTextField.inputView = dateTimePickerView
		dateTimeTextField.inputAccessoryView = toolbar
	}
	
	func dateTimePickerValueChanged(){
		let locale = Locale.current
		
		let dateFormatter = DateFormatter()
		
		dateFormatter.dateStyle = DateFormatter.Style.long
		
		dateFormatter.timeStyle = DateFormatter.Style.short
		
		dateFormatter.timeZone = TimeZone.current
		
		dateFormatter.locale = locale
		
		let gregorian: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
		
		let selectedDate: Date = gregorian.date(byAdding: .hour, value: +2, to: dateTimePickerView!.date)!
		
		let selectedDateString = dateFormatter.string(from: dateTimePickerView!.date)
			
		dateTimeTextField.text = selectedDateString
		
		dateTimeMillis = Int64((selectedDate.timeIntervalSince1970 * 1000.0).rounded())
		
		//print("Date: \(selectedDateString)\nDateTime in millis:\(dateTimeMillis)")
	}
	
	func datePickerToolbarButtonClicked(sender: UIBarButtonItem){
		let buttonText = sender.title ?? ""
		
		if (buttonText == "Ok"){
			dateTimePickerValueChanged()
		}
		
		dateTimeTextField.resignFirstResponder()
	}
	
	//MARK: Spot Region-Province Picker Methods
	
	func setupRegionNamePicker(){
		spotRegionPicker = UIPickerView()
		spotRegionPicker?.dataSource = self
		spotRegionPicker?.delegate = self
		
		spotNamePicker = UIPickerView()
		spotNamePicker?.dataSource = self
		spotNamePicker?.delegate = self
		
		let regionToolbar = UIToolbar()
		regionToolbar.barStyle = UIBarStyle.default
		regionToolbar.isTranslucent = true
		regionToolbar.sizeToFit()
		
		let regionDoneButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateViewController.regionPickerToolbarButtonClicked))
		let regionCancelButton = UIBarButtonItem(title: "Annulla", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateViewController.regionPickerToolbarButtonClicked))
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		
		regionToolbar.setItems([regionCancelButton, spaceButton, regionDoneButton], animated: false)
		regionToolbar.isUserInteractionEnabled = true
		
		spotRegionTextField.inputView = spotRegionPicker
		spotRegionTextField.inputAccessoryView = regionToolbar
		
		let nameToolbar = UIToolbar()
		nameToolbar.barStyle = UIBarStyle.default
		nameToolbar.isTranslucent = true
		nameToolbar.sizeToFit()
		
		let nameDoneButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateViewController.namePickerToolbarButtonClicked))
		let nameCancelButton = UIBarButtonItem(title: "Annulla", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateViewController.namePickerToolbarButtonClicked))
		
		nameToolbar.setItems([nameCancelButton, spaceButton, nameDoneButton], animated: false)
		nameToolbar.isUserInteractionEnabled = true
		
		spotNameTextField.inputView = spotNamePicker
		spotNameTextField.inputAccessoryView = nameToolbar
		
		if let region = regionFromSpot, let name = nameFromSpot{
			spotRegionTextField.text = region
			spotNameTextField.text = name
			
			namePickerSource = RegionSpotDict.getSpotNameFromKey(key: region)
			selectedRegionSpots = Array(RegionSpotDict.DICT[region]!)
			
			if let index = namePickerSource?.index(where: {$0 == name}) {
				selectedSpot = selectedRegionSpots?[index]
				print("Spot from CreateVC: " + selectedSpot!.description)
			}
			else {
				fatalError("Error in retrieving spot, from region and name!")
			}
		}
	}
	
	func regionPickerToolbarButtonClicked(sender: UIBarButtonItem){
		let buttonText = sender.title ?? ""
		
		if (buttonText == "Ok"){
			let selectedRegionIndex = spotRegionPicker!.selectedRow(inComponent: 0)
			spotRegionTextField.text = regionPickerSource[selectedRegionIndex]
			
			let key = regionPickerSource[selectedRegionIndex]
			
			namePickerSource = RegionSpotDict.getSpotNameFromKey(key: key)
			selectedRegionSpots = Array(RegionSpotDict.DICT[key]!)
			
			spotNameTextField.text = ""
		}
		
		spotRegionTextField.resignFirstResponder()
	}
	
	func namePickerToolbarButtonClicked(sender: UIBarButtonItem){
		let buttonText = sender.title ?? ""
		
		if (buttonText == "Ok"){
			let spotIndex = spotNamePicker!.selectedRow(inComponent: 0)
			
			spotNameTextField.text = namePickerSource![spotIndex]
			
			if selectedRegionSpots != nil {
				selectedSpot = selectedRegionSpots![spotIndex]
			}
		}
		
		spotNameTextField.resignFirstResponder()
	}
	
	//MARK: Car Support Picker Methods
	
	func setupSupportTypePicker(){
		carSupportTypePicker = UIPickerView()
		carSupportTypePicker?.dataSource = self
		carSupportTypePicker?.delegate = self
		
		let toolbar = UIToolbar()
		toolbar.barStyle = UIBarStyle.default
		toolbar.isTranslucent = true
		toolbar.sizeToFit()
		
		let doneButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateViewController.supportTypePickerToolbarButtonClicked))
		let cancelButton = UIBarButtonItem(title: "Annulla", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateViewController.supportTypePickerToolbarButtonClicked))
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		
		toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
		toolbar.isUserInteractionEnabled = true
		
		carSupportTypeTextField.inputView = carSupportTypePicker
		carSupportTypeTextField.inputAccessoryView = toolbar

	}
	
	func supportTypePickerToolbarButtonClicked(sender: UIBarButtonItem){
		let buttonText = sender.title ?? ""
		
		if (buttonText == "Ok"){
			carSupportTypeTextField.text = supportTypePickerSource[(carSupportTypePicker?.selectedRow(inComponent: 0))!]
		}
		
		carSupportTypeTextField.resignFirstResponder()
	}
	
	//MARK: Note TextView Methods
	
	func setupNoteTextView(){
		travelNoteTextView.delegate = self
		
		let toolbar = UIToolbar()
		toolbar.barStyle = UIBarStyle.default
		toolbar.isTranslucent = true
		toolbar.sizeToFit()
		
		let doneButton = UIBarButtonItem(title: "Fine", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateViewController.noteTextViewToolbarButtonClicked))
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		
		toolbar.setItems([spaceButton, doneButton], animated: false)
		toolbar.isUserInteractionEnabled = true
		
		travelNoteTextView.inputAccessoryView = toolbar
	}
	
	func noteTextViewToolbarButtonClicked(sender: UIBarButtonItem){
		let buttonText = sender.title ?? ""
		
		if (buttonText == "Fine"){
			travelNoteTextView.resignFirstResponder()
		}
	}
	
	//MARK: UIPickerViewDataSource and UIPickerViewDelegate protocol Methods
	
	func numberOfComponents(in : UIPickerView) -> Int{
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
		if pickerView == spotRegionPicker {
			return regionPickerSource.count
		} else if pickerView == spotNamePicker{
			return namePickerSource!.count
		} else if pickerView == carSupportTypePicker{
			return supportTypePickerSource.count
		}
		
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		if pickerView == spotRegionPicker {
			return regionPickerSource[row]
		} else if pickerView == spotNamePicker{
			return namePickerSource![row]
		} else if pickerView == carSupportTypePicker{
			return supportTypePickerSource[row]
		}
		
		return ""
	}
	
	//MARK: MARK: Check method for saving Travel
	
	private func checkCanCreateTravel() -> [String]{
		var emptyTextFieldArray = [String]()
		
		if autocompleteTextField.text == "" {
			emptyTextFieldArray.append("Indirizzo di partenza")
		}
		
		if (self.dateTimeMillis == 0) {
			emptyTextFieldArray.append("Data ed ora di partenza")
		}
		
		if spotRegionTextField.text == "" {
			emptyTextFieldArray.append("Regione dello Spot")
		}
		
		if spotNameTextField.text == "" {
			emptyTextFieldArray.append("Lo Spot nella regione scelta")
		}
		
		if (travelPriceStepper.value == 0) {
			emptyTextFieldArray.append("Il prezzo del viaggio")
		}
		
		if carSupportTypeTextField.text == "" {
			emptyTextFieldArray.append("Il supporto per le tavole")
		}
		
		return emptyTextFieldArray
		
	}
	
	//MARK: Keyboard Manager Methods
	
	func keyboardWillShow(notification:NSNotification){
		var userInfo = notification.userInfo!
		var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		keyboardFrame = self.view.convert(keyboardFrame, from: nil)
		
		var contentInset:UIEdgeInsets = mainScrollView.contentInset
		contentInset.bottom = keyboardFrame.size.height
		mainScrollView.contentInset = contentInset
		mainScrollView.scrollIndicatorInsets = contentInset
		
		//print("In keyboardWillShow: \(keyboardFrame.size.height)")
	}
	
	func keyboardWillHide(notification:NSNotification){
		//print("In keyboardWillHide")
		let contentInset:UIEdgeInsets = UIEdgeInsets.zero
		mainScrollView.contentInset = contentInset
		mainScrollView.scrollIndicatorInsets = contentInset
	}
	
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		textViewOffset = mainScrollView.frame.height
		let point = CGPoint.init(x: 0, y: textViewOffset - 190)
		
		mainScrollView.setContentOffset(point, animated: true)
		
		//print("In textViewShouldBeginEditing: \(textViewOffset)")
		
		return true
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		//print("In textViewDidEndEditing")
		
		textViewOffset = 0
		
		textView.resignFirstResponder()
	}
}

/*extension CreateViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
}*/

//MARK: Google Places AutoComplete Manager

extension CreateViewController: GMSAutocompleteViewControllerDelegate {
	
	// Handle the user's selection.
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
		print("Place name: \(place.name)")
		print("Place address: \(place.formattedAddress ?? "")")
		print("Place coordinate: latitude-\(place.coordinate.latitude) longitude-\(place.coordinate.longitude) ")
		print("Place addressComponents:\n")
		
		for component in place.addressComponents! {
			print("Type: \(component.type) Name: \(component.name)")
		}
		
		let isValid = place.addressComponents!.contains(where: {$0.type == "route" || $0.type == "neighborhood"})
		
		if isValid {
			autocompleteTextField.text = place.formattedAddress ?? "Errore nella selezione, riprova!"
			
			let provinceComponents = place.addressComponents?.first(where: {$0.type == "administrative_area_level_2"})
			
			travelAddress = AddressInfo.init(street: place.formattedAddress! , province: RawProvinceDict.DICT[provinceComponents!.name]!, longitude: place.coordinate.longitude, latitude: place.coordinate.latitude)
			
			print(travelAddress?.description ?? "")
			
			dismiss(animated: true, completion: nil)
		}
		else{
			let alertController = UIAlertController(title: "Attenzione", message: "Non è possibile selezionare un'intera città come punto di ritrovo.\nScegli piuttosto una via o un monumento.", preferredStyle: .alert)
			
			let doneAction = UIAlertAction(title: "Ok", style: .cancel)
			alertController.addAction(doneAction)
			
			viewController.present(alertController, animated: true, completion: nil)
		}
	}
	
	func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
		// TODO: handle the error.
		print("Error: ", error.localizedDescription)
	}
	
	// User canceled the operation.
	func wasCancelled(_ viewController: GMSAutocompleteViewController) {
		dismiss(animated: true, completion: nil)
	}
	
	// Turn the network activity indicator on and off again.
	func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}
	
	func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}
	
}




