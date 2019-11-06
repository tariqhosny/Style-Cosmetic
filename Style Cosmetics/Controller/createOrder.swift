//
//  createOrder.swift
//  Style Cosmetics
//
//  Created by Tariq on 8/5/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class createOrder: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var phoneLb: UITextField!
    @IBOutlet weak var addressLb: UITextField!
    @IBOutlet weak var countryLb: UITextField!
    @IBOutlet weak var cityLb: UITextField!
    @IBOutlet weak var streetLb: UITextField!
    @IBOutlet weak var notesLb: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cashSwitch: UISwitch!
    @IBOutlet weak var paymentSwitch: UISwitch!
    
    var totalPrice = Int()
    var userLat = 0.0
    var userLng = 0.0
    var locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func cashSwitshPressed(_ sender: UISwitch) {
        if cashSwitch.isOn{
            paymentSwitch.setOn(false, animated: true)
        }else{
            paymentSwitch.setOn(true, animated: true)
        }
    }
    
    @IBAction func paymentSwitchPressed(_ sender: UISwitch) {
        if paymentSwitch.isOn{
            cashSwitch.setOn(false, animated: true)
        }else{
            cashSwitch.setOn(true, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        self.userLat = location.coordinate.latitude
        self.userLng = location.coordinate.longitude
        print("locations = \(location.coordinate.latitude) \(location.coordinate.longitude)")
        
    }
    
    @IBAction func getMyLocation(_ sender: Any) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        getAddressFromLatLon(pdblLatitude: "\(self.userLat)", withLongitude: "\(self.userLng)")
    }
    
    func displayErrors (errorText: String){
        let alert = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorText, preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: NSLocalizedString("Dismiss", comment: ""), style: .default, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    @IBAction func orderNow(_ sender: UIButton) {
        guard let phone = phoneLb.text, let address = addressLb.text, let country = countryLb.text, let city = cityLb.text, let street = streetLb.text, let notes = notesLb.text else {return}
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        if (phone.isEmpty == true || address.isEmpty == true || country.isEmpty == true || city.isEmpty == true || street.isEmpty == true){
            self.displayErrors(errorText: NSLocalizedString("Empty Fields", comment: ""))
        }else {
            if self.cashSwitch.isOn{
                orderApi.createOrderApi(totalPrice: self.totalPrice, phone: phone, address: address, notes: notes, city: city, country: country, street: street, latidude: Float(self.userLat), langitude: Float(self.userLng), method: 2, completion: { (error: Error?, success: Bool?) in
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    if success == true{
                        helper.restartApp()
                    }
                })
            }else if self.paymentSwitch.isOn{
                self.performSegue(withIdentifier: "payment", sender: nil)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }else if !self.cashSwitch.isOn && !self.paymentSwitch.isOn{
                let alert = UIAlertController(title: "Faild".localized, message: "Please select the payment method".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
            
        }
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    self.addressLb.text = ("\(pm.subLocality ?? "")")
                    self.cityLb.text = "\(pm.locality ?? "")"
                    self.countryLb.text = "\(pm.country ?? "")"
                    self.streetLb.text = "\(pm.subThoroughfare ?? "") \(pm.thoroughfare ?? "")"
                }
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? paymentWebView{
            destenation.totalPrice = self.totalPrice
            destenation.address = self.addressLb.text ?? ""
            destenation.city = self.cityLb.text ?? ""
            destenation.country = self.countryLb.text ?? ""
            destenation.notes = self.notesLb.text ?? ""
            destenation.lang = Float(self.userLng)
            destenation.lat = Float(self.userLat)
            destenation.street = self.streetLb.text ?? ""
            destenation.phone = self.phoneLb.text ?? ""
        }
    }
    
}

extension createOrder {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
