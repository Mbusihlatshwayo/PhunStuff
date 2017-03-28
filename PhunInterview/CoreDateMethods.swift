//
//  CoreDateMethods.swift
//  PhunInterview
//
//  Created by Mbusi Hlatshwayo on 3/16/17.
//  Copyright © 2017 Mbusi. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class CoreDataMethods {
    /* key paths for the core data entity*/
    var titlePath = "eTitle"
    var datePath = "eDate"
    var descriptionPath = "eDescription"
    var locationPath = "eLocation"
    var imagePath = "eImageURL"
    var location2Path = "eLocation2"
    
    /* function to save data to device for use without internet connection */
    func save(eventParam: EventModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Event", in: managedContext)!
        let event = NSManagedObject(entity: entity, insertInto: managedContext)
        
        /* store everything in core data entity */
        event.setValue(eventParam.eTitle, forKeyPath: titlePath)
        event.setValue(eventParam.eDate, forKeyPath: datePath)
        event.setValue(eventParam.eDescription, forKeyPath: descriptionPath)
        event.setValue(eventParam.eLocation, forKeyPath: locationPath)
        event.setValue(eventParam.eImageURL, forKeyPath: imagePath)
        event.setValue(eventParam.eLocation2, forKeyPath: location2Path)

        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }

    func retrieveCoreData()->[Event] {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        let managedContext = appDelegate?.managedObjectContext
        
        var eventArr  = [Event]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        do
        {
            eventArr = try managedContext!.fetch(fetchRequest) as! [Event]

        } catch let error as NSError {
            print("ERROR: \(error)")
        }

        return eventArr

    }
    
    /* function to remove core data entities*/
    func deleteData(entityArgument: String)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityArgument)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("DELETE ERROR: \(error)")
        }
    }
}
