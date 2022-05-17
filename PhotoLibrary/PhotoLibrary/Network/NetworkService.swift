//
//  NetworkService.swift
//  PhotoLibrary
//
//  Created by Dima on 16.05.22.
//

import Foundation

class NetworkService {
    private init() {}
    
    static let shared: NetworkService = NetworkService()
    
    func getURL (result: @escaping ((MainModel?) -> ())) {
        let url = URL(string: "https://dev.bgsoft.biz/task/credits.json")
        var request = URLRequest(url:url!)
        request.httpMethod = "GET"
        let task = URLSession(configuration: .default)
        task.dataTask(with: request) {(data,response, error) in
            if error == nil {
                let decoder = JSONDecoder()
                var decoderModel: MainModel?
                if data != nil {
                    decoderModel = try? decoder.decode(MainModel.self, from: data!)
                }
                result(decoderModel)
            }else {
                print(error as Any)
            }
        }.resume()
    }
}
