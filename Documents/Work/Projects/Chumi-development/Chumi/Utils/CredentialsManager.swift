//
//  CredentialsManager.swift
//  Chumi
//
//  Created by Fitzgerald Afful on 02/02/2021.
//

import Foundation
import Locksmith

class CredentialsManager {

    static var locksmithAccount: String {
        if isRunningTests {
            return "ChumiTestKeychain"
        } else {
            return "ChumiKeychain"
        }
    }

    enum Credential: String {
        case email
        case password
        case accessToken
        case refreshToken
    }

    static func store(key: Credential, value: String) {
        var newData: [String: String] = [:]
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: locksmithAccount)
        if let dictionary = dictionary {
            newData = dictionary as! [String: String]
        }
        newData[key.rawValue] = value
        do {
            try Locksmith.updateData(data: newData, forUserAccount: locksmithAccount)
        } catch {
            FancyLogger.log(.init(severity: .error, message: "failed to save \(key.rawValue) to Keychain"))
        }

    }

    static func store(_ credentials: [Credential: String]) {
        var newData: [String: String] = [:]
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: locksmithAccount)
        if let dictionary = dictionary {
            newData = dictionary as! [String: String]
        }
        for credential in credentials {
            newData[credential.key.rawValue] = credential.value
        }
        do {
            try Locksmith.updateData(data: newData, forUserAccount: locksmithAccount)
        } catch {
            FancyLogger.log(.init(severity: .error, message: "failed to save multiple keys to Keychain"))
        }

    }

    static func get(_ key: Credential) -> String? {
        if let dictionary = Locksmith.loadDataForUserAccount(userAccount: locksmithAccount) {
            return dictionary[key.rawValue] as? String
        }
        return nil
    }

    static func get(_ keys: [Credential]) -> [Credential: String?] {
        var result: [Credential: String] = [:]
        if let dictionary = Locksmith.loadDataForUserAccount(userAccount: locksmithAccount) {
            for item in keys {
                result[item] = dictionary[item.rawValue] as? String
            }
        } else {
            FancyLogger.log(.init(severity: .warning, message: "failed to load keychain items"))
            for item in keys {
                result[item] = nil
            }
        }

        return result
    }

    static func deleteAll() {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: locksmithAccount)
        } catch {
            FancyLogger.log(.init(severity: .warning, message: "Keychain items failed to delete"))
        }
    }
}
