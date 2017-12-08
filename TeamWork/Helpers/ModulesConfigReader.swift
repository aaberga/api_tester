//
//  ModulesConfigReader.swift
//
//
//  Created by Aldo Bergamini on 25/04/2016.
//
//

import Foundation

class ModulesConfigReader {
    
    var configFilePath: String?
    var targetFileName: String?
    
    var configData: NSDictionary?
    
    func loadDataFile(_ filename: String) {
    
//        DLogWith(message: "File: \(filename)")
        
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: filename, ofType: "plist")

        if let path = path {
            
            let readDict = NSDictionary(contentsOfFile: path)
            if let dataDict = readDict {
                self.configData = dataDict
            }
        }
    }
    
    func getDataProperty(key targetKey:String) -> AnyObject? {
        
        var result: AnyObject?
        
        result = self.configData?.object(forKey: targetKey) as AnyObject?
        
        return result
    }
    
    
    func getAllData() -> NSDictionary? {
        
        return configData
    }
}
