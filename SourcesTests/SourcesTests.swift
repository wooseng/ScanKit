//
// SourcesTests.swift
// SourcesTests
//
// Create by wooseng with company's MackBook Pro on 2019/10/31.
// Copyright © 2019 残无殇. All rights reserved.
//


import XCTest
@testable import Sources

class SourcesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReadImage() {
        let image = SKHelper.image(with: "sk_image_animate_wechat")
        assert( image != nil)
    }

}
