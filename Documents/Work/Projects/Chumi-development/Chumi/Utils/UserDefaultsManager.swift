//
//  UserDefaultsManager.swift
//  Chumi
//
//  Created by Fitzgerald Afful on 02/02/2021.
//

import Foundation

extension UserDefaults {
    enum Keys: String, CaseIterable {
        case userDetails
    }
}

class UserDefaultsManager {

    func setCodableData<T: Codable>(value: T, key: UserDefaults.Keys) {
        let defaults = UserDefaults.standard
        defaults.set(value.dictionary, forKey: key.rawValue)
    }

    func getCodableData<T: Codable>(type: T.Type, forKey: UserDefaults.Keys) -> T? {
        let defaults = UserDefaults.standard
        if let dataDictionary = defaults.object(forKey: forKey.rawValue) {
            if let data = try? DictionaryDecoder().decode(type, from: dataDictionary) {
                return data
            }
        }
        return nil
    }

    func setData<T>(value: T, key: UserDefaults.Keys) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key.rawValue)
    }

    func getData<T>(type: T.Type, forKey: UserDefaults.Keys) -> T? {
        let defaults = UserDefaults.standard
        let value = defaults.object(forKey: forKey.rawValue) as? T
        return value
    }

    func removeData(key: UserDefaults.Keys) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key.rawValue)
    }

    func removeAllData() {
        _ = UserDefaults.Keys.allCases.map({ self.removeData(key: $0) })
    }
}
