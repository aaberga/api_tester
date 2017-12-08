//
//  REST_Configuration.swift
//  TeamWork
//
//  Created by Aldo Bergamini on 03/12/2017.
//  Copyright © 2017 iBat. All rights reserved.
//

import Foundation

import SwiftyJSON


func REST_ConfigurationFactory(data: [String: Any]) -> REST_Configuration? {
    
    do {
        
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        var json: JSON? = JSON(data: jsonData)
        let restConfig = REST_Configuration(json: &json)
        
        return restConfig
        
    } catch {
        
        DLogWith(message: "Error: \(error.localizedDescription)")
    }
    
    return nil
}


class REST_Configuration: JSONStore {
    
    
    var host: String? {
        
        get {
            
            let pathJSON = self.readJSON(atPath: "host")?.string
            return pathJSON
        }
    }
  
    var basepath: String? {
        
        get {
            
            let pathJSON = self.readJSON(atPath: "basepath")?.string
            return pathJSON
        }
    }
    
    var paths: [String: JSON]? {
        
        get {
            
            let pathsJSON = self.readJSON(atPath: "paths")?.dictionary
            return pathsJSON
        }
    }
    
    var schemes: [String]? {
        
        get {
            
            if let schemesArray = self.jsonData?.dictionary?["schemes"]?.arrayValue {
                
                var stringArray = [String]()
                
                for currentValue in schemesArray {
                    
                    if let stringValue = currentValue.string {
                        stringArray.append(stringValue)
                    }
                }
                return stringArray
            }
            
            return nil
        }
    }
    
    func callDataFor(path targetPath: String, callType targetCallType: String) -> [String: JSON]? {
        
        let presentPaths = self.paths
//        DLogWith(message: "Data: \(String(describing: presentPaths))")
        
        if let presentPaths = presentPaths {
            
            let pathData = presentPaths[targetPath]?.dictionary
//            DLogWith(message: "Data for path: \(String(describing: pathData))")

            if let foundPathData = pathData {
                
                let foundCallTypeData = foundPathData[targetCallType]?.dictionary
                return foundCallTypeData
            }
        }
        
        return nil
    }
}
