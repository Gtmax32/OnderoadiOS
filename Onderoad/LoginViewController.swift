//
//  LoginViewController.swift
//  Onderoad
//
//  Created by Giuseppe Trentadue on 03/07/17.
//  Copyright © 2017 Giuseppe Fabio Trentadue. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
	
	var ref : DatabaseReference = Database.database().reference()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		print("In LoginViewController")
		
		let loginButton = FBSDKLoginButton()
		loginButton.center = self.view.center
		self.view.addSubview(loginButton)
		
		loginButton.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
		if error != nil{
			print(error)
			return
		}
		
		guard let accessToken = FBSDKAccessToken.current() else {
			print("Failed to get access token")
			return
		}
		
		let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
		
		// Perform login by calling Firebase APIs
		Auth.auth().signIn(with: credential, completion: { (user, error) in
			if let error = error {
				print("Login error: \(error.localizedDescription)")
				let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
				let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
				alertController.addAction(okayAction)
				self.present(alertController, animated: true, completion: nil)
				
				return
			}
			
			if(user != nil){
				print("User: \(user!)")
				
				let currentUser = User.init(id: user!.uid, name: user!.displayName!, email: user!.email!, notificationId: "abcdefghilmnopqrstuvz")
				
				self.ref.child("users").child(user!.uid).setValue(currentUser.toServer())
				
				let viewController = self.storyboard!.instantiateViewController(withIdentifier: "MainViewController") as UIViewController
				self.present(viewController, animated: true, completion: nil)
			}
		})
	}
	
	func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
		print("Log out from Facebook")
		do {
			try Auth.auth().signOut()
		} catch let signOutError as NSError {
			print ("Error signing out: %@", signOutError)
		}
	}
	
	/*
	// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
}
