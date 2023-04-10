

import Foundation
import RealmSwift


class RealmUserStats:Object
{
    @Persisted var id: Int?
    @Persisted  var email: String?
    @Persisted  var first_name: String?
    @Persisted  var last_name: String?
    @Persisted  var avatar: String?
    
    
    convenience init(id: Int? = nil, email: String? = nil, first_name: String? = nil, last_name: String? = nil, avatar: String? = nil) {
        self.init()
        self.id = id
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.avatar = avatar
    }
    }
