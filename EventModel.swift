//
//  EventModel.swift
//  PhunInterview
//
//  Created by Mbusi Hlatshwayo on 3/16/17.
//  Copyright © 2017 Mbusi. All rights reserved.
//

import Foundation

class EventModel {
    var eDate: String?
    var eDescription: String?
    var eImageData: NSData?
    var eImageURL: String?
    var eLocation: String?
    var eLocation2: String?
    var eTitle: String?
    
    // JSON key values
    var titleString = "title"
    var dateString = "date"
    var descriptionString = "description"
    var locationline1String = "locationline1"
    var locationline2String = "locationline2"
    var imageString = "image"
    var defaultImageURL = "https://raw.githubusercontent.com/phunware/dev-interview-homework/master/iOS/02_assets/%401x/placeholder_nomoon.png"
}
