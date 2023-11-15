//
//  Comment.swift
//  Instagram_Clone
//
//  Created by talha polat on 13.11.2023.
//
import Firebase
struct Comment{
    var comment:String
    var userID:String
    var addingDate:Timestamp
    
    init(commentData:[String:Any]?) {
        self.comment = commentData?["Comment"] as? String ?? ""
        self.userID = commentData?["UserID"] as? String ?? ""
        self.addingDate = commentData?["AddingDate"] as? Timestamp ?? Timestamp()
    }
}
