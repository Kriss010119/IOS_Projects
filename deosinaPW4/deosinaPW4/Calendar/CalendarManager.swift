//
//  CalendarManager.swift
//  deosinaPW4
//
//  Created by Kriss Osina on 18.01.2026.
//

import EventKit
import UIKit

protocol CalendarManaging {
    func create(eventModel: CalendarEventModel) -> Bool
    func create(eventModel: CalendarEventModel, completion: ((Bool) -> Void)?)
    func delete(eventId: String) -> Bool
    func delete(eventId: String, completion: ((Bool) -> Void)?)
}

final class CalendarManager: CalendarManaging {
    private let eventStore: EKEventStore = EKEventStore()
    private let calendarIdentifierKey = "calendar_event_id"
    
    func create(eventModel: CalendarEventModel) -> Bool {
        var result: Bool = false
        let group = DispatchGroup()
        group.enter()
        create(eventModel: eventModel) { isCreated in
            result = isCreated
            group.leave()
        }
        group.wait()
        return result
    }
    
    // MARK: - Create
    func create(eventModel: CalendarEventModel, completion: ((Bool) -> Void)?) {
        let createEvent: EKEventStoreRequestAccessCompletionHandler = { [weak self] (granted, error) in
            guard granted, error == nil, let self = self else {
                completion?(false)
                return
            }
            
            let event: EKEvent = EKEvent(eventStore: self.eventStore)
            event.title = eventModel.title
            event.startDate = eventModel.startDate
            event.endDate = eventModel.endDate
            
            var notes = eventModel.description
            if !notes.isEmpty { notes += "\n\n" }
            notes += "AppEventID: \(eventModel.id)"
            event.notes = notes
            
            event.calendar = self.eventStore.defaultCalendarForNewEvents
            
            do {
                try self.eventStore.save(event, span: .thisEvent)
                self.saveCalendarEventId(eventModel.id, calendarEventId: event.eventIdentifier)
                completion?(true)
            } catch let error as NSError {
                print("Failed to save event, error: \(error)")
                completion?(false)
            }
        }
        
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: createEvent)
        } else {
            eventStore.requestAccess(to: .event, completion: createEvent)
        }
    }
    
    // MARK: - Delete
    func delete(eventId: String) -> Bool {
        var result: Bool = false
        let group = DispatchGroup()
        group.enter()
        delete(eventId: eventId) { isDeleted in
            result = isDeleted
            group.leave()
        }
        group.wait()
        return result
    }
    
    func delete(eventId: String, completion: ((Bool) -> Void)?) {
        guard let calendarEventId = getCalendarEventId(for: eventId) else {
            completion?(false)
            return
        }
        
        let deleteEvent: EKEventStoreRequestAccessCompletionHandler = { [weak self] (granted, error) in
            guard granted, error == nil, let self = self else {
                completion?(false)
                return
            }
            
            guard let event = self.eventStore.event(withIdentifier: calendarEventId) else {
                self.removeCalendarEventId(for: eventId)
                completion?(true)
                return
            }
            
            do {
                try self.eventStore.remove(event, span: .thisEvent)
                self.removeCalendarEventId(for: eventId)
                completion?(true)
            } catch let error as NSError {
                print("Failed to delete event, error: \(error)")
                completion?(false)
            }
        }
        
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: deleteEvent)
        } else {
            eventStore.requestAccess(to: .event, completion: deleteEvent)
        }
    }
    
    // MARK: - Get, Sace, Reemove event ID
    
    private func getCalendarEventId(for eventId: String) -> String? {
        let savedIds = UserDefaults.standard.dictionary(forKey: calendarIdentifierKey) as? [String: String]
        return savedIds?[eventId]
    }
    
    private func saveCalendarEventId(_ eventId: String, calendarEventId: String?) {
        guard let calendarEventId = calendarEventId else { return }
        var savedIds = UserDefaults.standard.dictionary(forKey: calendarIdentifierKey) as? [String: String] ?? [:]
        savedIds[eventId] = calendarEventId
        UserDefaults.standard.set(savedIds, forKey: calendarIdentifierKey)
    }
    
    private func removeCalendarEventId(for eventId: String) {
        var savedIds = UserDefaults.standard.dictionary(forKey: calendarIdentifierKey) as? [String: String] ?? [:]
        savedIds.removeValue(forKey: eventId)
        UserDefaults.standard.set(savedIds, forKey: calendarIdentifierKey)
    }
}
