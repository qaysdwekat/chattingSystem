//
//  ViewController.swift
//  yamsaferChattingSystem
//
//  Created by Qays Dwekat on 8/2/15.
//  Copyright (c) 2015 Qays Dwekat. All rights reserved.
//

import UIKit
import JSQMessagesViewController



class ViewController: JSQMessagesViewController {
   
    var messages = [JSQMessage]()
    
    var udid:String!
    
    var sender:String!
  
    var dateTime:NSDate!
    
    var stringTime:String!

    var userImageUrl = Dictionary<String, AnyObject>()
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor(red: 198/255, green: 205/255, blue: 207/255, alpha: 1.0))
    
    var outgoingavatar:JSQMessagesAvatarImage!
    
    var incomingavatar:JSQMessagesAvatarImage!
    
    var LoadEarlierDidPress:JSQMessagesLoadEarlierHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        inputToolbar.contentView.leftBarButtonItem = nil
        
        automaticallyScrollsToMostRecentMessage = true
        
        showLoadEarlierMessagesHeader = true
        
        udid = "4444"
        
        
        FirebaseManager.registerForIncomingMessgaes(udid ,callBack: { (snapshot) in
            
            let value = snapshot.value as! NSDictionary
            
            let body = value["body"] as! String
            
            let sender = value["sender"] as! String
            
            let time = value["time"] as! String
            
            self.dateTime = TimeFormater.dateFromString(time, format:DateFormatesOptions.DEFAULT_FORMAT_WITH_HOUR)
            var message = JSQMessage(senderId: sender, senderDisplayName: sender, date:self.dateTime, text: body )

                FirebaseManager.userImage(sender, callBack: { snapshot in
                    var image:String!
                    
                    image = (snapshot.value.objectForKey("urlImage") as! String)
                    
                    self.userImageUrl[sender] = image
                    
                    self.messages += [message]
                    
                    self.scrollToBottomAnimated(true)
                    
                    self.finishSendingMessage()
                    
                })
           
        })
        
        self.senderDisplayName = udid
        
        self.senderId = udid
    }
    
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        var timeValue:String! = TimeFormater.formatFromFormatTemplate(date,format: DateFormatesOptions.DEFAULT_FORMAT_WITH_HOUR)as! String
        
        FirebaseManager.sendMessage(udid, message: text, date:timeValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        var data = messages[indexPath.row]

        return data
        
    }
    
    @IBAction func exitButton(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Close Chatting System", message: "Are you sure you want to exit ?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                exit(0)
                
            case .Cancel:
                println("cancel")
                
            case .Destructive:
                println("destructive")
            }
        }))
    }
    
    //Did tap load earlier messages button
    override func collectionView(collectionView: JSQMessagesCollectionView!,
        header:JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!){
            
            var loadCount:Int! = messages.count
            
            loadCount =  loadCount + 10
            
            messages = []
            
            FirebaseManager.loadEarlierMessages(udid ,callBack: { (snapshot) in
                
                let value = snapshot.value as! NSDictionary
                
                let body = value["body"] as! String
            
                let sender = value["sender"] as! String
                
                let time = value["time"] as! String
                
                self.dateTime = TimeFormater.dateFromString(time, format:DateFormatesOptions.DEFAULT_FORMAT_WITH_HOUR)
                
                var message = JSQMessage(senderId: sender, senderDisplayName: sender, date:self.dateTime, text: body )
                
                self.messages += [message]
                
                self.scrollToBottomAnimated(true)
                
                self.finishSendingMessage()
                
                },number: UInt(loadCount))
    }
    
    //Did tap message bubble
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!){
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        var data = messages[indexPath.row]
        
        if (data.senderId == self.senderId) {
            
            return self.outgoingBubble
            
        } else {
            
            return self.incomingBubble
            
        }
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return nil
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count;
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return CGFloat(16.0)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString!{
        
        var message = messages[indexPath.row]
        self.stringTime  = TimeFormater.formatFromFormatTemplate(message.date, format: DateFormatesOptions.DEFAULT_FORMAT_WITH_HOUR) as String
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            
            let previousMessage = messages[indexPath.item - 1];
            
            let previousTime  = TimeFormater.formatFromFormatTemplate(previousMessage.date, format: DateFormatesOptions.DEFAULT_FORMAT_WITH_HOUR) as String
            
            if previousTime == self.stringTime {
                
                return nil;
            }
        }
        var time = TimeFormater.dateFromString(self.stringTime, format: DateFormatesOptions.DEFAULT_FORMAT_WITH_HOUR)
        
        var timeString:String! = TimeFormater.messagesDateFormat(time)
        return NSAttributedString(string:timeString)
    }
      
}

