//
//  MapViewController.swift
//  PetAssist
//
//  Created by Xcode User on 2020-03-29.
//  Copyright © 2020 PetAssist. All rights reserved.


import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var matchingItems: [MKMapItem]!

    @IBOutlet var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    
    
    // Find pet adoptions nearby user's current location
    @IBAction func findPetAdoption(_ sender: Any){
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "pet adoption"
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            
            if error != nil{
                print ("Error")
            }else if response!.mapItems.count == 0{
                print("No matches found")
            }else{
                
                self.matchingItems = response?.mapItems
                
                if let updatedRegion = response?.boundingRegion{
                    self.mapView.region = updatedRegion
                }
                
                self.mapView.delegate = self
                
                self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "pin")
                self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
                
                for item in self.matchingItems{
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    // Find pet stores nearby user's current location
    @IBAction func findPetStore(_ sender: Any) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Pet Stores"
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            
            if error != nil{
                print ("Error")
            }else if response!.mapItems.count == 0{
                print("No matches found")
            }else{
                
                self.matchingItems = response?.mapItems
                
                if let updatedRegion = response?.boundingRegion{
                    self.mapView.region = updatedRegion
                }
                
                self.mapView.delegate = self
                
                self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "pin")
                self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
                
                for item in self.matchingItems{
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    // find vet cares nearby user's current location
    @IBAction func findVetCare(_ sender: Any) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Veterinanrians"
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            
            if error != nil{
                print ("Error")
            }else if response!.mapItems.count == 0{
                print("No matches found")
            }else{
                
                self.matchingItems = response?.mapItems
                
                if let updatedRegion = response?.boundingRegion{
                    self.mapView.region = updatedRegion
                }
                
                self.mapView.delegate = self
                
                self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "pin")
                self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
                
                for item in self.matchingItems{
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    // Find dog parks nearby user's current location
    @IBAction func findParks(_ sender: Any) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Dog Parks"
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            
            if error != nil{
                print ("Error")
            }else if response!.mapItems.count == 0{
                print("No matches found")
            }else{
                
                self.matchingItems = response?.mapItems
                
                if let updatedRegion = response?.boundingRegion{
                    self.mapView.region = updatedRegion
                }
                
                self.mapView.delegate = self
                
                self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "pin")
                self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
                
                for item in self.matchingItems{
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    // Request authorization, show and update user's current location
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined{
                
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.desiredAccuracy = 1.0
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }else{
            print("Please turn on location services.")
        }
        
        let dropPin = MKPointAnnotation()
       // dropPin.coordinate =
       // dropPin.title = "Sheridan College, Davis Campus"
       // self.myMapview.addAnnotation(dropPin)
       // self.myMapview.selectAnnotation(dropPin, animated: true)
        
    }
    
    // How much zoom in and out in map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    // Location request error handler
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to access to your current location")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
