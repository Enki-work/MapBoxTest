//
//  Location.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/28.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import RxSwift
import Foundation

struct Location: Codable {
    var id: String
    var longitude: Double
    var latitude: Double
    var updatedAt: Date
    var createdAt: Date
    var userId: String

    struct AnyCodingKey: CodingKey {
        var stringValue: String
        var intValue: Int?
        init(_ codingKey: CodingKey) {
            self.stringValue = codingKey.stringValue
            self.intValue = codingKey.intValue
        }
        init(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        init(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case longitude
        case latitude
        case updatedAt
        case createdAt
    }

    init(from decoder: Decoder) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var con = try! decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try! con.decode(String.self, forKey: AnyCodingKey(stringValue: CodingKeys.id.rawValue))
        self.longitude = try! con.decode(Double.self, forKey: AnyCodingKey(stringValue: CodingKeys.longitude.rawValue))
        self.latitude = try! con.decode(Double.self, forKey: AnyCodingKey(stringValue: CodingKeys.latitude.rawValue))
        let updatedAtStr = try! con.decode(String.self, forKey: AnyCodingKey(stringValue: CodingKeys.updatedAt.rawValue))
        self.updatedAt = dateFormatter.date(from: updatedAtStr)!
        let createdAtStr = try! con.decode(String.self, forKey: AnyCodingKey(stringValue: CodingKeys.createdAt.rawValue))
        self.createdAt = dateFormatter.date(from: createdAtStr)!
        con = try! con.nestedContainer(keyedBy: AnyCodingKey.self, forKey: AnyCodingKey(stringValue: "user"))
        self.userId = try! con.decode(String.self, forKey: AnyCodingKey(stringValue: "id"))
    }
}

final class LocationModel {
    func getUserLocations() -> Observable<[Location]> {
        return AuthModel.getMe().flatMap { (user) -> Observable<[Location]> in
            guard let user = user, user.token.count > 0 else {
                return Observable<[Location]>.error(RxError.unknown)
            }
            let params = ["token": user.token].getUrlParams()
            guard let url = URL(string: MBTUrlString.hostUrlString +
                MBTUrlString.getUserLocationUrlString + params) else {
                return Observable<[Location]>.error(RxError.unknown)
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            return URLSession.shared.rx.data(request: urlRequest)
                .flatMap { (data) -> Observable<[Location]> in
                    guard let locations = try? JSONDecoder().decode([Location].self, from: data) else {
                        return Observable<[Location]>.error(RxError.noElements)
                    }
                    return Observable<[Location]>.just(locations)
                }.do(onError: { (error) in
                    print(error)
                })
        }.observeOn(MainScheduler.instance)
    }

    func getGroupLocations() -> Observable<[Location]> {
        return AuthModel.getMe().flatMap { (user) -> Observable<[Location]> in
            guard let user = user, user.token.count > 0 else {
                return Observable<[Location]>.error(RxError.unknown)
            }
            let params = ["token": user.token].getUrlParams()
            guard let url = URL(string: MBTUrlString.hostUrlString +
                MBTUrlString.getGroupLocationUrlString + params) else {
                return Observable<[Location]>.error(RxError.unknown)
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            return URLSession.shared.rx.data(request: urlRequest)
                .flatMap { (data) -> Observable<[Location]> in
                    guard let locations = try? JSONDecoder().decode([Location].self, from: data) else {
                        return Observable<[Location]>.error(RxError.noElements)
                    }
                    return Observable<[Location]>.just(locations)
                }.do(onError: { (error) in
                    print(error)
                })
        }.observeOn(MainScheduler.instance)
    }
}
