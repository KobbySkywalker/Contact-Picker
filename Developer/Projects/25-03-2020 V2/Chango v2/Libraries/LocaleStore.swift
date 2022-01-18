//
//  LocaleStore.swift
//  Chango v2
//
//  Created by Hosny Savage on 13/07/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import Foundation

struct LocaleStore {
    
    /// Result Enum
    ///
    /// - Success: Returns Grouped By Alphabets Locale Info
    /// - Error: Returns error
    public enum GroupedByAlphabetsFetchResults {
        case success(response: [String: [LocaleInfo]])
        case error(error: (title: String?, message: String?))
    }
    
    /// Result Enum
    ///
    /// - Success: Returns Array of Locale Info
    /// - Error: Returns error
    public enum FetchResults {
        case success(response: [LocaleInfo])
        case error(error: (title: String?, message: String?))
    }
    
    public static func getInfo(completionHandler: @escaping (FetchResults) -> ()) {
        let bundle = Bundle(for: LocalePickerViewController.self)
        let path = "Countries.bundle/Data/CountryCodes"
        
        guard let jsonPath = bundle.path(forResource: path, ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
                let error: (title: String?, message: String?) = (title: "ContryCodes Error", message: "No ContryCodes Bundle Access")
                return completionHandler(FetchResults.error(error: error))
        }
        
        if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)) as? Array<Any> {
            var result: [LocaleInfo] = []
            for jsonObject in jsonObjects {
                guard let countryObj = jsonObject as? Dictionary<String, Any> else { continue }
                guard let country = countryObj["name"] as? String,
                    let code = countryObj["code"] as? String,
                    let phoneCode = countryObj["dial_code"] as? String else {
                        continue
                }
                let new = LocaleInfo(country: country, code: code, phoneCode: phoneCode)
                result.append(new)
            }
            return completionHandler(FetchResults.success(response: result))
        }
        
        let error: (title: String?, message: String?) = (title: "JSON Error", message: "Couldn't parse json to Info")
        return completionHandler(FetchResults.error(error: error))
    }
    
    public static func fetch(completionHandler: @escaping (GroupedByAlphabetsFetchResults) -> ()) {
        LocaleStore.getInfo { result in
            switch result {
            case .success(let info):
                /*
                 var header = Set<String>()
                 info.forEach {
                 let country = $0.country
                 header.insert(String(country[country.startIndex]))
                 }
                 */
                var data = [String: [LocaleInfo]]()
                
                info.forEach {
                    let country = $0.country
                    let index = String(country[country.startIndex])
                    var value = data[index] ?? [LocaleInfo]()
                    value.append($0)
                    data[index] = value
                }
                
                data.forEach { key, value in
                    data[key] = value.sorted(by: { lhs, rhs in
                        return lhs.country < rhs.country
                    })
                }
                completionHandler(GroupedByAlphabetsFetchResults.success(response: data))
                
            case .error(let error):
                completionHandler(GroupedByAlphabetsFetchResults.error(error: error))
            }
        }
    }
}


struct SupportLocaleStore {
    
    /// Result Enum
    ///
    /// - Success: Returns Grouped By Alphabets Locale Info
    /// - Error: Returns error
    public enum SupportGroupedByAlphabetsFetchResults {
        case success(response: [String: [SupportLocaleInfo]])
        case error(error: (title: String?, message: String?))
    }
    
    /// Result Enum
    ///
    /// - Success: Returns Array of Locale Info
    /// - Error: Returns error
    public enum FetchResults {
        case success(response: [SupportLocaleInfo])
        case error(error: (title: String?, message: String?))
    }
    
    public static func getInfo(completionHandler: @escaping (FetchResults) -> ()) {
        let bundle = Bundle(for: SupportLocalePickerViewController.self)
        let path = "Countries.bundle/Data/SupportCountryCodes"
        
        guard let jsonPath = bundle.path(forResource: path, ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
                let error: (title: String?, message: String?) = (title: "ContryCodes Error", message: "No ContryCodes Bundle Access")
                return completionHandler(FetchResults.error(error: error))
        }
        
        if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)) as? Array<Any> {
            var result: [SupportLocaleInfo] = []
            for jsonObject in jsonObjects {
                guard let countryObj = jsonObject as? Dictionary<String, Any> else { continue }
                guard let country = countryObj["name"] as? String,
                    let code = countryObj["code"] as? String,
                    let phoneCode = countryObj["dial_code"] as? String else {
                        continue
                }
                let new = SupportLocaleInfo(country: country, code: code, phoneCode: phoneCode)
                result.append(new)
            }
            return completionHandler(FetchResults.success(response: result))
        }
        
        let error: (title: String?, message: String?) = (title: "JSON Error", message: "Couldn't parse json to Info")
        return completionHandler(FetchResults.error(error: error))
    }
    
    public static func fetch(completionHandler: @escaping (SupportGroupedByAlphabetsFetchResults) -> ()) {
        SupportLocaleStore.getInfo { result in
            switch result {
            case .success(let info):
                /*
                 var header = Set<String>()
                 info.forEach {
                 let country = $0.country
                 header.insert(String(country[country.startIndex]))
                 }
                 */
                var data = [String: [SupportLocaleInfo]]()
                
                info.forEach {
                    let country = $0.country
                    let index = String(country[country.startIndex])
                    var value = data[index] ?? [SupportLocaleInfo]()
                    value.append($0)
                    data[index] = value
                }
                
                data.forEach { key, value in
                    data[key] = value.sorted(by: { lhs, rhs in
                        return lhs.country < rhs.country
                    })
                }
                completionHandler(SupportGroupedByAlphabetsFetchResults.success(response: data))
                
            case .error(let error):
                completionHandler(SupportGroupedByAlphabetsFetchResults.error(error: error))
            }
        }
    }
}


struct CreateGroupLocaleStore {
    
    /// Result Enum
    ///
    /// - Success: Returns Grouped By Alphabets Locale Info
    /// - Error: Returns error
    public enum CreateGroupGroupedByAlphabetsFetchResults {
        case success(response: [String: [CreateGroupLocaleInfo]])
        case error(error: (title: String?, message: String?))
    }
    
    /// Result Enum
    ///
    /// - Success: Returns Array of Locale Info
    /// - Error: Returns error
    public enum FetchResults {
        case success(response: [CreateGroupLocaleInfo])
        case error(error: (title: String?, message: String?))
    }
    
    public static func getInfo(completionHandler: @escaping (FetchResults) -> ()) {
        let bundle = Bundle(for: SupportLocalePickerViewController.self)
        let path = "Countries.bundle/Data/CreateGroupCountryCodes"
        
        guard let jsonPath = bundle.path(forResource: path, ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
                let error: (title: String?, message: String?) = (title: "ContryCodes Error", message: "No ContryCodes Bundle Access")
                return completionHandler(FetchResults.error(error: error))
        }
        
        if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)) as? Array<Any> {
            var result: [CreateGroupLocaleInfo] = []
            for jsonObject in jsonObjects {
                guard let countryObj = jsonObject as? Dictionary<String, Any> else { continue }
                guard let country = countryObj["name"] as? String,
                    let code = countryObj["code"] as? String,
                    let phoneCode = countryObj["dial_code"] as? String else {
                        continue
                }
                let new = CreateGroupLocaleInfo(country: country, code: code, phoneCode: phoneCode)
                result.append(new)
            }
            return completionHandler(FetchResults.success(response: result))
        }
        
        let error: (title: String?, message: String?) = (title: "JSON Error", message: "Couldn't parse json to Info")
        return completionHandler(FetchResults.error(error: error))
    }
    
    public static func fetch(completionHandler: @escaping (CreateGroupGroupedByAlphabetsFetchResults) -> ()) {
        CreateGroupLocaleStore.getInfo { result in
            switch result {
            case .success(let info):
                /*
                 var header = Set<String>()
                 info.forEach {
                 let country = $0.country
                 header.insert(String(country[country.startIndex]))
                 }
                 */
                var data = [String: [CreateGroupLocaleInfo]]()
                
                info.forEach {
                    let country = $0.country
                    let index = String(country[country.startIndex])
                    var value = data[index] ?? [CreateGroupLocaleInfo]()
                    value.append($0)
                    data[index] = value
                }
                
                data.forEach { key, value in
                    data[key] = value.sorted(by: { lhs, rhs in
                        return lhs.country < rhs.country
                    })
                }
                completionHandler(CreateGroupGroupedByAlphabetsFetchResults.success(response: data))
                
            case .error(let error):
                completionHandler(CreateGroupGroupedByAlphabetsFetchResults.error(error: error))
            }
        }
    }
}
