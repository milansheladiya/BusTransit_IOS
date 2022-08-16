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
            if let error = error {
                completionBlock(error.localizedDescription)
            } else {
                completionBlock("")
            }
        }
    }
    
    static func logout(){
        try! auth.signOut()
    }
    //------------------ Input ------------------------
    static func _insertDocument(_collection:String, _data:[String:Any?], callback: @escaping(String) -> Void) -> String {
            
        var ref = FirebaseUtil._db.collection(_collection).addDocument(data: _data as [String : Any])
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
        return ref.documentID
    }

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
    
    //------------------------- read document ------------------------
    
    func _readSingleDocument(_collection:String,_document:String, callback: @escaping(DocumentSnapshot) -> Void) {
            
        FirebaseUtil._db.collection(_collection).document(_document).getDocument() { (document, err) in
                if let err = err {
                        print("Error getting documents: \(err)")
                }
                callback(document!)
        }

    }
    
    
    
    func _readDocumentsWithMultipleFieldValues(_collection:String,_field:String, _value:[String], callback: @escaping(QuerySnapshot) -> Void){
        FirebaseUtil._db.collection(_collection).whereField(_field, in: _value).getDocuments() { (querySnapshot, err) in
                if let err = err {
                        print("Error getting documents: \(err)")
                }
                callback(querySnapshot!)
        }
    }
    
    
    func _readAllDocumentsWithField(_collection:String,_field:String, _value:String, callback: @escaping(QuerySnapshot) -> Void) {
            
        FirebaseUtil._db.collection(_collection).whereField(_field, isEqualTo: _value).getDocuments() { (querySnapshot, err) in
                if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
//                        for document in querySnapshot!.documents {
//                            print("\(document.documentID) => \(document.data())")
//                        }
                    }
                callback(querySnapshot!)
                
            }

    }
    
    
    func _readLiveDocumentsWithField(_collection:String,_doc_id:String, callback: @escaping(DocumentSnapshot) -> Void)
    {
        FirebaseUtil._db.collection("Bus").document("5klM2WfZ3BhvDxuzJs5s")
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching Live document: \(error!)")
                return
              }
                
                callback(documentSnapshot!)
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
    
   
    
    func _readLiveDocuments(_collection:String,_field:String, _value:[String], callback: @escaping(QuerySnapshot) -> Void) {
            
        FirebaseUtil._db.collection(_collection).whereField(_field, in: _value).addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                        print("Error getting documents: \(err)")
                    }
                callback(querySnapshot!)
                
            }
    }
    
    
    //----------------------------------
    
    
    static func _deleteDocumentWithId(_collection:String,_docId: String){
        
        _db.collection(_collection).document(_docId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
    }
    static func _updateExistingFieldInDocumentWithId(_collection:String,_docId: String, _data:[String:Any?]){
        
        let firebaseRef = FirebaseUtil._db.collection(_collection).document(_docId)

        //https://firebase.google.com/docs/firestore/manage-data/add-data#update-data
        
        firebaseRef.updateData(_data) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }

}
    
    
    

