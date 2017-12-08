//
//  JSONElement.swift
//  
//
//  Created by Aldo Bergamini on 23/02/2017.
//
//

import Foundation
import SwiftyJSON





class JSONElement: JSONLeaf {
    
    // MARK: Properties
    
    var leafPath: String {
        
        get {
            
            return self.objectPath
        }
    }
    
    var jsonTrunk: JSONManager {
        
        get {
            
            return self.jsonManager
        }
    }
    
    var jsonData: JSON? {
        
        get {
            
            return self.readJSON()
        }
        
        set (jsonObj) {
            
            if let jsonObj = jsonObj {
                
                self.setJSON(json: jsonObj)
            }
        }
    }
    
    var address: String {
        
        get {
            
            let objAddress = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            let addressString = String(describing: objAddress)

            return addressString
        }
    }
    
    var description: String {
        
        get {
            
            let classNameString = String(describing: type(of: self))
            
            return classNameString + " <" + self.address + ">"
        }
    }
    
    
    
    // MARK: Class Properties

  
    // MARK: Private Properties
    
    private var objectPath: String!
    private var jsonManager: JSONManager!

    
    #if DEBUG
    private var jsonAny: Any!
    private var jsonString: String!
    #endif
    
    
    // MARK: - Methods
    // MARK: Object Life Cycle
    
    convenience init() {
        
        // Does this init method make sense at all??
        // Leaf without trunk??
        
        // Yes! Indeed: we need this when defining a new form field, that will be added to the JSON tree at a later point in time!
        
        var jsonObject: JSON? = JSON(arrayLiteral: [])
        let jsonStore = JSONStore(json: &jsonObject)
        self.init(jsonObject: jsonStore)
    }
    
    
    convenience init(jsonObject: JSONManager, withParentPath parentPath: String, fromTemplate jsonTemplate: JSON, atTargetPath targetPath: String) {
        
        // FIXME: Maintain json manager; and tell it to add json template at path path...
        
        self.init(jsonObject: jsonObject)
        
        // TODO: Insert templateJSON at its path!!
        jsonObject.setJSON(json: jsonTemplate, atPath: targetPath)
        
        self.objectPath = targetPath
        
//        DLogWith(message: "JSON tree: \(String(describing: self.jsonTrunk.json))")

        #if DEBUG
            jsonAny = jsonObject.readJSON(atPath: parentPath)!.rawValue
            jsonString = jsonObject.readJSON(atPath: parentPath)!.rawString()

            DLogWith(message: "jAny: \(self.jsonAny)")
            DLogWith(message: "jString: \(self.jsonString)")
        #endif

    }

    required init(jsonObject: JSONManager, withPath path: String = "") {
        
        self.objectPath = path
        self.jsonManager = jsonObject
        
        #if DEBUG
            jsonAny = jsonObject.readJSON(atPath: path)!.rawValue
            jsonString = jsonObject.readJSON(atPath: path)!.rawString()
        #endif

    }
    
    
    // MARK: JSON Accessors
    
    func setJSON(json: JSON) {
        
        self.jsonManager.setJSON(json: json, atPath: self.objectPath)
    }
    
    func readJSON() -> JSON? {
        
        return self.jsonManager.readJSON(atPath: self.objectPath)
    }
    
    // MARK: Object Interface Methods
    
    func setProperty(withKey key: String, toValue value: Any) {
        
        var propertyPath = ""
        if key != "" {
            
           propertyPath = self.objectPath + "." + key
            
        } else {
            
            propertyPath = self.objectPath
        }
        
        let passedValueAsJSON: JSON? = value as? JSON
        
        if let passedValueAsJSON = passedValueAsJSON {
            
            self.jsonManager.setJSON(json: passedValueAsJSON, atPath: propertyPath)

        } else {
            
            let jsonValue = JSON(object: value)
            self.jsonManager.setJSON(json: jsonValue, atPath: propertyPath)
        }
    }
    
    
    func readProperty(withKey key: String) -> Any? {
        
        let propertyPath = self.objectPath + "." + key
        let propertyValue = self.jsonManager.readJSON(atPath: propertyPath)
        
        return propertyValue
    }
    
    
    // MARK: More Object Interface Methods
    
    func booleanProperty(key keyValue: String) -> Bool? {
        
        let property = self.jsonData?.dictionary?[keyValue]?.bool
        return property
    }
    
    func stringProperty(key keyValue: String) -> String? {
        
        let property = self.jsonData?.dictionary?[keyValue]?.stringValue
        return property
    }
    
    func integerProperty(key keyValue: String) -> Int? {
        
        let property = self.jsonData?.dictionary?[keyValue]?.intValue
        return property
    }
    
    func doubleProperty(key keyValue: String) -> Double? {
        
        let property = self.jsonData?.dictionary?[keyValue]?.double
        return property
    }
    
    func floatProperty(key keyValue: String) -> Float? {
        
        let property = self.jsonData?.dictionary?[keyValue]?.float
        return property
    }
    
    func numberProperty(key keyValue: String) -> NSNumber? {
        
        let property = self.jsonData?.dictionary?[keyValue]?.number
        return property
    }
    
    func arrayProperty(key keyValue: String) -> [JSON]? {
        
        let property = self.jsonData?.dictionary?[keyValue]?.array
        return property
    }
    
    func dictionaryProperty(key keyValue: String) -> [String : JSON]? {
        
        let property = self.jsonData?.dictionary?[keyValue]?.dictionary
        return property
    }
    
    
    
}
