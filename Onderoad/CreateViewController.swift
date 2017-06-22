//
//  CreateViewController.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 19/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit
import GooglePlaces

class CreateViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
	
	//MARK: Properties
	
	var travel: TravelInfo?
	
	var travelAddress: AddressInfo?
	
	var dateTimeMillis: Int64 = 0
	
	var locationManager: CLLocationManager?
	
	//MARK: IBOutlets
	
	@IBOutlet weak var dateTimeTextField: UITextField!
	
	@IBOutlet weak var travelNoteTextView: UITextView!
	
	@IBOutlet weak var autocompleteTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupDateTimePicker()
		
		travelNoteTextView.delegate = self
		
		locationManager = CLLocationManager()
		locationManager?.delegate = self
		locationManager?.requestWhenInUseAuthorization()
		locationManager?.startUpdatingLocation()
		
		/*let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)*/
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
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

	//MARK: DatePicker Methods
	
	func setupDateTimePicker() {
		let datePickerView = UIDatePicker()
		
		datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
		datePickerView.minuteInterval = 5
		
		let gregorian: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
		let currentDate: Date = Date()
		let minDate: Date = gregorian.date(byAdding: Calendar.Component.hour, value: +12, to: currentDate)!
		
		let maxDate: Date = gregorian.date(byAdding: Calendar.Component.day, value: +7, to: currentDate)!
		
		datePickerView.minimumDate = minDate
		datePickerView.maximumDate = maxDate
		
		datePickerView.locale = Locale.current
		
		datePickerView.addTarget(self, action: #selector(CreateViewController.dateTimePickerValueChanged), for: UIControlEvents.valueChanged)
		
		let toolbar = UIToolbar()
		toolbar.barStyle = UIBarStyle.default
		toolbar.isTranslucent = true
		toolbar.sizeToFit()
		
		let doneButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateViewController.toolbarButtonClicked))
		let cancelButton = UIBarButtonItem(title: "Annulla", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateViewController.toolbarButtonClicked))
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		
		toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
		toolbar.isUserInteractionEnabled = true
		
		dateTimeTextField.inputView = datePickerView
		dateTimeTextField.inputAccessoryView = toolbar
	}
	
	func dateTimePickerValueChanged(sender: UIDatePicker){
		let locale = Locale.current
		
		let dateFormatter = DateFormatter()
		
		dateFormatter.dateStyle = DateFormatter.Style.long
		
		dateFormatter.timeStyle = DateFormatter.Style.short
		
		dateFormatter.locale = locale
		
		let selectedDateString = dateFormatter.string(from: sender.date)
			
		dateTimeTextField.text = selectedDateString
		
		dateTimeMillis = Int64((sender.date.timeIntervalSince1970 * 1000.0).rounded())
		
		print("Date: \(selectedDateString)\nDateTime in millis:\(dateTimeMillis)")
	}
	
	func toolbarButtonClicked(sender: UIBarButtonItem){
		let buttonText = sender.title ?? ""
		
		switch buttonText {
		case "Ok":
			print("Ok button pressed")
		case "Annulla":
			print("Annulla button pressed")
		default:
			print("Error! Button not recognized!")
		}
		
		dateTimeTextField.resignFirstResponder()
	}
	
	//MARK: Keyboard Manager Method
	
	func adjustForKeyboard(notification: Notification) {
		let userInfo = notification.userInfo!
		
		let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
		
		if notification.name == Notification.Name.UIKeyboardWillHide {
			travelNoteTextView.contentInset = UIEdgeInsets.zero
		} else {
			travelNoteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
		}
		
		travelNoteTextView.scrollIndicatorInsets = travelNoteTextView.contentInset
		
		let selectedRange = travelNoteTextView.selectedRange
		travelNoteTextView.scrollRangeToVisible(selectedRange)
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
		for component in place.addressComponents!{
			print("Type: \(component.type)\nName: \(component.name)")
		}
		
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




