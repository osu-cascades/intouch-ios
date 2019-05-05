//
//  event.swift
//  intouch
//
//  Created by Bradley Cook on 4/21/19.
//  Copyright © 2019 Aaron. All rights reserved.
//

import Foundation

class Event {
    var title: String
    var description: String
    var time: String
    var place: String
    var notes: String
    var groupParticipants: [String]
    var hostedBy: String
    
    
    init(title: String, description: String, time: String, place: String, notes: String, groupParticipants: [String], hostedBy: String) {
        self.title = title
        self.description = description
        self.time = time
        self.place = place
        self.notes = notes
        self.groupParticipants = groupParticipants
        self.hostedBy = hostedBy
    }
}
