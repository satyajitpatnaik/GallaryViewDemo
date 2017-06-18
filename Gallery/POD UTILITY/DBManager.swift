//
//  DBManager.swift
//  Gallery
//
//  Created by Satyajit Patanaik on 6/18/17.
//  Copyright © 2017 SatyajitPatnaik. All rights reserved.
//

import UIKit

class DBManager: NSObject {

    /**
     Note: DB key ids.
     */
    let field_ImageID = "id"
    let field_ImageUrl = "url"
    let field_ImageLike = "lk"
    let field_ImageDisLike = "disLike"
    let field_ImageClick = "click"
    let field_ImageUpdated_at = "updated_at"
    let field_ImageCreated_at = "created_at"
    
    /**
     Note: (Singletone concept) shared instance of DBManager.
     */
    static let shared: DBManager = DBManager()
    
    /**
     Note: DB info.
     */
    let databaseFileName = "image"
    let databaseFileType = "sqlite"
    
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    /**
     Note: Function overloaded to initialization statment.
     */
    override init() {
        super.init()
        if let filePath = Bundle.main.path(forResource: databaseFileName, ofType: databaseFileType) {
            pathToDatabase = filePath
        }
    }
    
    
    /**
     Note: Function open the Sql DB.
     */
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        if database != nil {
            if database.open() {
                return true
            }
        }
        return false
    }
    
    /**
     Note: Function to update the information of eache respected section in Sql DB.
     */
    func updateImageInfo(query : String, ID : Int, clickCount : Int, likeCount : Int, disLikeCount : Int) {
        if openDatabase() {
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd yyyy"
                let currentDate = NSDate()
                let convertedDateString = dateFormatter.string(from: currentDate as Date)
                let date = dateFormatter.date(from: convertedDateString)
                try database.executeUpdate(query, values: [clickCount, likeCount, disLikeCount, ID, date])
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
    }
    
    /**
     Note: Function to get all image info from Sql DB.
     */
    func loadAllImageInfo() -> [ImageInfo]! {
        var movies : [ImageInfo] = []
        if openDatabase() {
            let query = "select * from ImageTable order by \(field_ImageLike) desc"
            do {
                let results = try database.executeQuery(query, values: nil)
                while results.next()
                {
                    let movie = ImageInfo(id: results.long(forColumn: field_ImageID), url: results.string(forColumn: field_ImageUrl)!, lk: results.long(forColumn: field_ImageLike), disLike: results.long(forColumn: field_ImageDisLike), click: results.long(forColumn: field_ImageClick), updated_at: results.date(forColumn: field_ImageUpdated_at), created_at: results.date(forColumn: field_ImageUpdated_at))
                    movies.append(movie)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return movies
    }
    
    /**
     Note: Function to update the respected info to Sql DB.
     */
    func refreshImageInfo(withID ID: Int, completionHandler: (_ movieInfo: ImageInfo?) -> Void) {
        let movieInfo: ImageInfo!
        
        if openDatabase() {
            let query = "select * from ImageTable where \(field_ImageID)=\(ID)"
            
            do {
                let results = try database.executeQuery(query, values: [ID])
                print(results)
                if results.next() {
                    let movie = ImageInfo(id: results.long(forColumn: field_ImageID), url: results.string(forColumn: field_ImageUrl)!, lk: results.long(forColumn: field_ImageLike), disLike: results.long(forColumn: field_ImageDisLike), click: results.long(forColumn: field_ImageClick), updated_at: results.date(forColumn: field_ImageUpdated_at), created_at: results.date(forColumn: field_ImageUpdated_at))
                    movieInfo = movie
                    completionHandler(movieInfo)
                }
                else {
                    print(database.lastError())
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        
    }
    
}
