//
//  Refrences.swift
//  MyChatTest
//
//  Created by Mohamed Arafa on 3/15/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import Foundation
import Firebase

enum FCollectionReference: String {
    
    case User
    case Recent
    case Message
}


func reference(_ collectionReference: FCollectionReference) -> String{
    return collectionReference.rawValue
}
