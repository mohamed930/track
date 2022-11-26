//
//  updateViewController.swift
//  MultiTracking
//
//  Created by Mohamed Ali on 26/11/2022.
//

import UIKit
import RxSwift
import FirebaseDatabase

class updateViewController: UIViewController {
    
    @IBOutlet weak var latiTextFeild:UITextField!
    @IBOutlet weak var longTextField:UITextField!
    
    @IBOutlet weak var loginButton:UIButton!
    
    let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        SubscribeToUpdateButtonAction()
    }
    
    func SubscribeToUpdateButtonAction() {
        loginButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { _ in
            
            // update bus 1
            
            let value = ["lati": Double(self.latiTextFeild.text!)!, "long": Double(self.longTextField.text!)!] as! [String: Any]
            
            Database.database().reference()
                .child("points").child("points").child("vehicals").child("0").child("location").updateChildValues(value){
                       (error:Error?, ref:DatabaseReference) in
                       if error != nil {
                         print("Error")
                       }
                       else {
                           let alert = UIAlertController(title: "Success", message: "updated Successfull", preferredStyle: .alert)
                           alert.addAction(UIAlertAction(title: "Ok", style: .default))
                           
                           self.present(alert, animated: true)
                       }
                   }
            
        }).disposed(by: disposebag)
    }
}
