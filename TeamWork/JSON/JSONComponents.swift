//
//  JSONComponents.swift
//
//
//  Created by Aldo Bergamini on 20/01/2017.
//  
//

import Foundation
import SwiftyJSON


let kGridColumnElementsTotal = 24
let kLayoutStandard = (origin: CGPoint(x: 32, y:32), border: CGSize(width: 32, height: 32), padding: CGSize(width: 8, height: 4))



protocol JSONManager {

    // MARK: Properties
    
    var json: JSON? { get }
    
    
    // MARK: - Methods
    // MARK: Object Life Cycle
    
    init(json model: inout JSON?)
    
    
    // MARK: JSON Accessors
    
    func setJSON(json: JSON)
    func setJSON(json: JSON, atPath path: String)
    func setJSON(json: JSON, forNode leaf: JSONLeaf)
    
    func readJSON() -> JSON?
    func readJSON(atPath path: String) -> JSON?
    func readJSON(forNode leaf: JSONLeaf) -> JSON?
    
    func loadJSON(readConfig readParams: [String: Any]?)
    func saveJSON(writeConfig writeParams: [String: Any]?)
}



protocol JSONLeaf {

    // MARK: Properties
    
    var leafPath: String { get }
    var jsonTrunk: JSONManager { get }
    
    // MARK: - Methods
    // MARK: Object Life Cycle
    
    init(jsonObject: JSONManager, withPath path: String)
    
    
    // MARK: JSON Accessors
    
    func setJSON(json: JSON)
    func readJSON() -> JSON?
    
    
    // MARK: Object Interface Methods
    
    func setProperty(withKey key: String, toValue value: Any)
    func readProperty(withKey key: String) -> Any?
    
    
    // MARK: More Object Interface Methods
    
    func booleanProperty(key keyValue: String) -> Bool?
    func stringProperty(key keyValue: String) -> String?
    func integerProperty(key keyValue: String) -> Int?
    func doubleProperty(key keyValue: String) -> Double?
    func floatProperty(key keyValue: String) -> Float?
    func numberProperty(key keyValue: String) -> NSNumber?
    func arrayProperty(key keyValue: String) -> [JSON]?
    func dictionaryProperty(key keyValue: String) -> [String : JSON]?
}
