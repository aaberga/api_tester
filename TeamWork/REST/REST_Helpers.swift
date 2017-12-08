//
//  PAW_REST_Helpers.swift
//
//
//  Created by Aldo Bergamini on 23/04/2016.
//

import Foundation

import Regex
import SwiftyJSON


// MARK: - Data Manager REST Helper Methods

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = NSString(format: "%@=%@",
                                String(describing: key).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!,
                                String(describing: value).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
}

extension URL {
    
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new NSURL.
     */
    
    func URLByAppendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : NSString = NSString(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString as String)!
    }
}


extension URL {
    
    /**
     Creates a new URL by replacing the given path parameters.
     @param parametersDictionary The path parameter dictionary to add.
     @return A new NSURL.
     */
    
    func URLByReplacingPathParameters(_ paramsDict: [AnyHashable: Any]) -> URL {
        
        var decoratedURLString: String = self.absoluteString
        
        for currenParamKey in paramsDict.keys {
            
            let keyString = currenParamKey as? String
            var partialURLString = decoratedURLString
            
            if let keyString = keyString {
                
                let valueString = paramsDict[keyString] as? String
                let escapedValueString = valueString?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
                let keyTarget = String(format: "%%7B%@%%7D", keyString)
                
                if let escapedValueString = escapedValueString {
                    let updatedURLString = keyTarget.r?.replaceAll(in: partialURLString, with: escapedValueString)
                    
                    if let updatedURLString = updatedURLString {
                        
                        partialURLString = updatedURLString
                    }
                }
            }
            
            decoratedURLString = partialURLString
        }
        
        return URL(string: decoratedURLString as String)!
    }
}

extension String {
    
    static func URLStringByReplacingPathPlaceholders(url urlString: String, withParameters paramsDict: [AnyHashable: Any]) -> String {
        
        var decoratedURLString: String = urlString
        
        for currenParamKey in paramsDict.keys {
            
            let keyString = currenParamKey as? String
            var partialURLString = decoratedURLString
            
            if let keyString = keyString {
                
                let valueString = paramsDict[keyString] as? String
                let keyTarget = String(format: "\\{%@\\}", keyString)
                
                if let valueString = valueString {
                    
                    let updatedURLString = keyTarget.r?.replaceAll(in: partialURLString, with: valueString)
                    if let updatedURLString = updatedURLString {
                    
                        partialURLString = updatedURLString
                    }
                }
            }
            
            decoratedURLString = partialURLString
        }
        
        return decoratedURLString
    }
}
