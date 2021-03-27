//
//  ViewController.swift
//  EnergySaver
//
//  Created by Jatin on 22/03/21.
//

import UIKit
import Firebase
import LinearProgressBar
import AZDialogView
class ViewController: UIViewController {

    var batteryLevel: Float { UIDevice.current.batteryLevel }
    var batteryState: UIDevice.BatteryState { UIDevice.current.batteryState }

    
    var batString: String {
        return "Charging \(Int(batteryLevel * 100))%"
    }
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var progressBar: LinearProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.isBatteryMonitoringEnabled = true
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child("123123").setValue(["username": "Jatin"])

//        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryStateDidChangeNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)

        chargeLabel.text = batString
        progressBar.progressValue = CGFloat(batteryLevel * 100) 
    }

    @objc func batteryStateDidChange(_ notification: Notification) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        switch batteryState {
        case .unplugged, .unknown, .charging:
            print("not charging")
//            ref.setValue(["charging_status": batteryState.rawValue])
        case .full:
            print("charging or full")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                ref.setValue(["charging_status": 3])
            }
            let dialog = AZDialogViewController(title: "Device charged", message: "Diconnecting charger")
            dialog.titleColor = .black

            //set the message color
            dialog.messageColor = .black

            dialog.addAction(AZDialogAction(title: "OK") { (dialog) -> (Void) in
                    //add your actions here.
                    dialog.dismiss()
            })
            self.present(dialog, animated: false, completion: nil)
            
            
        @unknown default:
            fatalError("")
        }
    }
    @IBAction func aaaa(_ sender: Any) {
        
        
    }
    
    @objc func batteryLevelDidChange(_ notification: Notification) {
        print(batteryLevel)
        chargeLabel.text = batString
        progressBar.progressValue = CGFloat(batteryLevel * 100)
        
        if Int(batteryLevel * 100) >= 100 {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            print("charging or full")
            let dialog = AZDialogViewController(title: "Device charged", message: "Diconnecting charger")
            dialog.titleColor = .black

            //set the message color
            dialog.messageColor = .black

            dialog.addAction(AZDialogAction(title: "OK") { (dialog) -> (Void) in
                    //add your actions here.
                    dialog.dismiss()
            })
            self.present(dialog, animated: false, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                ref.setValue(["charging_status": 3])
            }
        }
    }
}

