//
//  FirebaseManager.swift
//  yamsaferChattingSystem
//
//  Created by Qays Dwekat on 8/6/15.
//  Copyright (c) 2015 Qays Dwekat. All rights reserved.
//

import Foundation
//
//  FirebaseManager.swift
//  yamsaferChattingSystem
//
//  Created by Qays Dwekat on 8/3/15.
//  Copyright (c) 2015 Qays Dwekat. All rights reserved.
//

import Foundation


class FirebaseManager {

    static var ownerBool:Bool! = true

    static var myRootRef = Firebase(url:"https://dazzling-fire-5618.firebaseio.com/ios")
    
    static var blockBool:String!

    class func sendMessage (udid: String!, message:String!, date:String!) {
        
        let usersRef = myRootRef.childByAppendingPath("users/\(udid)")
        
        let conversationsRef = myRootRef.childByAppendingPath("conversations/"+udid+"/")
        
        conversationsRef.childByAppendingPath("udid").setValue(udid)
        
        conversationsRef.childByAppendingPath("lastTimeActive").setValue(date)
        
        conversationsRef.childByAppendingPath("status").setValue("unread")
        if ownerBool != false {
            
            let newUser = [
            "Blocked":"unblocked",
            "Email":"test@yamsafer.me",
            "Name":"User",
            "Phone":"0230230230230230",
            "udid":"\(udid)",
            "urlImage":"nil"
            ]
            
            usersRef.setValue(newUser)
            
            conversationsRef.childByAppendingPath("owner").setValue("null")
            
            ownerBool = false
        }
        
        let blockRoot = Firebase(url:"https://dazzling-fire-5618.firebaseio.com/ios/users/\(udid)/")
        
        blockRoot.observeSingleEventOfType(.Value, withBlock: {
            (snapshot) in
            
            let value = snapshot.value as! NSDictionary
            
            self.blockBool = value["Blocked"] as! String
            
            if self.blockBool == "blocked" {
                
                let alertController = UIAlertController(title: "System Alert", message:
                    "Sorry you can't send this message  ", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
                
            } else {
                
                let Message = ["body": "\(message)", "sender": udid, "imageurl":"mariusz.png", "time": date]
                
                let messagesRef = conversationsRef.childByAppendingPath("messages")
                
                let messageRef = messagesRef.childByAutoId()
                
                messageRef.setValue(Message)
                
            }
            
        })
        
    }
    
    class func registerForIncomingMessgaes(udid:String! ,callBack:((FDataSnapshot!) -> Void)!){
       
        let conversationsRef = myRootRef.childByAppendingPath("conversations/"+udid+"/messages")
        
        conversationsRef.queryLimitedToLast(10).observeEventType(FEventType.ChildAdded, withBlock:callBack)
        
    }
    
    class func userImage(senderId:String!,callBack:((FDataSnapshot!) -> Void)!) {
        
        let userRoot = Firebase(url:"https://dazzling-fire-5618.firebaseio.com/ios/users/\(senderId)")

        
        userRoot.observeSingleEventOfType(.Value, withBlock: callBack)

    }
    
    class func loadEarlierMessages(udid:String! ,callBack:((FDataSnapshot!) -> Void)!, number: UInt){
  
        let conversationsRef = myRootRef.childByAppendingPath("conversations/"+udid+"/messages")

        conversationsRef.queryLimitedToLast(number).observeEventType(FEventType.ChildAdded, withBlock:callBack)
    }
    
        
}
