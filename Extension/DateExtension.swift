//
//  DateExtension.swift
//  CattleSteamerHousekeeper
//
//  Created by yingjian on 2017/2/24.
//  Copyright © 2017年 yingjian. All rights reserved.
//

import Foundation

extension Date {
    static func getStringWithTimeStamp(timeStamp: Int64?, format: String) -> String? {
        guard let stamp = timeStamp else {
            return ""
        }
        let confromTimesp = Date.init(timeIntervalSince1970: TimeInterval(stamp))
        let time = confromTimesp.stringWithDateFormat(format: format)
        return time
    }
    
    func stringWithDateFormat(format: String) -> String {
        let dateFormatter = DateFormatter.init()
        let formatterLocale = Locale.init(identifier: "en_GB")
        dateFormatter.locale = formatterLocale
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}
