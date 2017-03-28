
//  DataMethods.swift
//  PhunInterview
//
//  Created by Mbusi Hlatshwayo on 2/6/17.
//  Copyright © 2017 Mbusi. All rights reserved.
//

import Foundation
import Alamofire
import SDWebImage
import SwiftyJSON
import SystemConfiguration
import CoreData

class NetworkHandler {
    
    func downloadEvents(completion: @escaping (Bool,String?,[Event])-> Void) {
        let coreDataObject = CoreDataMethods()
        var eventsArray = [Event]()
        Alamofire.request(URL(string:"https://raw.githubusercontent.com/phunware/dev-interview-homework/master/feed.json")!)
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    // we create the model object
                    let downloadedEvent = EventModel()

                    /* we have new data remove old data from core data*/
                    coreDataObject.deleteData(entityArgument: "Event")
                    eventsArray.removeAll()
                    for JSONData in response.result.value as! [Dictionary<String, Any>] {
                        /* get the data from JSON and store in the event model*/
                        downloadedEvent.eTitle = JSONData[downloadedEvent.titleString] as? String
                        downloadedEvent.eDate = JSONData[downloadedEvent.dateString] as? String
                        downloadedEvent.eDescription = JSONData[downloadedEvent.descriptionString] as? String
                        downloadedEvent.eLocation = JSONData[downloadedEvent.locationline1String] as? String
                        downloadedEvent.eLocation2 = JSONData[downloadedEvent.locationline2String] as? String
                        /* if the event has an image save the url*/
                        if let image = JSONData[downloadedEvent.imageString] as? String {
                            downloadedEvent.eImageURL = image
                        } else {
                            /* else we save the default image url */
                            downloadedEvent.eImageURL = downloadedEvent.defaultImageURL
                        }
                        coreDataObject.save(eventParam: downloadedEvent)
                        eventsArray = coreDataObject.retrieveCoreData()
                    }
                    
                    
                    completion(true, nil, eventsArray)
                    
                case .failure(let error):
                    print("ALAMO REQUEST FIALED: \(error)")
                    completion(false, "ALAMO REQUEST FIALED: \(error)", eventsArray)
                }
        }
    }


    /* function to check if there is a network connection*/
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}
