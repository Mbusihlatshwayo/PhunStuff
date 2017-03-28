//
//  iPadBaseViewController.swift
//  PhunInterview
//
//  Created by Mbusi Hlatshwayo on 2/6/17.
//  Copyright © 2017 Mbusi. All rights reserved.
//

import UIKit
import CoreData

class iPadBaseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    /* outlets for this file*/
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    /* global vars to this file */
    var screenWidth: CGFloat!
    var screenSize: CGRect!
    var eventsArray = [Event]()
    let coreDataHandler = CoreDataMethods()
    /* date formatter var */
    var jsonDateFormatter: DateFormatter? = nil
    var standardDateFormatter: DateFormatter? = nil
    
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
        let networkHandler = NetworkHandler()
        title = "PHUN APP"
        automaticallyAdjustsScrollViewInsets = false
        collectionView.delegate = self
        collectionView.dataSource = self
        /* we need to calculate the screen size for the cells*/
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        /* determine the layout of the collection view cells */
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        /* download events */
        networkHandler.downloadEvents {success,errorMessage,eventArr in
            if success {
                self.eventsArray = eventArr
                self.collectionView.reloadData()
            } else {
                let alertMessage: String
                if let err = errorMessage{
                    alertMessage = err
                }
                else{
                    alertMessage = "An unknown error occurred."
                }
                let alert = UIAlertController.init(title: "Request Failed", message: alertMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventsArray = coreDataHandler.retrieveCoreData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        /* we need to recalculate the screen size when layout changes for the cells*/
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            // landscape
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
            layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            collectionView!.collectionViewLayout = layout
            
        } else {
            // not landscape
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
            layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/3)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            collectionView!.collectionViewLayout = layout
        }
        
        flowLayout.invalidateLayout()
    }
    /* collection view protocols */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = eventsArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventCollectionViewCell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
        if let cell = collectionView.cellForItem(at: indexPath as IndexPath) {
            self.performSegue(withIdentifier: "showIpadDetail", sender: cell)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = self.collectionView?.indexPath(for: sender as! UICollectionViewCell) {
            if segue.identifier == "showIpadDetail" {
                let controller = segue.destination as! IpadEventViewController
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
    
    func reloadCollectionViewData() {
        collectionView.reloadData()
    }
    

}
