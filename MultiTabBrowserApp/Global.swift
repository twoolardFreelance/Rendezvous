//
//  Global.swift
//  MultiTabBrowserApp
//
//  Created by King on 2019/12/18.
//  Copyright © 2019 AJB. All rights reserved.
//

import Foundation
import Alamofire

struct Global {
    
//    static var currentProfile: Profile?
    
//    static func getCurrentProfile() -> Profile? {
//        if let data = UserDefaults.standard.object(forKey: "currentProfile") as? Data {
//            let profile = NSKeyedUnarchiver.unarchiveObject(with: data)
//            return profile as? Profile ?? nil
//        }
//        return nil
//    }
//    
//    static func setCurrentProfile(_ profile: Profile) {
//        let data = NSKeyedArchiver.archivedData(withRootObject: profile)
//        UserDefaults.standard.set(data, forKey: "currentProfile")
//    }
    static let myWebhookUrl = "https://discordapp.com/api/webhooks/680495587593814108/SiGaw7c1DVySRc_FS25xC1LKS7rDVVVDjB-amO__f-Ox7vRGkBmZdtKJlDu7DHrpB43A" //My url for splash status
    
static let myWebhookPurchaseSuccess = "https://discordapp.com/api/webhooks/683217325821788171/4mX2PF8sGp0G1q9IkxAoi9oQKcBNZDAJ8cdPSZbV_R1XEiwIwluRa7pJZpjlnohFurbQ"

    static func sendWebhookMessage(url: String, message: [String: Any], completionHandler: @escaping ()->Void ) {
        
        Alamofire.request(url, method: .post, parameters: message, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON { response in
            print(">>> Result: \(response)")
            completionHandler()
        }
    }
    
    static func setProfiles(_ profiles: [Profile]) {
        let data = NSKeyedArchiver.archivedData(withRootObject: profiles)
        UserDefaults.standard.set(data, forKey: "profiles")
    }
    
    static func getProfiles() -> [Profile] {
        if let data = UserDefaults.standard.object(forKey: "profiles") as? Data {
            let profiles = NSKeyedUnarchiver.unarchiveObject(with: data)
            return profiles as? [Profile] ?? []
        }
        return []
    }
    
    static var states: [String: String] = [
        "AA":"AA Military",
        "AE":"AE Military",
        "AP":"AP Military",
        "AL":"Alabama",
        "AK":"Alaska",
        "AZ":"Arizona",
        "AR":"Arkansas",
        "CA":"California",
        "CO":"Colorado",
        "CT":"Connecticut",
        "DE":"Delaware",
        "DC":"District Of Columbia",
        "FL":"Florida",
        "GA":"Georgia",
        "HI":"Hawaii",
        "ID":"Idaho",
        "IL":"Illinois",
        "IN":"Indiana",
        "IA":"Iowa",
        "KS":"Kansas",
        "KY":"Kentucky",
        "LA":"Louisiana",
        "ME":"Maine",
        "MD":"Maryland",
        "MA":"Massachusetts",
        "MI":"Michigan",
        "MN":"Minnesota",
        "MS":"Mississippi",
        "MO":"Missouri",
        "MT":"Montana",
        "NE":"Nebraska",
        "NV":"Nevada",
        "NH":"New Hampshire",
        "NJ":"New Jersey",
        "NM":"New Mexico",
        "NY":"New York",
        "NC":"North Carolina",
        "ND":"North Dakota",
        "OH":"Ohio",
        "OK":"Oklahoma",
        "OR":"Oregon",
        "PA":"Pennsylvania",
        "RI":"Rhode Island",
        "SC":"South Carolina",
        "SD":"South Dakota",
        "TN":"Tennessee",
        "TX":"Texas",
        "UT":"Utah",
        "VT":"Vermont",
        "VA":"Virginia",
        "WA":"Washington",
        "WV":"West Virginia",
        "WI":"Wisconsin",
        "WY":"Wyoming"
    ]
}

struct DummyData {
    static let discordMessageTest = [
       // "content": "Motion Browser",
        "username": "Motion Browser",
        "embeds": [[
            "title": "Notification Test",
            "description": "Hey there 👋, It's Motion.",
            "color": 558869
            ],
            //[
          //  "title": "Hello!",
           // "description": "Hi! :grinning:",
          //  "color": 009966
           // ]
        ]
    ] as [String: Any]
    
    static let discordMessagePassedSplash = [
        "username": "Motion Browser",
               "embeds": [[
                   "title": "Passed Splash ✅",
                   "description": "A task has passed the Yeezy Supply waiting room 🥳",
                   "color": 558869
                   ],
    
               ]
           ] as [String: Any]
    
    static let discordMessageInSplash = [
       // "content": "Motion Browser",
        "username": "Motion Browser",
        "embeds": [[
            "title": "In Splash ⚠️",
            "description": "A task is in the Yeezy Supply waiting room",
            "color": 16448020
            ],
            //[
          //  "title": "Hello!",
           // "description": "Hi! :grinning:",
          //  "color": 009966
           // ]
        ]
    ] as [String: Any]
   /* "username": "Webhook",
    "avatar_url": "https://i.imgur.com/4M34hi2.png",
    "content": "Motion Success",
    "embeds": [
      [
        "author": [
          "name": "Motion",
          "url": "https://www.reddit.com/r/cats/",
          "icon_url": "https://i.imgur.com/R66g1Pe.jpg"
        ],
        "title": "Title",
        "url": "https://google.com/",
        "description": "Text message. You can use Markdown here. *Italic* **bold** __underline__ ~~strikeout~~ [hyperlink](https://google.com) `code`",
        "color": 558869,
        "fields": [
          [
            "name": "Text",
            "value": "More text",
            "inline": true
          ],
          [
            "name": "Even more text",
            "value": "Yup",
            "inline": true
          ],
          [
            "name": "Use `\"inline\": true` parameter, if you want to display fields in the same line.",
            "value": "okay..."
          ],
          [
            "name": "Thanks!",
            "value": "You're welcome :wink:"
          ]
        ],
        "thumbnail": [
          "url": "https://upload.wikimedia.org/wikipedia/commons/3/38/4-Nature-Wallpapers-2014-1_ukaavUI.jpg"
        ],
        "image": [
          "url": "https://upload.wikimedia.org/wikipedia/commons/5/5a/A_picture_from_China_every_day_108.jpg"
        ],
        "footer": [
          "text": "Sent with love from Motion Browser for iOS",
          "icon_url": "https://imgur.com/xxy1jIe"
        ]
      ]
    ]
      ] as [String: Any]
*/
    static let discordMessagePurchaseSuccessful = [
           "username": "Motion Browser",
                  "embeds": [[
                      "title": "Purchase Successful ✅",
                      "description": "A successful purchase was made on Yeezy Supply 🥳",
                      "color": 558869
                      ],
       
                  ]
              ] as [String: Any]

}
