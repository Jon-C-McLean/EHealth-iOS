//
//  DoctorUrgentChatController.swift
//  EHealth
//
//  Created by Jon McLean on 4/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase

class DoctorUrgentChatController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    let api = API.shared
    let db = Firestore.firestore()
    
    var messages: [Message] = [] {
        didSet {
            self.messagesCollectionView.reloadData()
        }
    }
    
    var user: User
    var doctor: DoctorAPI
    var messageGroup: MessageGroup
    var urgentCase: UrgentCase
    var patient: Patient?
    var patientUser: User?
    
    var session: Session?
    
    init(user: User, doctor: DoctorAPI, messageGroup: MessageGroup, urgentCase: UrgentCase, patient: Patient?, patientUser: User?) {
        self.user = user
        self.patient = patient
        self.messageGroup = messageGroup
        self.urgentCase = urgentCase
        self.doctor = doctor
        self.patientUser = patientUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardOnTapAround()
        
        if let s = Session.load() {
            self.session = s
        }else {
            self.navigationController?.pushViewController(LoginController(), animated: true)
        }
        
        print("view")
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        db.collection("message-group").document("\(messageGroup.id)").collection("message").addSnapshotListener { (snapshot, error) in
            if let snapshot = snapshot {
                let docs = snapshot.documents
                self.messages = []
                for i in docs {
                    let message = Message(id: i["messageId"] as! Int, userId: i["userId"] as! Int, groupId: i["messageGroupId"] as! Int, content: i["content"] as! String, timestamp: i["timestamp"] as! String)
                    self.messages.append(message)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if let du = self.patientUser {
            self.navigationItem.title = "\(du.firstName) \(du.lastName)"
        }
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreMenu)), animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    func loadMessages() {
        let docRef = db.collection("message-group").document("\(messageGroup.id)").collection("message")
        
        docRef.getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                print("snapshot")
                let docs = snapshot.documents
                for i in docs {
                    let message = Message(id: i["messageId"] as! Int, userId: i["userId"] as! Int, groupId: i["messageGroupId"] as! Int, content: i["content"] as! String, timestamp: i["timestamp"] as! String)
                    self.messages.append(message)
                }
            }
        }
    }
    
    @objc func moreMenu() {
        let actionSheet = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Resolve", style: .default, handler: { (_) in
            self.resolve()
        }))
        actionSheet.addAction(UIAlertAction(title: "Open Details", style: .default, handler: { (_) in
            self.present(UrgentCaseDetailsController(urgentCase: self.urgentCase), animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func resolve() {
        api.resolveCase(caseId: self.urgentCase.id, token: self.session!.token, success: { (response) in
            if let model = try? JSONDecoder().decode(UrgentCase.self, from: response) {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            print("failed to resolve case")
        }
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> SenderType {
        return UserSender(senderId: "\(self.user.userId)", displayName: self.user.firstName + self.user.lastName)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        let u = self.messages[indexPath.row].userId == self.user.userId ? (self.user.firstName + " " + self.user.lastName) : "Patient"
        
        return ChatMessage(sender: UserSender(senderId: "\(self.messages[indexPath.row].userId)", displayName: u), messageId: "\(messages[indexPath.row].id)", sentDate: messages[indexPath.row].timestamp, kind: .text(messages[indexPath.row].content))
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if let content = inputBar.inputTextView.text, content != "" {
            api.sendMessage(groupId: self.messageGroup.id, token: self.session!.token, content: content, success: { (response) in
                if let model = try? JSONDecoder().decode(Message.self, from: response) {
                    inputBar.inputTextView.text = ""
                }
            }) { (error) in
                print("Failure")
            }
        }
    }
}

