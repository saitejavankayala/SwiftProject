//
//  realmUserStatsStore.swift
//  SwiftAssignment
//
//  Created by MA-31 on 07/04/23.
//

import Foundation
import RealmSwift

enum RuntimeError: Error {
    case NoRealmSet
}

class RealmUserStatsStore {
    
    static let shared = RealmUserStatsStore()
    var realm: Realm = try! Realm()
    
    func getDataBaseUrl() -> URL?{
        return Realm.Configuration.defaultConfiguration.fileURL
    }
    public func saveUser(RealmUserStats: RealmUserStats)
        {
           
            try! realm.write {
                realm.add(RealmUserStats)
            }
           
        }
    public func deleteUser(realmUserStats: Int)
        {
            
         
            let idData = realm.objects(RealmUserStats.self).filter("id == %d",realmUserStats )
            try! realm.write {
                realm.delete(idData)
            }
           
        }
    public func updateUser(realmUserStats: RealmUserStats)
    {
        
     
        let results = realm.objects(RealmUserStats.self).where({   $0.id == realmUserStats.id
            
        }).first!
        print(results)
        try! realm.write {
            results.first_name = realmUserStats.first_name
            results.last_name = realmUserStats.last_name
            results.avatar = realmUserStats.avatar
            results.email = realmUserStats.email
        }
        
    }
   
    public func count() -> Int {
        let count = realm.objects(RealmUserStats.self).count
        return count
    }
    public func getAllUser<RealmUserStats:Object>()->[RealmUserStats]  {
        return Array(realm.objects(RealmUserStats.self))
    }

}
