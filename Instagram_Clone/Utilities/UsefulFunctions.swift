//
//  UsefulFunctions.swift
//  Instagram_Clone
//
//  Created by talha polat on 14.11.2023.
//

import Firebase

func  decodeFirebase<T:Decodable> (type: T.Type,snapshot: DocumentSnapshot?) -> T?{
   
   guard let userData = snapshot?.data() else{
       print("Userdata")
       return nil }
   print(userData)
   do {
       let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
       let jsonString = String(data: jsonData, encoding: .utf8)
      
       if let jsonData = jsonString?.data(using: .utf8) {
          
            let  decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
           print("Dönüşüm başarılı: \(decodedObject)")
          return decodedObject
       }else{
           print("Json false")
           return nil
       }
           } catch  let error{
               print(error.localizedDescription)
               
           }

   
   return nil
}

