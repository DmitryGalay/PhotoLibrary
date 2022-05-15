////
////  NetworkManager.swift
////  WeatherApp
////
////  Created by Dima on 21.11.21.
////
//
//import Foundation
//
//class NetworkManager {
//    private init() {}
//    static let shared:NetworkManager = NetworkManager()
//
//    func  getPhoto(name:String, result: @escaping ((OfferModel?) -> ())) {
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = "dev.bgsoft.biz"
//        urlComponents.path = "/task/"
//        urlComponents.queryItems = [URLQueryItem(name: "/(name.jpg)", value: name),
//        ]
//        var request = URLRequest(url: urlComponents.url!)
//        request.httpMethod = "GET"
//        let task = URLSession(configuration: .default)
//        task.dataTask(with: request) {(data,response, error) in
//            if error == nil {
//                let decoder = JSONDecoder()
//                var decoderOfferModel: OfferModel?
//                if data != nil {
//                    decoderOfferModel = try? decoder.decode(OfferModel.self, from: data!)
//                }
//                result(decoderOfferModel)
//            }else {
//                print(error as Any)
//            }
//        }.resume()
//    }
//}
