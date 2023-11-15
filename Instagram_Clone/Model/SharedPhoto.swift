//
//  SharedPhoto.swift
//  Instagram_Clone
//
//  Created by talha polat on 8.11.2023.
//

import Firebase

struct SharedPhoto:Codable{
    var user: User
    var UserID: String
    var PhotoHeight: Double
    var PhotoWidth: Double
    var DowlandUrl: String
    var Thought: String
    var AddingDate:Timestamp
    var likeCount: Int
    var commentCount: Int
    
    init(uploaderUser:User,photoData: [String:Any]?) {
        self.user = uploaderUser
        self.UserID = photoData?["UserID"] as? String ?? ""
        self.PhotoHeight = photoData?["PhotoHeight"] as? Double ?? 0
        self.PhotoWidth = photoData?["PhotoWidth"] as? Double ?? 0
        self.DowlandUrl = photoData?["DowlandUrl"] as? String ?? ""
        self.Thought = photoData?["Thought"] as? String ?? ""
        self.AddingDate = photoData?["AddingDate"] as? Timestamp ?? Timestamp()
        self.likeCount = photoData?["LikeCount"] as? Int ?? 0
        self.commentCount = photoData?["CommentCount"] as? Int ?? 0
    }
}
