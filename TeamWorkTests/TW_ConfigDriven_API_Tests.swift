//
//  TW_ConfigDriven_API_Tests.swift
//  TeamWorkTests
//
//  Created by Aldo Bergamini on 03/12/2017.
//  Copyright © 2017 iBat. All rights reserved.
//

import XCTest


@testable import TeamWork

let kTW_API_Config = "TeamWorkAPI_Lite"


class TW_ConfigDriven_API_Tests: XCTestCase {
    
    var apiConfigData: [String: Any]? = nil
    var currentExpectation: XCTestExpectation?

    override func setUp() {
        super.setUp()
        
        let resourceReader = ModulesConfigReader()
        
        resourceReader.loadDataFile(kTW_API_Config)
        
        let configData = resourceReader.configData
        if let configData = configData {
            
            self.apiConfigData = configData as? [String: Any]
        }
    }
    
    override func tearDown() {

        self.apiConfigData = nil
        super.tearDown()
    }

    
    func test_LoadConfig() {
        
//        DLogWith(message: "API Desc: \(String(describing: self.apiConfigData))")
        
        if let readData = self.apiConfigData {
            
            if let host = readData["host"] as? String {
                
                XCTAssert(host == "yat.teamwork.com", "Could not read expected host, but \(host)")
            }
            
            if let paths = readData["paths"] as? [String: Any] {
                
                let pathKeysNo = Array(paths.keys).count
                
                XCTAssert(pathKeysNo == 4, "Could not read expected number of paths, but \(pathKeysNo)")
            }
        }
    }
    
    func test_ExtractCommandInfo() {
        
        let kTargetPath = "/projects.json"
        
        if let readData = self.apiConfigData {
            
            if let paths = readData["paths"] as? [String: Any] {
                
                let apiGETCallData = paths[kTargetPath] as? [String: Any]
                if let projectsAPICallData = apiGETCallData {
                    
                    let getProjectsAPICallData = projectsAPICallData["GET"] as? [String: Any]
                    
                    if let getProjectsAPICallData = getProjectsAPICallData {
                        
                        let commandSummary = getProjectsAPICallData["summary"] as! String
                        
                        XCTAssert(commandSummary == "Projects List", "Got unexpected summary, \(commandSummary)")
                        
                    } else {
                    
                        XCTFail("Could not find <\(kTargetPath) API description!!>")
                    }
                    
                } else {
                    
                    XCTFail("Could not find <\(kTargetPath) API description!!>")
                }
            }
        }
    }
    
    func test_RunListProjectsAPICommand() {
        
        let expectation = self.expectation(description: "test_RunListProjectsAPICommand")
        self.currentExpectation = expectation
        
        let kTargetPath = "/projects.json"
        
        if let readData = self.apiConfigData {
            
            if let paths = readData["paths"] as? [String: Any] {
                
                let apiGETCallData = paths[kTargetPath] as? [String: Any]
                if let projectsAPICallData = apiGETCallData {
                    
                    let getProjectsAPICallData = projectsAPICallData["GET"] as? [String: Any]
                    if let getProjectsAPICallData = getProjectsAPICallData {
                        
//                        DLogWith(message: "GET data: \(getProjectsAPICallData)")
                        let restAPIObj = REST_API()
                        if let protocols = readData["schemes"] as? [String] {
                            
                            let apiProtocol = protocols[0]
                            
                            let targetProtocol = API_Protocols.init(rawValue: apiProtocol)
                            let hostName = readData["host"] as? String
                            let basePath = readData["basepath"] as? String
                            let command = getProjectsAPICallData["command"] as? String
                            
                            let authToken = Authorization().authTokenFor(apiKey: key)
                            let headers = [kAuthorizationHeader: authToken, kContentTypeHeader: kAppJsonContent]
                            
                            if let targetProtocol = targetProtocol, let hostName = hostName, let basePath = basePath, let _ = command {
                                
                                let baseURL = hostName + kSlash + basePath
                                let action = kTargetPath
                                
//                                DLogWith(message: "Command: \(command)")
                                
                                restAPIObj.doGET(withProtocol: targetProtocol, URLRootString: baseURL, URLActionString: action, andHeadersDictionary: headers, andURLParamsDictionary: nil, withCompletionBlock: self.receiveCallResults)
                            }
                        }
                    }
                }
            }
            
            // *****************
            
            waitForExpectations(timeout: 5) { error in
                
                if let error = error { XCTFail("Failed with timeout error: \(error)") }
            }

        }
        
    }
    
    
    func receiveCallResults(_ data: Data?, response: URLResponse?, error: Error?) -> Void {
        
//        if let data = data {
//            let result = nsdataToJSON(data)
//            DLogWith(message: "Result: \(String(describing: result))")
//            self.currentExpectation?.fulfill()
//        }

        if let _ = data {

            self.currentExpectation?.fulfill()
        }
    }
    
    func test_CreateREST_Configuration() {
        
        if let configData = self.apiConfigData {
            
            let restConfig = REST_ConfigurationFactory(data: configData)
            
            let hostString = restConfig?.host
            
            if let hostString = hostString {
                
                XCTAssert(hostString == "yat.teamwork.com")
            }
            
            if let paths = restConfig?.paths {
                
                XCTAssert(paths.count == 4)
            }
        }
    }

    func test_RunListProjectsAPICommandUsingConfigObject() {
        
        let expectation = self.expectation(description: "test_RunListProjectsAPICommand")
        self.currentExpectation = expectation
        
        let kTargetPath = "/projects.json"
        
        if let configData = self.apiConfigData {
            
            let restConfig = REST_ConfigurationFactory(data: configData)
            let protocolString = restConfig?.schemes?[0]
            let hostString = restConfig?.host
            let baseURLPath = restConfig?.basepath
            
            let authToken = Authorization().authTokenFor(apiKey: key)
            let headers = [kAuthorizationHeader: authToken, kContentTypeHeader: kAppJsonContent]

            let apiPaths = restConfig?.paths

            let apiCallData = apiPaths?[kTargetPath]

            if let protocolString = protocolString, let hostString = hostString, let baseURLPath = baseURLPath, let _ = apiCallData {
                
                if let targetProtocol = API_Protocols.init(rawValue: protocolString) {
                
                    let restAPIObj = REST_API()

                    let baseURL = hostString + kSlash + baseURLPath
                    let action = kTargetPath
                
                    restAPIObj.doGET(withProtocol: targetProtocol, URLRootString: baseURL, URLActionString: action, andHeadersDictionary: headers, andURLParamsDictionary: nil, withCompletionBlock: self.receiveCallResults)
                }
            }
            
            // *****************
            
            waitForExpectations(timeout: 5) { error in
                
                if let error = error { XCTFail("Failed with timeout error: \(error)") }
            }
        }
    }
    
    func test_RunListProjectsAPICommandUsingConfigObjectWithPathLookup() {
        
        let expectation = self.expectation(description: "test_RunListProjectsAPICommand")
        self.currentExpectation = expectation
        
        let kTargetPath = kProjectsAction
        let kTargetCallType = "GET"
        
        if let configData = self.apiConfigData {
            
            let restConfig = REST_ConfigurationFactory(data: configData)
            let protocolString = restConfig?.schemes?[0]
            let hostString = restConfig?.host
            let baseURLPath = restConfig?.basepath
            
            let authToken = Authorization().authTokenFor(apiKey: key)
            let headers = [kAuthorizationHeader: authToken, kContentTypeHeader: kAppJsonContent]
            
            let apiCallData = restConfig?.callDataFor(path: kTargetPath, callType: kTargetCallType)
            
            if let protocolString = protocolString, let hostString = hostString, let baseURLPath = baseURLPath, let apiCallData = apiCallData {
                
                DLogWith(message: "Found: \(String(describing: apiCallData))")

                if let targetProtocol = API_Protocols(rawValue: protocolString) {
                    
                    let restAPIObj = REST_API()
                    
                    let baseURL = hostString + kSlash + baseURLPath
                    let action = kTargetPath
                    
                    restAPIObj.doGET(withProtocol: targetProtocol, URLRootString: baseURL, URLActionString: action, andHeadersDictionary: headers, andURLParamsDictionary: nil, withCompletionBlock: self.receiveCallResults)
                }
            }
            
            // *****************
            
            waitForExpectations(timeout: 5) { error in
                
                if let error = error { XCTFail("Failed with timeout error: \(error)") }
            }
        }

    }
}


