//
//  Helpers.swift
//  CamilloRESTFramework
//
//  Created by Aldo Bergamini on 15/11/2017.
//
//

import Foundation




// **************************************************************


// MARK: - Generic Helper Functions

// MARK: Convert from NSData to JSON and back

func stringToData(_ string: String) -> Data? {
    
    let data = string.data(using: .utf8)
    
    return data
}

func nsdataToJSON(_ data: Data) -> Any? {
    do {
        return try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .allowFragments])
    } catch let myJSONError {
        print("nsdataToJSON: \(myJSONError)")
    }
    return nil
}


func jsonToNSData(_ json: AnyObject) -> Data? {
    do {
        return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
    } catch let myJSONError {
        print("jsonToNSData: \(myJSONError)")
    }
    return nil;
}

// MARK: Convert from NSData to String and back

func nsdataToString(_ data: Data) -> NSString? {
    
    let datastring = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    return datastring
}

func stringToJSON(_ text: String) -> Any? {
    if let data = text.data(using: String.Encoding.utf8) {
        return nsdataToJSON(data)
    }
    return nil
}

