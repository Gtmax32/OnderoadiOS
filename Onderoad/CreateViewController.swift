//
//  CreateViewController.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 19/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit
import GooglePlaces

class CreateViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
	
	//MARK: Properties
	
	var travel: TravelInfo?
	
	var travelAddress: AddressInfo?
	
	var dateTimeMillis: Int64 = 0
	
	var locationManager: CLLocationManager?
	
	let regionPickerSource = ["Abbruzzo","Basilicata","Calabria","Lombardia","Puglia"]
	
	let namePickerSource = ["Bari","Barletta-Andria-Trani","Brindisi","Foggia","Lecce","Taranto"]
	
	var passengerNumber = 4
	
	var isOutbound = false
	
	var boardNumber = 4
	
	let supportTypePickerSource = ["Barre porta pacchi", "Soft rack", "Dentro l'auto"]
	
	//MARK: UI Reference
	
	var dateTimePickerView: UIDatePicker?
	
	var spotRegionPicker: UIPickerView?
	
	var spotNamePicker: UIPickerView?
	
	var carSupportTypePicker: UIPickerView?
	
	//MARK: IBOutlets
	
	@IBOutlet weak var mainScrollView: UIScrollView!
	
	@IBOutlet weak var navigationCancelButton: UIBarButtonItem!
	
	@IBOutlet weak var navigationSaveButton: UIBarButtonItem!
	
	@IBOutlet weak var autocompleteTextField: UITextField!
	
	@IBOutlet weak var dateTimeTextField: UITextField!
	
	@IBOutlet weak var spotRegionTextField: UITextField!
	
	@IBOutlet weak var spotNameTextField: UITextField!
	
	@IBOutlet weak var passengerNumberSegmentedControl: UISegmentedControl!
	
	@IBOutlet weak var isOutboundSwitch: UISwitch!
	
	@IBOutlet weak var boardNumberSegmentedControl: UISegmentedControl!
	
	@IBOutlet weak var carSupportTypeTextField: UITextField!
	
	@IBOutlet weak var travelNoteTextView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupDateTimePicker()
		setupRegionNamePicker()
		setupSupportTypePicker()
		
		travelNoteTextView.delegate = self
		
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
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		super.prepare(for: segue, sender: sender)
		
		guard let button = sender as? UIBarButtonItem, button == navigationSaveButton else {
			print("Errore nella pressione del SaveButton")
			
			return
		}
    }
	
	//MARK: Action Methods
	
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
		passengerNumber = sender.selectedSegmentIndex
	}
	
	@IBAction func outboundSwitchValueChanged(_ sender: UISwitch) {
		isOutbound = sender.isOn
	}
	
	
	@IBAction func boardSCIndexChanged(_ sender: UISegmentedControl) {
		boardNumber = sender.selectedSegmentIndex
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
		
		dateFormatter.locale = locale
		
		let gregorian: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
		
		let selectedDate: Date = gregorian.date(byAdding: .hour, value: +2, to: (dateTimePickerView?.date)!)!
		
		let selectedDateString = dateFormatter.string(from: (dateTimePickerView?.date)!)
			
		dateTimeTextField.text = selectedDateString
		
		dateTimeMillis = Int64((selectedDate.timeIntervalSince1970 * 1000.0).rounded())
		
		print("Date: \(selectedDateString)\nDateTime in millis:\(dateTimeMillis)")
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
	}
	
	func regionPickerToolbarButtonClicked(sender: UIBarButtonItem){
		let buttonText = sender.title ?? ""
		
		if (buttonText == "Ok"){
			spotRegionTextField.text = regionPickerSource[(spotRegionPicker?.selectedRow(inComponent: 0))!]
		}
		
		spotRegionTextField.resignFirstResponder()
	}
	
	func namePickerToolbarButtonClicked(sender: UIBarButtonItem){
		let buttonText = sender.title ?? ""
		
		if (buttonText == "Ok"){
			spotNameTextField.text = namePickerSource[(spotNamePicker?.selectedRow(inComponent: 0))!]
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
	
	//MARK: UIPickerViewDataSource and UIPickerViewDelegate protocol Methods
	
	func numberOfComponents(in : UIPickerView) -> Int{
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
		if pickerView == spotRegionPicker {
			return regionPickerSource.count
		} else if pickerView == spotNamePicker{
			return namePickerSource.count
		} else if pickerView == carSupportTypePicker{
			return supportTypePickerSource.count
		}
		
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		if pickerView == spotRegionPicker {
			return regionPickerSource[row]
		} else if pickerView == spotNamePicker{
			return namePickerSource[row]
		} else if pickerView == carSupportTypePicker{
			return supportTypePickerSource[row]
		}
		
		return ""
	}
	
	//MARK: Keyboard Manager Method
	
	func keyboardWillShow(notification:NSNotification){
		
		var userInfo = notification.userInfo!
		var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		keyboardFrame = self.view.convert(keyboardFrame, from: nil)
		
		var contentInset:UIEdgeInsets = mainScrollView.contentInset
		contentInset.bottom = keyboardFrame.size.height
		mainScrollView.contentInset = contentInset
	}
	
	func keyboardWillHide(notification:NSNotification){
		let contentInset:UIEdgeInsets = UIEdgeInsets.zero
		mainScrollView.contentInset = contentInset
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		textView.resignFirstResponder()
	}
}

//MARK: Google Places AutoComplete Manager

extension CreateViewController: GMSAutocompleteViewControllerDelegate {
	
	// Handle the user's selection.
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
		print("Place name: \(place.name)")
		print("Place address: \(place.formattedAddress ?? "")")
		print("Place coordinate: latitude-\(place.coordinate.latitude) longitude-\(place.coordinate.longitude) ")
		print("Place addressComponents:\n")
		
		let isRoute = place.addressComponents?.contains(where: {$0.type == "route"})
		
		if (isRoute)! {
			autocompleteTextField.text = place.formattedAddress ?? "Errore nella selezione, riprova!"
			
			let provinceComponents = place.addressComponents?.first(where: {$0.type == "administrative_area_level_2"})
			
			travelAddress = AddressInfo.init(street: place.formattedAddress! , province: (provinceComponents?.name)!, longitude: place.coordinate.longitude, latitude: place.coordinate.latitude)
			
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




