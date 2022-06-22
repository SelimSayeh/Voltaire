import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class mapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        configureLocationServices()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureLocationServices() {
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
           beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    private func addAnnotations() {
        
        let urlString = "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&q=&facet=name&facet=is_installed&facet=is_renting&facet=is_returning&facet=nom_arrondissement_communes"
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded)
         {
            AF.request(url ,method: .get , encoding: URLEncoding.default ).responseJSON {
               response in
                switch response.result {
                        case .success:
                    
                    guard let data = response.data else { return }
                    let json = try? JSON(data:data)
                    let nhits = json?["nhits"].intValue
                   
                    print(json?["records"].array?.count)
                    let arrayCount = json?["records"].array?.count ?? 0
                    for i in 0..<arrayCount {
                        var voltaireAnnotation = MKPointAnnotation()
                        let    array = json?["records"][i]["geometry"]
                       
                        let arrayNames = json?["records"][i]["fields"]["name"]
                    
                        let longitude = array!["coordinates"][0].doubleValue as Double
                        let latitude = array!["coordinates"][1].doubleValue as Double
                        let name = json?["records"][i]["fields"]["name"]
                        
                        voltaireAnnotation.title = name!.stringValue
                        
                        voltaireAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude , longitude: longitude)
                        
                        self.mapView.addAnnotation(voltaireAnnotation)
                    
                    }
                   
                    
                        case .failure(let error):
                            print(error)
                        }
            }
        }
        
    }
}

extension mapController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        
        guard let latestLocation = locations.first else { return }
        
        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
            addAnnotations()
        }
    
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       print("The status changed")
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
}

extension mapController  {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
       if  annotation === mapView.userLocation {
            annotationView?.image = UIImage(named: "Location")
        } else {
            annotationView?.image = UIImage(named: "veloIcon")
    }
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("The annotation was selected: \(String(describing: view.annotation?.title))")
    }
}
