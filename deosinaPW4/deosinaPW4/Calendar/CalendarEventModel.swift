//
//  CalendarEventModel.swift
//  deosinaPW4
//
//  Created by Kriss Osina on 15.01.2026.
//

import Foundation

struct CalendarEventModel: Codable {
    var id: String
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date
    var wishTitle: String?
    var calendarEventId: String?
    
    init(id: String = UUID().uuidString,
         title: String,
         description: String,
         startDate: Date,
         endDate: Date,
         wishTitle: String? = nil,
         calendarEventId: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.wishTitle = wishTitle
        self.calendarEventId = calendarEventId
    }
    
    func toCalendarEventModel() -> CalendarEventModel {
        return CalendarEventModel(
            id: self.id,
            title: self.title,
            description: self.description,
            startDate: self.startDate,
            endDate: self.endDate,
            calendarEventId: self.calendarEventId
        )
    }
    
    func copy(withNewId newId: String? = nil) -> CalendarEventModel {
            return CalendarEventModel(
                id: newId ?? self.id,
                title: self.title,
                description: self.description,
                startDate: self.startDate,
                endDate: self.endDate,
                wishTitle: self.wishTitle,
                calendarEventId: self.calendarEventId
            )
        }
}
