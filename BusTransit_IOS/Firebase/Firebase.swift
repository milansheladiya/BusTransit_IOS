//
//  Firebase.swift
//  BusTransit_IOS
//
//  Created by Milan Sheladiya on 2022-07-09.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class FirebaseUtil{
    
    static let auth = FirebaseAuth.Auth.auth()
    static let _db = Firestore.firestore()
    
    
    //-------------------- User Creation ------------------
    
    static func createUser(newUser: User, password: String, completionBlock: @escaping (_ uid: String) -> Void) {
        
        
        
        FirebaseUtil.auth.createUser(withEmail: newUser.email_id, password: password, completion: { authResult, error in
            guard let user = authResult?.user, error == nil else {
                   print(error!.localizedDescription)
//                    print("Error in -----------------> ")
                    Constants.RecentError = error!.localizedDescription
                    completionBlock("")
                   return
            }
//            print("------> inside --> " , authResult?.user.uid ?? "M2ND")
            UserList.GlobleUser.user_id = authResult?.user.uid ?? "M2ND"
            completionBlock(authResult?.user.uid ?? "M2ND")
        })
        }
    
    
    
    // --------------- Login User ----------------
    
    static func signIn(email: String, pass: String, completionBlock: @escaping (_ success: String) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(error.localizedDescription)
            } else {
                completionBlock("")
            }
        }
    }
    
    
    
    
    
    //------------------ Input ------------------------
    
    static func _insertDocumentWithId(_collection:String,_docId: String, _data:[String:Any?], callback: @escaping(String) -> Void) {
            
        FirebaseUtil._db.collection(_collection).document(_docId ).setData(_data as [String : Any])
        { err in
                if let err = err {
                    print("Error adding document: \(err)")
                    callback(err.localizedDescription)
                    Constants.RecentError = err.localizedDescription
                } else {
                    print("Document added!")
                    callback("success");
                }
            
            }
    }
    func _readAllDocuments(_collection:String, callback: @escaping(QuerySnapshot) -> Void) {
            
        FirebaseUtil._db.collection(_collection).getDocuments() { (querySnapshot, err) in
                if let err = err {
                        print("Error getting documents: \(err)")
                    }
                callback(querySnapshot!)
                
            }

    }
}
    
    
    

