//
//  NewsCombinedTests.swift
//  NewsCombinedTests
//
//  Created by admin on 01/03/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import XCTest
import Firebase

@testable import NewsCombined

class NewsCombinedTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetAllClusters() {
        
        // 1. Define an expectation
        let expect = expectation(description: "Getting all clusters from firebase and local db")
        
        // 2. Exercise the asynchronous code
        ModelNotification.ClusterList.observe { (clusters) in
            if clusters != nil{
                XCTAssertTrue(true)
                expect.fulfill()
            }
        }
        Model.instance.getAllClustersAndObserve(category: "politics")
        
        
        // 3. Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testGetAllArticles() {
        
        let testedCluster = Cluster(insertcategory: "politics", inserttopic: "2", insertclusterimg: "test.com/test.jpg", insertclustertitle: "Test")
        // 1. Define an expectation
        let expect = expectation(description: "Getting all Articles from firebase and local db")
        
        // 2. Exercise the asynchronous code
        ModelNotification.ArticleList.observe { (articles) in
            if articles != nil{
                if let count = articles?.count{
                    XCTAssert(count > 0)
                }
                expect.fulfill()
            }
        }
        Model.instance.getAllArticlesInClusterAndObserve(cluster: testedCluster)
        
        
        // 3. Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testGetAllMessages() {
        
        let testedCluster = Cluster(insertcategory: "politcs", inserttopic: "2", insertclusterimg: "test.com/test.jpg", insertclustertitle: "Test")
        // 1. Define an expectation
        let expect = expectation(description: "Getting all Messages from firebase and local db")
        
        // 2. Exercise the asynchronous code
        ModelNotification.MessageList.observe { (messages) in
            if messages != nil{
                XCTAssertTrue(true)
                expect.fulfill()
            }
        }
        Model.instance.getAllMessagesAndObserve(cluster: testedCluster)
        
        
        // 3. Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    
    func testWriteFileLocally() {
        //Writing image file into local storage
        LocalFileStore.saveImageToFile(image: UIImage(named: "logo")!, name: "test")
        
        //checking if the file was written
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("test") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                XCTAssert(true)
            } else {
                XCTAssert(false)
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
            XCTAssert(false)
        }
    }
    
    
    
    func testReadFileLocally() {
        let res = LocalFileStore.getImageFromFile(name: "test")
        XCTAssert(res != nil)
    }
    
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
