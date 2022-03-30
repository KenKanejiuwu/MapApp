//
//  ViewController.swift
//  MapApp
//
//  Created by Каплин Станислав on 28.03.2022.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    //Переменные для создания маршрута
    
    var itemMapFirst: MKMapItem!
    var itemMapSecond: MKMapItem!
    
    //Для работы с картой создается manager
    let manager: CLLocationManager = {
        
        let locationManager = CLLocationManager() //Получение местоположения
        
        locationManager.activityType = .fitness // Fitness точно определяет местоположение
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //Определить точность
        locationManager.distanceFilter = 1 //Фильтр дистанции
        locationManager.showsBackgroundLocationIndicator = true //Отобразить индикатор на карте
        locationManager.pausesLocationUpdatesAutomatically = true //Отображение обновления
        
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        manager.delegate = self
        
        authrization()
        pinPosition()
        
        let touch = UILongPressGestureRecognizer(target: self, action: #selector(addPin(recogn:))
            mapView.addGestureRecognizer(touch)
            Manager.startUpdatingLocation()
    }
    
    func pinPosition() {
        
        let arrayLet = [62.0338900, 51.5085300]
        let arrayLon = [129.7330600, -0.1257400]
        
        for number in 0..<arrayLet.count {
            
            let point = MKPointAnnotation()
            point.title = "My Point"
            point.coordinate = CLLocationCoordinate2D(latitude: arrayLet[number], longitude: arrayLon[number])
            mapView.addAnnotation(point)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            itemMapFirst = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
            
        }
    }
        
    func authrization() {
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            mapView.showsUserLocation = true
            
        } else {
            
            manager.requestWhenInUseAuthorization()
            
        }
    }
    
    func calculayeRoute() {
        
        let request = MKDirections.Request()
        
        request.source = itemMapFirst
        request.destination = itemMapSecond
        request.requestsAlternateRoutes = true
        request.transportType = .walking
        
        let direction = MKDirections(request: request)
        
        direction.calculate {(response, error) in
            
            guard let directionResponse = response else {return}
            
            let route = directionResponse.routes[0]
            
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
        }
    }
    
    func mapView(_mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.lineWidth = 5
        render.
    }
    
    @objc func addPin(recogn: UIGestureRecognizer) {
        
        let newLocation = recogn.location(in: mapView)
        let newCoordinate = mapView.convert(newLocation, toCoordinateFrom: mapView)
        itemMapSecond = MKMapItem(placemark: MKPlacemark(coordinate: newCoordinate))
        
        let point = MKPointAnnotation()
        point .title = "Конечная точка"
        point.coordinate = newCoordinate
        mapView.addAnnotation(point)
        calculayeRoute()
    }
}
