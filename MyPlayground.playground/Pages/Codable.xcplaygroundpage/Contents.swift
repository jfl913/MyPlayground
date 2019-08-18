import UIKit

//:[用 Codable 协议实现快速 JSON 解析](http://swiftcafe.io/post/codable)

struct Person: Codable {
    var name: String
    var gender: String = ""
    var age: Int
    
    var height: Int
    var weight: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case age
        case body
    }
    
    enum BodyKeys: String, CodingKey {
        case height
        case weight
    }
}

extension Person {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        age = try values.decode(Int.self, forKey: .age)
        
        let body = try values.nestedContainer(keyedBy: BodyKeys.self, forKey: .body)
        height = try body.decode(Int.self, forKey: .height)
        weight = try body.decode(Int.self, forKey: .weight)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        
        var body = container.nestedContainer(keyedBy: BodyKeys.self, forKey: .body)
        try body.encode(height, forKey: .height)
        try body.encode(weight, forKey: .weight)
    }
}

let person = Person(name: "swift", gender: "female", age: 18, height: 170, weight: 180)


let encoder = JSONEncoder()
let data = try encoder.encode(person)
let encodedString = String(data: data, encoding: .utf8)
print(encodedString ?? "")

let jsonString =  "{\"name\":\"swift\",\"age\":18,\"body\":{\"weight\":180,\"height\":170}}"
let jsonData = jsonString.data(using: .utf8)
let decoder = JSONDecoder()
if let jsonData = jsonData {
    let result = try decoder.decode(Person.self, from: jsonData)
    print(result)
}





