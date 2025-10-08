//
//  Date.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 06/10/25.
//
import Foundation

func customRelativeTimeString(from date: Date) -> String {
    let now = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.second, .minute, .hour, .day, .weekOfYear, .month, .year], from: date, to: now)

    if let year = components.year, year > 0 {
        return year == 1 ? "an year ago" : "\(year) years ago"
    }
    if let month = components.month, month > 0 {
        return month == 1 ? "a month ago" : "\(month) months ago"
    }
    if let week = components.weekOfYear, week > 0 {
        return week == 1 ? "last week" : "\(week) weeks ago"
    }
    if let day = components.day, day > 0 {
        if day == 1 {
            return "yesterday"
        } else if day < 7 {
            return "\(day) days ago"
        }
    }
    if let hour = components.hour, hour > 0 {
        return hour == 1 ? "an hour ago" : "\(hour) hours ago"
    }
    if let minute = components.minute, minute > 0 {
        return minute == 1 ? "1 minute ago" : "\(minute) minutes ago"
    }
    if let second = components.second, second > 0 {
        return second < 10 ? "a few seconds ago" : "\(second) seconds ago"
    }
    return "just now"
}
