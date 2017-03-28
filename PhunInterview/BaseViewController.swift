//
//  BaseViewController.swift
//  PhunInterview
//
//  Created by Mbusi Hlatshwayo on 2/5/17.
//  Copyright © 2017 Mbusi. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SDWebImage
import SwiftyJSON
import SystemConfiguration

class BaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    /* storyboard outlets*/
    @IBOutlet weak var tableView: UITableView!
    /* date formatter vars */
    var jsonDateFormatter: DateFormatter? = nil
    var standardDateFormatter: DateFormatter? = nil
    /* vars */
    var eventsArray = [Event]()
    let coreDataHandler = CoreDataMethods()
    
    func setDateFormatters() -> (DateFormatter, DateFormatter) {
        if jsonDateFormatter != nil && standardDateFormatter != nil {
            return (jsonDateFormatter!, standardDateFormatter!)
        }
        jsonDateFormatter = DateFormatter()
        jsonDateFormatter?.locale = Locale.current
        jsonDateFormatter?.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        standardDateFormatter = DateFormatter()
        standardDateFormatter?.locale = Locale.current
        standardDateFormatter?.dateFormat = "MMM d, h:mm a"
        return (jsonDateFormatter!, standardDateFormatter!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("VIEWDIDLOAD")
        let networkHandler = NetworkHandler()
        standardDateFormatter?.locale = Locale.current
        standardDateFormatter?.dateFormat = "MMM d, h:mm a"
        jsonDateFormatter?.locale = Locale.current
        jsonDateFormatter?.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        title = "PHUN APP"
        tableView.dataSource = self
        tableView.delegate = self
        /* download events */
        networkHandler.downloadEvents {success,errorMessage,eventArr in
            if success {
                self.eventsArray = eventArr
                self.tableView.reloadData()
            } else {
                let alertMessage: String
                if let err = errorMessage{
                    alertMessage = err
                }
                else{
                    alertMessage = "An unknown error occurred."
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventsArray = coreDataHandler.retrieveCoreData()
    }

    /* table view protocols */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let event = eventsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        let imageString = event.value(forKeyPath: "eImageURL") as? String
        
        /* we need to convert the date from the JSON into a date the user can read*/
        (jsonDateFormatter!,standardDateFormatter!) = self.setDateFormatters()
        let dateInFormat = jsonDateFormatter?.date(from: event.value(forKeyPath: "eDate") as! String)
        
        /* set the labels and images for each cell*/
        cell.dateLabel.text = standardDateFormatter?.string(from: dateInFormat!)
        cell.titleLabel.text = event.value(forKeyPath: "eTitle") as? String
        cell.descriptionLabel.text = event.value(forKeyPath: "eDescription") as? String
        cell.locationLabel.text = event.value(forKeyPath: "eLocation") as? String
        cell.eventImageView.sd_setImage(with: URL(string:imageString!), placeholderImage: UIImage(named: "placeholder_nomoon"), options: [.continueInBackground, .progressiveDownload])
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func reloadTableViewData() {

        tableView.reloadData()

    }
    
    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "showDetail" {
             if let indexPath = self.tableView.indexPathForSelectedRow {
                 let controller = segue.destination as! EventViewController
                /* convert the date to something user readable */
                 let dateFormatter = DateFormatter()
                 dateFormatter.locale = Locale.current
                 dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                 let dateInFormat = dateFormatter.date(from: eventsArray[indexPath.row].value(forKeyPath: "eDate") as! String)
                 dateFormatter.dateFormat = "MMM d, h:mm a"
                /* pass the data forward to the detail VC*/
                 controller.dateText = dateFormatter.string(from: dateInFormat!)
                 controller.descriptionText = eventsArray[indexPath.row].value(forKeyPath: "eDescription") as! String
                 controller.location1Text = eventsArray[indexPath.row].value(forKeyPath: "eLocation") as! String
                 controller.location2Text = eventsArray[indexPath.row].value(forKeyPath: "eLocation2") as! String
                 controller.titleText = eventsArray[indexPath.row].value(forKeyPath: "eTitle") as! String
                 controller.imageUrlText = eventsArray[indexPath.row].value(forKeyPath: "eImageURL") as! String
             }
         }
     }
}
