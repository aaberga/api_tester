//
//  FirstAPIConnectionTests.swift
//  TeamWorkTests
//
//  Created by Aldo Bergamini on 03/12/2017.
//  Copyright © 2017 iBat. All rights reserved.
//

import XCTest


@testable import TeamWork

let kDot = "."
let kAuthorizationHeader = "Authorization"
let kContentTypeHeader = "Content-Type"
let kAppJsonContent = "application/json"


let company = "yat"
let key = "twp_TEbBXGCnvl2HfvXWfkLUlzx92e3T"
let kProjectsAction = "/projects.json"

let domainURL = "teamwork.com"


class REST_API_Tests: XCTestCase {
    
    var restAPIObj: REST_API!
    var currentExpectation: XCTestExpectation?
    
    override func setUp() {
        
        super.setUp()

        self.restAPIObj = REST_API()
    }
    
    override func tearDown() {

        self.restAPIObj = REST_API()
        super.tearDown()
    }
    
    func testRawAPICall() {
        
        let expectation = self.expectation(description: "Simple Test Call To Test Waters")
        self.currentExpectation = expectation
        
        let targetProtocol = API_Protocols.https
        let baseURL = company + kDot + domainURL
        let authToken = self.authTokenFor(apiKey: key)
        
        let headers = [kAuthorizationHeader: authToken, kContentTypeHeader: kAppJsonContent]
        
        self.restAPIObj.doGET(withProtocol: targetProtocol, URLRootString: baseURL, URLActionString: kProjectsAction, andHeadersDictionary: headers, andURLParamsDictionary: nil, withCompletionBlock: self.receiveCallResults)
        
        waitForExpectations(timeout: 5) { error in
            
            if let error = error { XCTFail("Failed with timeout error: \(error)") }
        }
    }
    
    func authTokenFor(apiKey key: String) -> String {
        
        let apiKeyString = String(format: "%@:xxx", key)
        let utfAPIKey = apiKeyString.data(using: String.Encoding.utf8)!
        let encodedAPIKey = utfAPIKey.base64EncodedString()
        let authToken = String(format: "BASIC %@", encodedAPIKey)
//        DLogWith(message: "Auth: \(authToken)")

        return authToken
    }
    
    
    func receiveCallResults(_ data: Data?, response: URLResponse?, error: Error?) -> Void {
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        if let statusCode = statusCode {
            
            DLogWith(message: "Response Code; \(statusCode)")
            
        } else {
            
            DLogWith(message: "No Response Code!")
        }

        if let returnedError = error {
            
            DLogWith(message: "Error in API call! \(String(describing: error))")
            self.receiveResponse(nil, returnedError)
        }
        
        if let data = data {
            
            let responseObject: [String: Any]? = nsdataToJSON(data) as? [String: Any]
            let responseArray: [Any]? = nsdataToJSON(data) as? [Any]

            if let responseObject = responseObject {

                DLogWith(message: "JSON Object: \(responseObject)")
                self.receiveResponse(responseObject , error)
                return
            }
            
            if let responseArray = responseArray {
                
                DLogWith(message: "JSON Array: \(responseArray)")
                
                self.receiveResponse(responseArray, error)
                return
            }
        }
    }

    func receiveResponse(_ result: Any?, _ error: Error?) -> Void {
        
        DLogWith(message: "Result: \(String(describing: result))")
        DLogWith(message: "Error: \(String(describing: error))")
        
        self.currentExpectation?.fulfill()
    }
}
