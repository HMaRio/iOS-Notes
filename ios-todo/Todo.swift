//
//  Todo.swift
//  ios-todo
//
//  Created by Mario Holper on 12.10.19.
//  Copyright © 2019 Mario Holper. All rights reserved.
//

import Foundation

struct Todo {
    //String Array in der Datei "todo.txt" im Documents-Verzeichnis speichern
    static func save(_ data: [String]) {
        if let url = docURL(for: "todo.txt") {
            do {
                //Array in eine lange Zeichenkette umwandeln
                let str = data.joined(separator: "\n")
                try str.write(to: url, atomically: true, encoding: .utf8)
            } catch {
                print(error)
            }
        }
    }
    static func load() -> [String] {
        if let url = docURL(for: "todo.txt") {
            do {
                let str = try String(contentsOf: url, encoding: .utf8)
                //Zeilen der Zeichenkette in eine String-Array umwandeln und zurückgeben
                return str.split { $0 == "\n"}.map { String($0)}
            }
            catch {
                print (error)
            }
        }
        return []
    }
    
    //liefert die URL für die Datei im Documents-Verzeichnis
    private static func docURL(for filename: String) -> URL? {
        //sollte immer genau ein Ergebnis liefern
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let docDir = urls.first {
            return docDir.appendingPathComponent(filename)
        }
        return nil
    }
}
