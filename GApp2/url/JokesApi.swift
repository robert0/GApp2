//
//  File.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation

class JokesApi {
    let jokeUrl = URL(string: "https://v2.jokeapi.dev/joke/Programming")!
    
    func getRandomJoke(completion:@escaping (Joke) -> ()) {
        URLSession.shared.dataTask(with: jokeUrl) { data,_,_  in
            let joke = try! JSONDecoder().decode(Joke.self, from: data!)
            
            DispatchQueue.main.async {
                completion(joke)
            }
        }
        .resume()
    }
    
    
    //POST request to send a joke
    func sendJoke(joke: Joke, completion: @escaping (Result<Bool, Error>) -> ()) {
        let postUrl = URL(string: "https://example.com/api/jokes")!
        var request = URLRequest(url: postUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(joke)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    
    //POST request to send a joke
    func sendGesturePOST(gs: GestureObj, completion: @escaping (Result<Bool, Error>) -> ()) {
        let postUrl = URL(string: "https://example.com/api/jokes")!
        var request = URLRequest(url: postUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(gs)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
}
