//
//  userStats.swift
//  SwiftAssignment
//
//  Created by MA-31 on 23/03/23.
//

import Foundation

struct data: Decodable{
    var id : Int
    var email : String
    var first_name : String
    var last_name : String
    var avatar: String
}

struct userStats: Decodable{
    var data: [data]
}
