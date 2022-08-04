//
//  Extensions.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-07-26.
//

import Foundation

extension String{
    var asUrl: URL?{
        return URL(string: self)
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
