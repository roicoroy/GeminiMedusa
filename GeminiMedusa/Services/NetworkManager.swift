import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "http://localhost:9000"
    private let publishableKey = "pk_7b9a964b0ae6d083f0d2e70a5db350e2d6a7d93aceea46949373ff2872ead0fc"
    
    private init() {}
    
    // Generic function for requests that return decodable objects
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        requiresAuth: Bool = false
    ) -> AnyPublisher<T, Error> {
        return self.requestData(endpoint: endpoint, method: method, body: body, requiresAuth: requiresAuth)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // Function for requests where we need the raw data
    func requestData(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        requiresAuth: Bool = false
    ) -> AnyPublisher<Data, Error> {
        let fullURLString: String
        if endpoint.starts(with: "auth/") {
            fullURLString = "\(baseURL)/\(endpoint)"
        } else {
            fullURLString = "\(baseURL)/store/\(endpoint)"
        }

        guard let url = URL(string: fullURLString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(publishableKey, forHTTPHeaderField: "x-publishable-api-key")
        
        if requiresAuth, let token = UserDefaults.standard.string(forKey: "auth_token") {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            urlRequest.httpBody = body
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> Data in
                if let httpResponse = response as? HTTPURLResponse {
                    
//                    print("response::::::: \(response)")
                    
                    if httpResponse.statusCode >= 400 {
                    print("NetworkManager Error: Status Code \(httpResponse.statusCode)")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("NetworkManager Error: Response Data \(responseString)")
                    }
                    throw URLError(.badServerResponse)
                }
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}
