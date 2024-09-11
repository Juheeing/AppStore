//
//  AppStoreTests.swift
//  AppStoreTests
//
//  Created by 김주희 on 9/7/24.
//

import XCTest
@testable import AppStore

final class AppStoreTests: XCTestCase {

    var viewModel: SearchViewModel!
    var global: Global!

    override func setUpWithError() throws {
        viewModel = SearchViewModel()
        global = Global()
        
        // 테스트 전에 UserDefaults를 초기화
        UserDefaults.standard.removeObject(forKey: viewModel.searchesKey)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    // 최근 검색어 저장 테스트
    func testSaveSearchData_insertsSearchTermAtBeginning() {
        let searchTerm = "Test Search"
        viewModel.saveSearchData(input: searchTerm, global: global)
        
        XCTAssertEqual(viewModel.recentSearches.first, searchTerm)
    }
    
    // 중복 검색어 제거 테스트
    func testSaveSearchData_removesDuplicateSearchTerm() {
        let searchTerm = "Test Search"
        viewModel.recentSearches = ["Test Search", "Old Search"]
        viewModel.saveSearchData(input: searchTerm, global: global)
        
        XCTAssertEqual(viewModel.recentSearches.count, 2)
        XCTAssertEqual(viewModel.recentSearches.first, searchTerm)
    }

    // 검색어 저장 후 UserDefaults에서 제대로 불러오는지 테스트
    func testLoadSearches_loadsFromUserDefaults() {
        let savedSearches = ["Search 1", "Search 2"]
        UserDefaults.standard.set(savedSearches, forKey: viewModel.searchesKey)
        
        viewModel.loadSearches()
        
        XCTAssertEqual(viewModel.recentSearches, savedSearches)
    }
    
    // SearchAPI 호출 시 로딩 표시
    func testSaveSearchData_showsLoadingWhenSearching() {
        viewModel.saveSearchData(input: "Test", global: global)
        XCTAssertTrue(global.isLoading)
    }
    
    // SearchAPI 호출 후 로딩 숨김
    func testSaveSearchData_hidesLoadingAfterSearch() {
        viewModel.saveSearchData(input: "Test", global: global)
        
        // 비동기 처리가 완료된 후 확인
        let expectation = self.expectation(description: "Async search completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.global.isLoading)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
  
    // formattedRatingCount 테스트
    func testFormattedRatingCount_aboveTenThousand() {
        let formatted = formattedRatingCount(25_000)
        XCTAssertEqual(formatted, "2.5만", "10,000 이상의 숫자는 '만' 단위로 표시")
    }
    
    func testFormattedRatingCount_belowTenThousand() {
        let formatted = formattedRatingCount(8_500)
        XCTAssertEqual(formatted, "8500", "10,000 미만의 숫자는 그대로 표시")
    }
    
    // getPreferredLanguage 테스트
    func testGetPreferredLanguage_emptyLanguages() {
        let languages: [String] = []
        let preferred = getPreferredLanguage(languages)
        XCTAssertEqual(preferred, "", "언어 배열이 비어있을 때 빈 문자열을 반환")
    }
    
    // getLangCount 테스트
    func testGetLangCount_singleLanguage() {
        let languages = ["EN"]
        let countString = getLangCount(languages)
        XCTAssertEqual(countString, "", "언어가 하나일 경우 빈 문자열을 반환")
    }

    func testGetLangCount_multipleLanguages() {
        let languages = ["EN", "KR", "FR"]
        let countString = getLangCount(languages)
        XCTAssertEqual(countString, "+ 2개 언어", "두 개 이상의 언어일 경우 남은 언어 개수를 반환")
    }
    
    // numberOfNewLines 테스트
    func testNumberOfNewLines_noNewLines() {
        let text = "This is a single line text"
        let lineCount = numberOfNewLines(text: text)
        XCTAssertEqual(lineCount, 0, "개행 문자가 없는 경우 0을 반환")
    }

    func testNumberOfNewLines_withNewLines() {
        let text = "Line 1\nLine 2\nLine 3\n"
        let lineCount = numberOfNewLines(text: text)
        XCTAssertEqual(lineCount, 3, "세 개의 개행 문자가 있는 경우 3을 반환")
    }
    
    // truncatedText 테스트
    func testTruncatedText_withTwoNewLines() {
        let text = "Line 1\nLine 2\nLine 3\nLine 4"
        let truncated = truncatedText(text: text)
        XCTAssertEqual(truncated, "Line 1\nLine 2", "두 번째 개행 문자까지 텍스트를 반환")
    }
    
    func testTruncatedText_withNoNewLines() {
        let text = "Single line text"
        let truncated = truncatedText(text: text)
        XCTAssertEqual(truncated, text, "개행 문자가 없는 경우 전체 텍스트를 반환")
    }
    
}
