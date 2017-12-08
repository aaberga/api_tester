//
//  JSONStore.swift
//
//
//  Created by Aldo Bergamini on 23/02/2017.
//  
//

import Foundation
import SwiftyJSON




class JSONStore: JSONManager {
    
    // MARK: Properties
    
    var json: JSON? {
        
        get {
            
            return self.jsonData
        }
    }
    
    
    // MARK: Private Properties
    
//    fileprivate var jsonData: JSON?
    var jsonData: JSON?
    
    #if DEBUG
    private var jsonAny: Any!
    private var jsonString: String!
    #endif
    
    
    
    // MARK: Object Life Cycle
    
    required init(json model:inout JSON?) {
        
        self.jsonData = model
        
        #if DEBUG
            jsonAny = self.jsonData!.rawValue
            jsonString = self.jsonData!.stringValue
        #endif
        
    }
    
    // MARK: JSON Accessors
    
    func setJSON(json: JSON) {
        
        self.jsonData = json
    }
    
    func setJSON(json: JSON, atPath path: String) {
        
        if let _ = self.jsonData {
            
            let pathStrArray = path.components(separatedBy: ".")
            let pathArray = pathStrArray.map { (value: String) -> (JSONSubscriptType) in
                
                let compAsNumber = Int(value)
                if let compAsNumber = compAsNumber {
                    
                    return compAsNumber as (JSONSubscriptType)
                    
                } else {
                    
                    return value as (JSONSubscriptType)
                }
            }
            
            //            DLogWith(message: "Now jTree: \(self.jsonData![pathArray])")
            
            self.jsonData![pathArray] = json
            
            //            DLogWith(message: "And now jTree: \(self.jsonData![pathArray])")
        }
    }
    
    func setJSON(json: JSON, forNode leaf: JSONLeaf) {
        
        let leafPath = leaf.leafPath
        self.setJSON(json: json, atPath: leafPath)
    }
    
    func readJSON() -> JSON? {
        
        return self.jsonData
    }
    
    func readJSON(atPath path: String) -> JSON? {
        
        var json: JSON? = nil
        if let jsonData = self.jsonData {
            
            let pathStrArray = path.components(separatedBy: ".")
            let pathArray = pathStrArray.map { (value: String) -> (JSONSubscriptType) in
                
                let compAsNumber = Int(value)
                if let compAsNumber = compAsNumber {
                    return compAsNumber as (JSONSubscriptType)
                } else {
                    return value as (JSONSubscriptType)
                }
            }
            json = jsonData[pathArray]
        }
        
        return json
    }
    
    func readJSON(forNode leaf: JSONLeaf) -> JSON? {
        
        let leafPath = leaf.leafPath
        return self.readJSON(atPath: leafPath)
    }
    
    
    // MARK: Object Interface Methods
    
    func loadJSON(readConfig readParams: [String: Any]?) {
        
        assert(false, "Abstract method! Do Not Call Me!!")
    }
    
    func saveJSON(writeConfig writeParams: [String: Any]?) {
        
        assert(false, "Abstract method! Do Not Call Me!!")
    }
}
