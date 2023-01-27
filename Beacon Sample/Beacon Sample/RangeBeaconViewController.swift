/*
See LICENSE folder for this sample’s licensing information.

Abstract:
View controller that illustrates how to start and stop ranging for a beacon region.
*/

import UIKit
import CoreLocation

class RangeBeaconViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LocManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var locationManager = LocManager()
    var beacons = [CLProximity: [CLBeacon]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager.initManager()
//        locationManager.delegate = self
    }

    @IBAction func addBeacon(_ sender: Any) {
        let alert = UIAlertController(title: "Add Beacon Region",
                                      message: "Enter UUID",
                                      preferredStyle: .alert)
        
        var uuidTextField: UITextField!
        
        alert.addTextField { [weak self] textField in
            textField.placeholder = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
            textField.text = self?.locationManager.defaultUUID
            uuidTextField = textField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { alert in
            if let uuidString = uuidTextField.text, let uuid = UUID(uuidString: uuidString) {
//                self.locationManager.start(uuid: uuid)
            } else {
                let invalidAlert = UIAlertController(title: "Invalid UUID",
                                                     message: "Please specify a valid UUID.",
                                                     preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                invalidAlert.addAction(okAction)
                self.present(invalidAlert, animated: true)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true)
    }
    
    func updated(beacons: [CLProximity : [CLBeacon]]) {
        self.beacons = beacons
        tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        let sectionKeys = Array(beacons.keys)
        
        // The table view displays beacons by proximity.
        let sectionKey = sectionKeys[section]
        
        switch sectionKey {
            case .immediate:
                title = "Immediate"
            case .near:
                title = "Near"
            case .far:
                title = "Far"
            default:
                title = "Unknown"
        }
        
        return title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return beacons.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(beacons.values)[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Display the UUID, major, and minor for each beacon.
        let sectionkey = Array(beacons.keys)[indexPath.section]
        let beacon = beacons[sectionkey]![indexPath.row]
    
        cell.textLabel?.text = "UUID: \(beacon.uuid.uuidString)"
        cell.detailTextLabel?.text = "Major: \(beacon.major) Minor: \(beacon.minor)"
        
        return cell
    }

}
