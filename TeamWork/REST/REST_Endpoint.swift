//
//  REST_Endpoint.swift
//  TeamWork
//
//  Created by Aldo Bergamini on 04/12/2017.
//  Copyright © 2017 iBat. All rights reserved.
//

import Foundation
import SwiftyJSON



let kSlash = "/"



enum REST_EndpointError: Error {
    
    case unknownError
    case readConfiguratonError
    case missingActionParameterError
    case missingQueryParameterError
    case missingBodyParameterError
    case missingHeaderError
}


class REST_Endpoint {
    
    // MARK: -  Properties

    var apiConfigName: String? {
        
        get {
            return self.configResourceName
        }
        
        set (targetResName) {
            self.configResourceName = targetResName
        }
    }
    
    var host: String? {
        
        get {
            if self.hostString != "" {
                return self.hostString
            } else {
                return nil
            }
        }
    }
    
    var baseURL: String? {
        
        get {
            
            if self.hostString != "" && self.baseURLPath != "" {
                
                let baseURL = self.hostString + self.baseURLPath
                return baseURL
                
            } else if self.hostString != "" {
                
                return self.hostString
                
            } else {
                return nil
            }
        }
    }

    var currentCallParameters: (actionParams: [String: String], queryParams: [String: String], bodyParams: [String: String])? {
        
       get {
        
            return self.callParameters
        }
    }
    
    // MARK: - Methods
    
    func prepareFor(path targetPath: String, apiCallType callType: String) {
        
        if let _ = self.apiConfigData {
        } else {
            
            do {
                try self.readAPIConfig()
            } catch {
                return
            }
        }
        
        if let data = self.apiConfigData {
            
            if let _ = self.restConfig {
            } else {
                self.restConfig = REST_ConfigurationFactory(data: data)
            }
            
            let protocolString = self.restConfig?.schemes?[0]
            let hostString = self.restConfig?.host
            let baseURLPath = self.restConfig?.basepath
            
            let apiCallData = self.restConfig?.callDataFor(path: targetPath, callType: callType)
            
            if let protocolString = protocolString, let hostString = hostString, let baseURLPath = baseURLPath, let apiCallData = apiCallData {
                
                if let targetProtocol = API_Protocols(rawValue: protocolString) {
                    
                    self.apiConfigData = apiCallData
                    self.targetProtocol = targetProtocol
                    self.hostString = hostString
                    self.baseURLPath = baseURLPath
                    self.actionPath = targetPath
                    
                    if let baseURLPathLast = baseURLPath.last, let actionPathFirst = actionPath.first {
                        
                        if baseURLPathLast == actionPathFirst && baseURLPathLast == "/" {
                            let truncated = baseURLPath.substring(to: baseURLPath.index(before: baseURLPath.endIndex))
                            self.baseURLPath = truncated
                        }
                    }
//                    DLogWith(message: "apiCallData: \(apiCallData)")
                    let parameters = apiCallData["parameters"]?.dictionary
                    if let parameters = parameters {
                        
                        let pathParams = parameters["path"]?.array
                        let queryParams = parameters["query"]?.array
                        let bodyParams = parameters["body"]?.array
                        
                        if let pathParams = pathParams {
                            for currPathParameter in pathParams {
                                
//                                DLogWith(message: "currPathParameter: \(currPathParameter)")
                                let paramName = currPathParameter["name"].string
                                if let paramName = paramName {
                                    self.apiActionParams[paramName] = currPathParameter
                                }
                            }
                        }
                        
                        if let queryParams = queryParams {
                            for currQueryParameter in queryParams {
                                
//                                DLogWith(message: "currPathParameter: \(currQueryParameter)")
                                let paramName = currQueryParameter["name"].string
                                if let paramName = paramName {
                                    self.apiQueryParams[paramName] = currQueryParameter
                                }
                            }
                        }
                        
                        if let bodyParams = bodyParams {
                            for currBodyParameter in bodyParams {
                                
//                                DLogWith(message: "currPathParameter: \(currBodyParameter)")
                                let paramName = currBodyParameter["name"].string
                                if let paramName = paramName {
                                    self.apiBodyParams[paramName] = currBodyParameter
                                }
                            }
                        }

                    }
                }
            }
        }
    }
   
//    func prepareFor(operation id: String, apiCallType callType: String) {
//    }
    
    func addHeader(_ header: String, required: Bool) {
        
        self.apiHeaders[header] = required
    }

    func setupCallWith(parameters params: [String: Any]?, headers: [String: Any]?) throws {
        
        var actionParams: [String: String] = [:]
        var queryParams: [String: String] = [:]
        var bodyParams: [String: String] = [:]
        
        if let headers = headers {
            
            self.callHeaders = headers
        }
        
        for currentKey in self.apiActionParams.keys {
            
            let keyValue = params?[currentKey]
            if let keyValue = keyValue {
                
                actionParams[currentKey] = String(describing:keyValue)
                
            } else {
                
                throw REST_EndpointError.missingActionParameterError
            }
        }
        
        for currentKey in self.apiQueryParams.keys {
            
            let keyValue = params?[currentKey]
            if let keyValue = keyValue {
                
                queryParams[currentKey] = String(describing:keyValue)
                
            } else {
                
                throw REST_EndpointError.missingQueryParameterError
            }
        }
        
        for currentKey in self.apiBodyParams.keys {
            
            let keyValue = params?[currentKey]
            if let keyValue = keyValue {
                
                bodyParams[currentKey] = String(describing:keyValue)
                
            } else {
                
                throw REST_EndpointError.missingBodyParameterError
            }
        }

        // NB: With more time one would reasonably do parameter type checking here...
        
        self.callParameters = (actionParams: actionParams, queryParams: queryParams, bodyParams: bodyParams)
    }
    
    func doCallWith(responseHandler: @escaping ((Any?, Error?) -> Void)) {
        
        let restAPIObj = REST_API()

        let root_base_URL = self.baseURL
        let action = self.actionPath
        let headers = self.callHeaders as? [String: String]
        self.receiveResponse = responseHandler
        let pathParams = self.callParameters?.actionParams
        let queryParams = self.callParameters?.queryParams
        
        if let headers = headers, let root_base_URL = root_base_URL, let pathParams = pathParams, let queryParams = queryParams  {
            
            let resolvedAction = String.URLStringByReplacingPathPlaceholders(url: action, withParameters: pathParams)
            restAPIObj.doGET(withProtocol: targetProtocol, URLRootString: root_base_URL, URLActionString: resolvedAction, andHeadersDictionary: headers, andURLParamsDictionary: queryParams, withCompletionBlock: self.receiveCallResults)
        }
    }
    
    
    func receiveCallResults(_ data: Data?, response: URLResponse?, error: Error?) -> Void {
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        if let _ = statusCode {
            
//            DLogWith(message: "Response Code: \(statusCode)")
            
        } else {
            
            DLogWith(message: "No Response Code!")
        }
        
        if let returnedError = error {
            
//            DLogWith(message: "Error in API call! \(String(describing: error))")
            self.receiveResponse?(nil, returnedError)
        }
        
        if let data = data {
            
            let responseObject: [String: Any]? = nsdataToJSON(data) as? [String: Any]
            let responseArray: [Any]? = nsdataToJSON(data) as? [Any]
            
            if let responseObject = responseObject {
                
//                DLogWith(message: "JSON Object: \(responseObject)")
                self.receiveResponse?(responseObject , error)
                return
            }
            
            if let responseArray = responseArray {
                
//                DLogWith(message: "JSON Array: \(responseArray)")
                
                self.receiveResponse?(responseArray, error)
                return
            }
        }
    }

    // MARK: - Private Methods

    private func readAPIConfig() throws {
        
        if let resourceName = self.configResourceName {
            let resourceReader = ModulesConfigReader()
            resourceReader.loadDataFile(resourceName)
            
            let configData = resourceReader.configData
            if let configData = configData {
                
                self.apiConfigData = configData as? [String: Any]
                
            } else {
                
                throw REST_EndpointError.readConfiguratonError
            }
        }
    }
    
    // MARK: - Private Properties

    private var configResourceName: String?
    private var apiConfigData: [String: Any]? = nil
    
    private var restConfig: REST_Configuration? = nil
    private var restAPI: REST_API? = nil
    
    private var hostString: String = ""
    private var baseURLPath: String = ""
    private var actionPath: String = ""

    private var targetProtocol: API_Protocols = .https

    private var apiHeaders: [String: Any] = [:]
    private var apiActionParams: [String: JSON] = [:]
    private var apiQueryParams: [String: JSON] = [:]
    private var apiBodyParams: [String: JSON] = [:]

    private var callHeaders: [String: Any]? = nil
    private var callParameters: (actionParams: [String: String], queryParams: [String: String], bodyParams: [String: String])? = nil

    private var receiveResponse: ((_ result: Any?, _ error: Error?) -> Void)? = nil
    
}
