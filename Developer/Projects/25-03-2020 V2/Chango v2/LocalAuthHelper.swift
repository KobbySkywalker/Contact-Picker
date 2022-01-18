//
//  LocalAuthHelper.swift
//  Testimonies
//
//  Created by Created by Hosny Ben Savage on 15/10/2018.
//  Copyright © 2020 IT Consortium. All rights reserved.
//


import Foundation
//import FTIndicator

//class LocalAuthHelper: NSObject {
//    
//    
//    func setUser(user: User?){
//        if(user != nil){
//            UserDefaults.standard.set(user!.id,forKey: UserDefaults.UserKeys.id)
//            UserDefaults.standard.set(user!.name,forKey: UserDefaults.UserKeys.name)
//            UserDefaults.standard.set(user!.username,forKey: UserDefaults.UserKeys.username)
//            UserDefaults.standard.set(user!.fav_book,forKey: UserDefaults.UserKeys.fav_book)
//            UserDefaults.standard.set(user!.fav_chapter,forKey: UserDefaults.UserKeys.fav_chapter)
//            UserDefaults.standard.set(user!.fav_verse,forKey: UserDefaults.UserKeys.fav_verse)
//            UserDefaults.standard.set(user!.email,forKey: UserDefaults.UserKeys.email)
//            UserDefaults.standard.set(user!.country,forKey: UserDefaults.UserKeys.country)
//            UserDefaults.standard.set(user!.api_key,forKey: UserDefaults.UserKeys.api_key)
//            UserDefaults.standard.set(user!.uid,forKey: UserDefaults.UserKeys.uid)
//            UserDefaults.standard.set(user!.image_url,forKey: UserDefaults.UserKeys.image_url)
//            UserDefaults.standard.set(true,forKey: UserDefaults.AuthKeys.login)
//        }else{
//            UserDefaults.standard.set(0, forKey: UserDefaults.UserKeys.id)
//        }
//    }
//    
//    func getLoginState()->Bool{
//        if(UserDefaults.standard.bool(forKey: UserDefaults.AuthKeys.login)){
//            return true
//        }else{
//            return false
//        }
//    }
//    
//    func setLoginState(loginState: Bool){
//        UserDefaults.standard.set(loginState, forKey: UserDefaults.AuthKeys.login)
//    }
//    
//    
//    func getUser()->User?{
//        let id:Int = UserDefaults.standard.integer(forKey: UserDefaults.UserKeys.id)
//        let uid = UserDefaults.standard.string(forKey: UserDefaults.UserKeys.uid)
//        let name = UserDefaults.standard.string(forKey: UserDefaults.UserKeys.name)
//        let email = UserDefaults.standard.string(forKey: UserDefaults.UserKeys.email)
//        let username = UserDefaults.standard.string(forKey: UserDefaults.UserKeys.username)
//        let country = UserDefaults.standard.string(forKey: UserDefaults.UserKeys.country)
//        let fav_book = UserDefaults.standard.string(forKey: UserDefaults.UserKeys.fav_book)
//        let fav_chapter = UserDefaults.standard.string(forKey: UserDefaults.UserKeys.fav_chapter)
//        let fav_verse = UserDefaults.standard.string(forKey: UserDefaults.UserKeys.fav_verse)
//        let api_key = UserDefaults.standard.string(forKey: UserDefaults.UserKeys.api_key)
//        let image_url = UserDefaults.standard.string(forKey: UserDefaults.UserKeys.image_url)
//        if(id > 0){
//            return User(id: id, uid: uid!, name: name!, email: email!, image_url: image_url!, username: username!, country: country!, api_key: api_key!, fav_book: fav_book!, fav_chapter: fav_chapter!, fav_verse: fav_verse!)
//        }else{
//            return nil
//        }
//    }
//    
//}



