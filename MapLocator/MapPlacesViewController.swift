//
//  MapPlacesViewController.swift
//  MapLocator
//
//  Created by Jeff Norton on 11/7/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import UIKit
import MapKit

class MapPlacesViewController: UIViewController, UISearchBarDelegate {
    
    //==================================================
    // MARK: - _Properties
    //==================================================
    
    var annotation: MKAnnotation!
    var error: NSError!
    var localSearch: MKLocalSearch!
    var localSearchRequest: MKLocalSearchRequest!
    var localSearchResponse: MKLocalSearchResponse!
    @IBOutlet weak var mapView: MKMapView!
    var pinAnnotationView: MKPinAnnotationView!
    var pointAnnotation: MKPointAnnotation!
    var searchController: UISearchController!
    
    //==================================================
    // MARK: - Actions
    //==================================================
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
    
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        
        present(searchController, animated: true, completion: nil)
    }
    
    //==================================================
    // MARK: - General
    //==================================================

    override func viewDidLoad() {
        super.viewDidLoad()

        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.878142, longitude: -87.626420)
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    

    //==================================================
    // MARK: - UISearchBarDelegate
    //==================================================
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchBar.text, searchText.characters.count > 0 {
            
            // #1 - Clear the Map View
            
            searchBar.resignFirstResponder()
            dismiss(animated: true, completion: nil)
            
            if self.mapView.annotations.count != 0 {
                
                annotation = self.mapView.annotations[0]
                self.mapView.removeAnnotation(annotation)
            }
            
            // #2 - Initiate the search
            
            localSearchRequest = MKLocalSearchRequest()
            localSearchRequest.naturalLanguageQuery = searchText
            localSearch = MKLocalSearch(request: localSearchRequest)
            
            localSearch.start { (localSearchResponse, error) in
                
                if localSearchResponse == nil {
                    
                    let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                    alertController.addAction(dismissAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                // #3
                
                self.pointAnnotation = MKPointAnnotation()
                self.pointAnnotation.title = searchText
                
                guard let localSearchResponse = localSearchResponse
                    else {
                        NSLog("Error unwrapping localSearchResponse.")
                        return
                }
                
                self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude: localSearchResponse.boundingRegion.center.longitude)
                
                self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                self.mapView.centerCoordinate = self.pointAnnotation.coordinate
                
                guard let pinAnnotation = self.pinAnnotationView.annotation
                    else {
                        NSLog("Error unwrapping the pinAnnotation.")
                        return
                }
                
                self.mapView.addAnnotation(pinAnnotation)
            }
        }
    }
}





























