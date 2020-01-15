//
//  ViewController.swift
//  Callout
//
//  Created by ChuKoKang on 2016/7/9.
//  Copyright © 2016年 ChuKoKang. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @objc func buttonPress(_ sender: UIButton) {
        if sender.tag == 100 {
            let url = URL(string: "http://www.taroko.gov.tw")
            let safari = SFSafariViewController(url: url!)
            show(safari, sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let ann = MKPointAnnotation()
        ann.coordinate = CLLocationCoordinate2D(latitude: 24.137426, longitude: 121.275753)
        ann.title = "武嶺"
        mapView.addAnnotation(ann)
        
        // 移動地圖
        mapView.setCenter(ann.coordinate, animated: false)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if (annView == nil) {
            annView = MKPinAnnotationView(annotation: annotation, reuseIdentifier:
                "Pin")
        }
        if (annotation.title)! == "武嶺" {
            let imageView = UIImageView(image: UIImage(named: "wuling"))
            annView?.leftCalloutAccessoryView = imageView
            let label = UILabel()
            label.numberOfLines = 2
            label.text = "緯度:\(annotation.coordinate.latitude)\n經度:\(annotation.coordinate.longitude)"
            annView?.detailCalloutAccessoryView = label
            let button = UIButton(type: .detailDisclosure)
            button.tag = 100
            button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
            
            annView?.rightCalloutAccessoryView = button
        }
        annView?.canShowCallout = true
        return annView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

