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
