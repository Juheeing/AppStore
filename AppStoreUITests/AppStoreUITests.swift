//
//  AppStoreUITests.swift
//  AppStoreUITests
//
//  Created by 김주희 on 9/7/24.
//

import XCTest

final class AppStoreUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    // Test "취소" 버튼을 눌렀을 때 RecentListView와 TopTitleView가 표시되는지 확인
    func testCancelButtonShowsRecentListAndTopTitle() throws {

        let recentListView = app.tables["RecentListView"]
        let topTitleView = app.staticTexts["TopTitleView"]
        let cancelButton = app.buttons["취소"]
        let textField = app.textFields.firstMatch

        XCTAssertTrue(recentListView.exists, "RecentListView 존재하지 않음")
        XCTAssertTrue(topTitleView.exists, "topTitleView 존재하지 않음")
        XCTAssertTrue(textField.exists, "취소 버튼이 존재하지 않음")
        
        // 사용자가 입력을 시도하여 검색 모드로 진입
        textField.tap()
        textField.typeText("카카오뱅크")

        // 취소 버튼을 누름
        XCTAssertTrue(cancelButton.exists, "취소 버튼이 존재하지 않음")
        cancelButton.tap()

        // RecentListView와 TopTitleView가 표시되는지 확인
        XCTAssertTrue(recentListView.waitForExistence(timeout: 0.5), "RecentListView 표시되지 않음")
        XCTAssertTrue(topTitleView.waitForExistence(timeout: 0.5), "topTitleView 표시되지 않음")
    }
    
    func testSearchResultViewShow() throws {
        
        let textField = app.textFields.firstMatch
        textField.tap()
        textField.typeText("카카오뱅크\n")
        
        let searchResultView = app.tables["SearchResultView"]
        XCTAssertTrue(searchResultView.waitForExistence(timeout: 2), "SearchResultView 표출되지 않음")
    }
}
