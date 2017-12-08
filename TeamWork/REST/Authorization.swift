//
//  Authorization.swift
//  TeamWork
//
//  Created by Aldo Bergamini on 03/12/2017.
//  Copyright © 2017 iBat. All rights reserved.
//

import Foundation



class Authorization {
    
    func authTokenFor(apiKey key: String) -> String {
        
        let apiKeyString = String(format: "%@:xxx", key)
        let utfAPIKey = apiKeyString.data(using: String.Encoding.utf8)!
        let encodedAPIKey = utfAPIKey.base64EncodedString()
        let authToken = String(format: "BASIC %@", encodedAPIKey)
        //        DLogWith(message: "Auth: \(authToken)")
        
        return authToken
    }

}
