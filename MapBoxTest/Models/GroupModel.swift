//
//  GroupModel.swift
//  MapBoxTest
//
//  Created by YanQi on 2020/04/30.
//  Copyright © 2020 Prageeth. All rights reserved.
//

import RxSwift
import Foundation

protocol SimpleGroupInfoProtocol {
    var id: String { get }
    var title: String { get }
}

struct Group: Codable, SimpleGroupInfoProtocol {
    var id: String
    var title: String
    var updatedAt: Date
    var createdAt: Date

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
        case title
        case updatedAt
        case createdAt
    }

    init(from decoder: Decoder) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let con = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try con.decode(String.self,
                                 forKey: AnyCodingKey(stringValue: CodingKeys.id.rawValue))
        self.title = try con.decode(String.self,
                                    forKey: AnyCodingKey(stringValue: CodingKeys.title.rawValue))
        let updatedAtStr = try con.decode(String.self,
                                          forKey: AnyCodingKey(stringValue: CodingKeys.updatedAt.rawValue))
        self.updatedAt = dateFormatter.date(from: updatedAtStr)!
        let createdAtStr = try con.decode(String.self,
                                          forKey: AnyCodingKey(stringValue: CodingKeys.createdAt.rawValue))
        self.createdAt = dateFormatter.date(from: createdAtStr)!
    }
    
    init(title: String) {
        self.title = title
        self.id = ""
        self.updatedAt = Date()
        self.createdAt = Date()
    }
}

struct SimpleGroupInfo: Codable, SimpleGroupInfoProtocol {
    var id: String
    var title: String
}

final class GroupModel {
    func getGroups() -> Observable<[Group]> {
        return AuthModel.getMe().flatMap { (user) -> Observable<[Group]> in
            guard let user = user, user.token.count > 0 else {
                return Observable<[Group]>.error(RxError.unknown)
            }
            let params = ["token": user.token].getUrlParams()
            guard let url = URL(string: MBTUrlString.hostUrlString +
                MBTUrlString.getGroupUrlString + params) else {
                return Observable<[Group]>.error(RxError.unknown)
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            return URLSession.shared.rx.data(request: urlRequest)
                .flatMap { (data) -> Observable<[Group]> in
                    guard let groups = try? JSONDecoder().decode([Group].self, from: data) else {
                        return Observable<[Group]>.error(RxError.noElements)
                    }
                    return Observable<[Group]>.just(groups)
                }.do(onError: { (error) in
                    print(error)
                })
        }.observeOn(MainScheduler.instance).checkAccountValidity()
    }
}
