//
//  AppStoreReponse.swift
//  FormApp
//
//  Created by Hany Alkahlout on 07/06/2023.
//

import Foundation


struct AppStoreReponse:Decodable{
    var results:[VersionData]?
}


struct VersionData:Decodable{
    var version:String?
}
