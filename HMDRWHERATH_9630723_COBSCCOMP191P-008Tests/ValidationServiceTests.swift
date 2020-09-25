//
//  ValidationServiceTests.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008Tests
//
//  Created by user180410 on 9/25/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import XCTest
@testable import HMDRWHERATH_9630723_COBSCCOMP191P_008

class ValidationServiceTests: XCTestCase {
    var validation: ValidationService!
    
    override func setUp() {
        super.setUp()
        validation = ValidationService()
    }
    
    override func tearDown() {
        validation = nil
        super.tearDown()
    }
    
    func test_is_valid_email() throws {
        XCTAssertNoThrow(try validation.validateEmail("test001@gmail.com"))
    }
    
    func test_email_is_nil() throws {
        let expectedError = ValidationError.invalidValue
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validateEmail(nil)) {
            thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_email_is_valid_format() throws {
        let expectedError = ValidationError.invalidEmail
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validateEmail("test")) {
            thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_is_valid_password() throws {
        XCTAssertNoThrow(try validation.validatePassword("123456"))
    }
    
    func test_password_is_nil() throws {
        let expectedError = ValidationError.invalidValue
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validatePassword(nil)) {
            thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_password_is_too_short() throws {
        let expectedError = ValidationError.passwordTooShort
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validatePassword("test")) {
            thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
}
