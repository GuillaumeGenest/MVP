//
//  UserModel.swift
//  MVP
//
//  Created by Guillaume Genest on 26/10/2023.
//

import Foundation
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth


class UserModel: Identifiable, ObservableObject, Comparable, Codable{
    static func < (lhs: UserModel, rhs: UserModel) -> Bool {
        lhs.id < rhs.id
    }
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        lhs.id == rhs.id

    }
    var id : String
    var name: String
    var email: String
    var imageURL: String
    
    
    init(id: String, name: String, email: String, imageURL: String){
        self.id = id
        self.name = name
        self.email = email
        self.imageURL = imageURL
    }
    
    
    init(auth: AuthDataResultModel) {
        self.id = auth.uid
        self.name = ""
        self.email = auth.email ?? ""
        self.imageURL = ""
    }
    
    enum CodingKeys: CodingKey {
            case id
            case name
            case email
            case imageURL
        }
    
    
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self.name = try container.decode(String.self, forKey: .name)
            self.email = try container.decode(String.self, forKey: .email)
            self.imageURL = try container.decode(String.self, forKey: .imageURL)
    }
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(email, forKey: .email)
            try container.encode(imageURL, forKey: .imageURL)
        }
}

struct RestUser: Identifiable, Codable{
    var id : String
    var email: String
    var imageURL: String
}

struct RestIdUser: Codable{
    var id : String
}

var MockedDataUser : UserModel = UserModel(id: "testid", name: "test", email: "test@test.com", imageURL: "")

