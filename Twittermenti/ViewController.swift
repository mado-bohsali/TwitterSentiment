//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//

import UIKit
import SwifteriOS //Twitter framework for iOS & OS X
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = TweetSentimentClassifer()
    let swifter = Swifter(consumerKey: "bSwrWxR6YSDL0zmpZerlQRVJ5", consumerSecret: "tA7HofTQOgyop3zM7JNvYri7XsSMjuNY2hBFgYmVUQJF5j1pj7")

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /** Predicts sentiment of user from his tweet.
    - Parameter recipient: The person being greeted.
    - Throws: N/A
    - Returns: N/A
    */
    
    func makePrediction(with tweets: [TweetSentimentClassiferInput]){
        
        do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                
            var sentimentScore = 0
            for prediction in predictions {
                let sentiment = prediction.label
                
                if sentiment == "Pos" {
                    sentimentScore += 1
                } else if sentiment == "Neg" {
                    sentimentScore -= 1
                } else {
                    continue
                }
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }

    }

    @IBAction func predictPressed(_ sender: Any) {
        
        if textField.text != nil {
            
            //collection of relevant tweets as per query
            swifter.searchTweet(using: "@\(textField.text!)", tweetMode: .extended, success: { (results, metadata) in
                
                var tweets = [TweetSentimentClassiferInput]()
                
                for i in 0..<100{
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassiferInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                    
                    self.makePrediction(with: tweets)
                }
                
            }) { (error) in
                print(error.localizedDescription)
                print("Error in Twitter search request: \(error)")
                
            }
            
            let prediction = try! sentimentClassifier.prediction(text: "")
            print(prediction.label) //positive negative or neutral
      }
    }
    
}

