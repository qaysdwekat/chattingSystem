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
        
    class func sendMessage (udid: String!, message:String!, date:String!) {

        var myRootRef = Firebase(url:"https://dazzling-fire-5618.firebaseio.com/ios")

        var ownerBool:Bool! = true
        
        var blockBool:String!
        
        
        let usersRef = myRootRef.childByAppendingPath("users/\(udid)")
        
        let conversationsRef = myRootRef.childByAppendingPath("conversations/"+udid+"/")
        
        conversationsRef.childByAppendingPath("udid").setValue(udid)
        
        conversationsRef.childByAppendingPath("lastTimeActive").setValue(date)
        
        conversationsRef.childByAppendingPath("status").setValue("unread")
        if ownerBool != false {
            conversationsRef.childByAppendingPath("owner").setValue("null")
            ownerBool = false
        }
        let blockRoot = Firebase(url:"https://dazzling-fire-5618.firebaseio.com/ios/users/\(udid)/")
        
        blockRoot.observeSingleEventOfType(.Value, withBlock: {
            (snapshot) in
            
            let value = snapshot.value as! NSDictionary
            
            blockBool = value["Blocked"] as! String
            
            if blockBool == "blocked" {
                
                let alertController = UIAlertController(title: "System Alert", message:
                    "Sorry you can't send this message  ", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
                
            } else {
                let user = ["Blocked" :"unblocked", "Email" : "mohammad@gmail.com", "Phone" : "00970598234567", "Name" : "Mohammad Nablusi", "udid" : udid,"urlImage":"nil"]
                
                
                let Message = ["body": "\(message)", "sender": udid, "imageurl":"mariusz.png", "time": date]
                
                let messagesRef = conversationsRef.childByAppendingPath("messages")
                
                let messageRef = messagesRef.childByAutoId()
                
                
                messageRef.setValue(Message)
                
                usersRef.setValue(user)
            }
            
        })
        
    }
    
    class func registerForIncomingMessgaes(udid:String! ,callBack:((FDataSnapshot!) -> Void)!){
       
        var myRootRef = Firebase(url:"https://dazzling-fire-5618.firebaseio.com/ios")

        let conversationsRef = myRootRef.childByAppendingPath("conversations/"+udid+"/messages")
        
        conversationsRef.queryLimitedToLast(10).observeEventType(FEventType.ChildAdded, withBlock:callBack)
        
    }
    
    class func userImage(senderId:String!,callBack:((FDataSnapshot!) -> Void)!) {
        
        let userRoot = Firebase(url:"https://dazzling-fire-5618.firebaseio.com/ios/users/\(senderId)")

        
        userRoot.observeSingleEventOfType(.Value, withBlock: callBack)

    }
    
    class func loadEarlierMessages(udid:String! ,callBack:((FDataSnapshot!) -> Void)!, number: UInt){

        var myRootRef = Firebase(url:"https://dazzling-fire-5618.firebaseio.com/ios")
  
        let conversationsRef = myRootRef.childByAppendingPath("conversations/"+udid+"/messages")

        conversationsRef.queryLimitedToLast(number).observeEventType(FEventType.ChildAdded, withBlock:callBack)
    }
    
        
}
