//: Playground - using XMLParser

import UIKit

let xmlData = """
<items>
    <item>
      <brand name="Scott" />
      <model>Scott Plasma 10</model>
      <description>The SCOTT Plasma 10 has been designed with many similar features as the Plasma Team
      </description>
      <enclosure url="https://www.scott-sports.com/us/en/product/scott-plasma-10-bike" />
    </item>
    <item>
      <brand name="Cervelo" />
      <model>CERVELO P3 ULTEGRA BIKE</model>
      <description>Cervélo’s P3 can stand on its own.
      </description>
      <enclosure url="https://www.racycles.com/triathlon/cervelo/cervelo-p3-ultegra-bike-10160" />
    </item>
</items>
""".data(using: .utf8)!

class Item {
    var brand = Brand()
    var enclosure = Enclosure()
}

class Brand {
    var name = ""
}

class Enclosure {
    var url = ""
}

class ViewController: UIViewController {
    var item = Item()
    var items = [Item]()
    var foundCharacters = ""
    
    func parseXML() {
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parser.parse()
    }
}

extension ViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "brand" {
            let tempBrand = Brand()
            if let name = attributeDict["name"] {
                tempBrand.name = name
            }
            item.brand = tempBrand
        }
        if elementName == "enclosure" {
            let tempEnclosure = Enclosure()
            if let url = attributeDict["url"] {
                tempEnclosure.url = url
            }
            item.enclosure = tempEnclosure
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let tempItem = Item()
            tempItem.brand = self.item.brand
            tempItem.enclosure = self.item.enclosure
            items.append(tempItem)
        }
        foundCharacters = ""
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("there are \(items.count) items")
        for item in items {
            print("item brand: \(item.brand.name)")
            print("item enclosure url: \(item.enclosure.url)")
        }
    }
}

let viewController = ViewController()
viewController.parseXML()
