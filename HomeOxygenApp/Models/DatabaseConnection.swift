//
//  DatabaseConnection.swift
//  HomeOxygenApp
//
//  Created by Amr Mousa on 19.8.2020.
//  Copyright © 2020 Amr Mousa. All rights reserved.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth

let dataBase = DatabaseConnection()
class DatabaseConnection {
    let db = Firestore.firestore()

    func sendHeartRate(_ BPM: Int, date: Date)
    {
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("patients").document("\(userId)").updateData([ "heartRate.\(date.year).\(date.month).\(date.day).\(date.minute)": BPM ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }
}
