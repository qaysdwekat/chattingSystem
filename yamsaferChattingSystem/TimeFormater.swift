//
//  TimeFormater.swift
//  yamsaferChattingSystem
//
//  Created by Qays Dwekat on 8/6/15.
//  Copyright (c) 2015 Qays Dwekat. All rights reserved.
//

import Foundation


enum DateFormatesOptions:String {
    
    case API_FORMAT = "MM/dd/yyyy"
    case DEFAULT_FORMAT = "yyyy-MM-dd"
    case DEFAULT_FORMAT_WITH_HOUR = "yyyy-MM-dd HH:mm:ss"
    case MONTH_YEAR = "MM/yy"
    case CHECK_IN_CHECK_OU_FORMAT_CHECK_OUT = "EdMMMYYYY"
    case MESSAGE_DATE = "MMM dd, hh:mm a"
}


class TimeFormater {
    
    class func formatFromFormatTemplate(date : NSDate , format : DateFormatesOptions ) -> NSString {
        let locale = NSLocale.currentLocale()
        
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = format.rawValue
        
        var formatedString = dateFormatter.stringFromDate(date)
        
        return formatedString
        
    }
    
    
    class func dateFromString(date:String, format : DateFormatesOptions ) -> NSDate! {
        
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.locale = NSLocale.currentLocale()
        
        dateFormatter.dateFormat = format.rawValue
        
        return dateFormatter.dateFromString(date)
    }
    
    class func messagesDateFormat(someDate : NSDate) -> String {
        
        var todayString:String!
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        
        let calendar = NSCalendar.currentCalendar()
        
        let flags = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear
        
        let components = calendar.components(flags, fromDate: NSDate())
        
        let today = calendar.dateFromComponents(components)

        let yesterday = today?.dateByAddingTimeInterval(-24 * 60 * 60)


        if someDate.timeIntervalSinceDate(today!).isSignMinus {
          
             if someDate.timeIntervalSinceDate(yesterday!).isSignMinus {
                var formatString = NSDateFormatter.dateFormatFromTemplate("MMM dd, hh:mm a", options:0,
                    locale:NSLocale.currentLocale())
                
                var dateFormatter = NSDateFormatter()
                
                dateFormatter.dateFormat = formatString
                
                todayString = dateFormatter.stringFromDate(someDate)
             } else{
                
                var formatString = NSDateFormatter.dateFormatFromTemplate(" hh:mm a", options:0,
                    locale:NSLocale.currentLocale())
                
                var dateFormatter = NSDateFormatter()
                
                dateFormatter.dateFormat = formatString
                
                todayString = dateFormatter.stringFromDate(someDate)
                
                todayString = "Yesterday, \(todayString)"
                
 
            }
        
        } else {
            
            var formatString = NSDateFormatter.dateFormatFromTemplate(" hh:mm a", options:0,
                locale:NSLocale.currentLocale())
            
            var dateFormatter = NSDateFormatter()
            
            dateFormatter.dateFormat = formatString
            
            todayString = dateFormatter.stringFromDate(someDate)
            
            todayString = "Today, \(todayString)"

        }
        
        return todayString
        
    }
    
}
