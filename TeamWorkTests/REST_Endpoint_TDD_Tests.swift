//
//  REST_Endpoint_TDD_Tests.swift
//  TeamWorkTests
//
//  Created by Aldo Bergamini on 05/12/2017.
//  Copyright © 2017 iBat. All rights reserved.
//

import XCTest


@testable import TeamWork


class REST_Endpoint_TDD_Tests: XCTestCase {
    
    var restEP = REST_Endpoint()
    var currentExpectation: XCTestExpectation?

    override func setUp() {
        
        super.setUp()
        restEP.apiConfigName = kTW_API_Config
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_REST_Endpoint_prepare() {
        
        self.restEP.prepareFor(path: kProjectsAction, apiCallType: "GET")
        
        if let baseURL = self.restEP.baseURL {
            
            XCTAssert(baseURL == "yat.teamwork.com", "Could not get expected base url, got \(baseURL)")
            
        } else {
            
            XCTFail("Error in preparing Endpoint")
        }
    }
    
    func test_REST_Endpoint_prepareAndSetupForCall() {
        
        let authToken = Authorization().authTokenFor(apiKey: key)
        let headers = [kAuthorizationHeader: authToken, kContentTypeHeader: kAppJsonContent]

        self.restEP.prepareFor(path: kProjectsAction, apiCallType: "GET")
        do {
            
            try self.restEP.setupCallWith(parameters: nil, headers: headers)
            
            if let callParameters = self.restEP.currentCallParameters {
                
                XCTAssert(callParameters.actionParams.keys.count == 0, "Unexpected action parameter!!")
                XCTAssert(callParameters.queryParams.keys.count == 0, "Unexpected query parameter!!")
                XCTAssert(callParameters.bodyParams.keys.count == 0, "Unexpected body parameter!!")
            }

        } catch {
            
            XCTFail("Error in api call setup")
        }
    }
    
    func test_REST_Endpoint_prepare_setup_and_Do_Call() {
        
        let expectation = self.expectation(description: "test_RunListProjectsAPICommand")
        self.currentExpectation = expectation
        
        let authToken = Authorization().authTokenFor(apiKey: key)
        let headers = [kAuthorizationHeader: authToken, kContentTypeHeader: kAppJsonContent]
        
        self.restEP.prepareFor(path: kProjectsAction, apiCallType: "GET")
        self.restEP.addHeader(kAuthorizationHeader, required: true)
        self.restEP.addHeader(kContentTypeHeader, required: true)

        do {
            
            try self.restEP.setupCallWith(parameters: nil, headers: headers)
            self.restEP.doCallWith(responseHandler: self.receiveResponse)
            
        } catch {
            
            XCTFail("Error in api call setup")
        }
        
        // *****************
        
        waitForExpectations(timeout: 5) { error in
            
            if let error = error { XCTFail("Failed with timeout error: \(error)") }
        }
    }

    
    func receiveResponse(_ result: Any?, _ error: Error?) -> Void {

        if let result = result as? [String: Any] {
            
            DLogWith(message: "Result: \(String(describing: result))")
            self.currentExpectation?.fulfill()
            
        } else {
            
//            DLogWith(message: "Error: \(String(describing: error))")
            XCTFail("Error! \(String(describing: error))")
        }
    }
}
