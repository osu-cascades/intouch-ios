

import Foundation

class Settings {
    
    struct Keys {
        static let username = "USERNAME"
        static let password = "PASSWORD"
        static let loggedIn = "LOGGED_IN"
        static let userType = "USER_TYPE"
    }
    
    class func setUsernameAndPassword(username: String, password: String) {
        UserDefaults.standard.set(username, forKey: Keys.username)
        UserDefaults.standard.set(password, forKey: Keys.password)
        UserDefaults.standard.set("true", forKey: Keys.loggedIn)
    }
    
    class func clearUsernameAndPassword() {
        UserDefaults.standard.set("", forKey: Keys.username)
        UserDefaults.standard.set("", forKey: Keys.password)
        UserDefaults.standard.set("false", forKey: Keys.loggedIn)
    }
    
    class func getUsername() -> String {
        return UserDefaults.standard.string(forKey: Keys.username)!
    }
    
    class func setUserType(type: String) {
        UserDefaults.standard.set(type, forKey:Keys.userType)
    }
    class func getUserType() -> String? {
        return UserDefaults.standard.string(forKey: Keys.userType)
    }
    
}
