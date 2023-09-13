//
//  VersionModel.swift
//  FormApp
//
//  Created by Hany Alkahlout on 07/06/2023.
//

import Foundation


struct VersionModel:Decodable{
    var version:String?
}


struct AppStoreReponse:Decodable{
    var results:[VersionModel]?
}
                                                                                                                                                   
