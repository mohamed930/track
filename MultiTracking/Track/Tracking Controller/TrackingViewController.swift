//
//  ViewController.swift
//  MultiTracking
//
//  Created by Mohamed Ali on 26/11/2022.
//

import UIKit
import RxSwift

class TrackingViewController: UIViewController {
    
    @IBOutlet weak var googleMapView:UIView!
    
    let trackingviewmodel = trackingViewModel()
    let disposebag = DisposeBag()
    
    var firebase = Firebase()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SubscribeToPointResponse()
        LoadData()
    }

    func SubscribeToPointResponse() {
        trackingviewmodel.pointsBehaviourObserval.subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            
            if response.1 == "old" {
                self.trackingviewmodel.updateMap(view: self.googleMapView)
            }
            else {
                self.trackingviewmodel.ShowMap(view: self.googleMapView)
            }
        }).disposed(by: disposebag)
    }
    
    func LoadData() {
        trackingviewmodel.SetPointOperation()
    }

}

