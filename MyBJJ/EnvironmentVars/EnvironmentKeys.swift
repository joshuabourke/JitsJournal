//
//  EnvironmentKeys.swift
//  MyBJJ
//
//  Created by Josh Bourke on 26/8/2024.
//

import Foundation


public enum EnvironmentKeys {
    enum Keys {
        static let apiKey = "SUPABASE_API_KEY"
        static let url = "SUPABASE_URL"
    }
    
    //Getting plist here
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()
    
    //Get api and url from plist
    static let url: String =  {
        guard let urlString = EnvironmentKeys.infoDictionary[Keys.url] as? String else {
            fatalError("Url not set in plist")
        }
        print("### URL \(urlString)")
        return urlString
    }()
    
    static let api: String = {
        guard let apiString = EnvironmentKeys.infoDictionary[Keys.apiKey] as? String else {
            fatalError("Api key not set in plist")
        }
        print("### API \(apiString)")
        return apiString
    }()
}
