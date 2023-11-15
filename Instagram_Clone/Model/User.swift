//
//  User.swift
//  Instagram_Clone
//
//  Created by talha polat on 1.11.2023.
//

struct User: Codable {
    var UserID: String
    var Username: String
    var ProfilePhotoUrl: String
    var Following: [User]?
    var FollowingCount: Int
    var Followers: [User]?
    var FollowersCount:Int
    var SharedPhotos : [SharedPhoto]?
   // var SharedPhotosCount: Int
    var PostCount:Int
}
