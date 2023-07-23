//
//  AuthManager.swift
//  KotifyMusic
//
//  Created by Nguyen  Khoa on 19/05/2023.
//

import Foundation

final class AuthManager
{
    static let shared = AuthManager()
    
    struct Constants{
        static let clientID = "f64f149b157748848b30e9d2760d8343"
        static let clientSceret = "54feb4447512431f81b98c1211ad22b8"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    }
    
    private init(){}
    
    public var signInURL: URL?{
        let scopes = "user-read-private"
        let redirectURI = "https://www.instagram.com/phuongkhoaaa/"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
       return URL(string: string)
    }
    
    var isSignedIn: Bool{
        return false
    }
    
    private var accessToken: String?{
        return nil
    }
    
    private var refreshToken: String?{
        return nil
    }
    
    private var tokenExpirationDate: Date?{
        return nil
    }
    
    private var shouldRefreshToken: Bool
    {
        return false
    }
    
    public func exchangeCodeForToken(code:String, completion: @escaping((Bool) -> Void))
    {
        var component = URLComponents()
        component.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "https://www.instagram.com/phuongkhoaaa/")
        ]
        //Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else
        {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody =  component.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSceret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else
        {
            print("failed to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request){
            data, _,error in  guard let data = data, error == nil else {
                completion(false)
                return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                print("Success: \(json)")
                completion(true)
            }
            catch
            {
                print(error.localizedDescription)
                completion(false)
            }
 
        }
        task.resume()
        
        
    }
    public func refreshAccessToken()
    {
        
    }
    private func cacheToken()
    {
        
    }
    
}
