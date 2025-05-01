//
//  GetJSONDataTests.swift
//  Fetch Recipe Browser Tests
//
//  Created by Kyle Brownell on 4/29/25.
//

import XCTest
@testable import Fetch_Recipe_Browser

final class GetJSONDataTests: XCTestCase {

    func testSuccessfulJSONDataRequest() async {
        //Given
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        let apiService = APIService()
        //When
        let (byName, byCuisine) = await apiService.fetchData(urlString: urlString)
        //Then
        XCTAssertNotNil(byName)
        XCTAssertNotNil(byCuisine)
        XCTAssertEqual(byName!.count, 63)
        XCTAssertEqual(byCuisine!.count, 63)
        XCTAssertNotNil(byName!.first)
        XCTAssertNotNil(byName!.last)
        XCTAssertNotNil(byCuisine!.first)
        XCTAssertNotNil(byCuisine!.last)
        let firstByName = byName!.first!
        let lastByName = byName!.last!
        let firstByCuisine = byCuisine!.first!
        let lastByCuisine = byCuisine!.last!
        XCTAssertEqual(firstByName.name, "Apam Balik")
        XCTAssertEqual(firstByName.cuisine, "Malaysian")
        XCTAssertEqual(lastByName.name, "White Chocolate Crème Brûlée")
        XCTAssertEqual(lastByName.cuisine, "French")
        XCTAssertEqual(firstByCuisine.name, "Banana Pancakes")
        XCTAssertEqual(firstByCuisine.cuisine, "American")
        XCTAssertEqual(lastByCuisine.name, "Tunisian Orange Cake")
        XCTAssertEqual(lastByCuisine.cuisine, "Tunisian")
    }
    
    func testUnsuccessfulJSONDataRequest() async {
        //Given
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        let apiService = APIService()
        //When
        let (byName, byCuisine) = await apiService.fetchData(urlString: urlString)
        //Then
        XCTAssertNil(byName)
        XCTAssertNil(byCuisine)
    }
    
    func testEmptyJSONDataRequest() async {
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        let apiService = APIService()
        let (byName, byCuisine) = await apiService.fetchData(urlString: urlString)
        XCTAssertEqual(byName, [Recipe]())
        XCTAssertEqual(byCuisine, [Recipe]())
    }

}
