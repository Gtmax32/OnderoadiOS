//
//  CreateViewController.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 19/06/17.
//  Copyright © 2017 Giuseppe Trentadue. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {
	
	//MARK: Properties
	
	var travel: TravelInfo?
	
	@IBOutlet weak var dateTimePicker: UITextField!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
	
	//MARK: Pirvate Methods
	
	private func setupDateTimePicker(){
		
	}
	
	private func dateTimePickerValueChanged(sender: UIDatePicker){
	
	}

}
