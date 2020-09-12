//
//  main.swift
//  Sokoban for Remote
//
//  Created by romangornostay on 9/12/20.
//  Copyright © 2020 Roman Gornostayev. All rights reserved.
//

import Foundation

enum Direction {
    case Left, Right ,Up, Down
}

struct Point {
    
    var x, y : Int
    
    func equalTo(_ point: Point) -> Bool {
        self.x == point.x && self.y == point.y
    }
    mutating func movePoint (_ direction: Direction) {
        switch direction {
        case .Left:
            return self.x -= 1
        case .Right:
            return self.x += 1
        case .Up:
            return self.y -= 1
        case .Down:
            return self.y += 1
        }
    }
    static func random(units: [Unit], width: Int, height: Int ) -> Point? {
        repeat {
            let pos = Point(x: Int.random(in: 2...width - 2), y: Int.random(in: 2...height - 2))
            if Unit.find(units: units, pos) == nil { return pos }
        } while true
    }
}

class Unit {
    enum UnitTypes : Character {
        case Mushroom = "🍄", Hero = "🐥", Hole = "🔳", Border = "🌳"
    }
    var locate : Point
    static var defaultPosition = Point(x: 0, y: 0)
    var type : UnitTypes
    
    static func find(units:[Unit], _ pos: Point) -> Unit? {
        for unit in units {
            if unit.locate.equalTo(pos) { return unit }
        }
        return nil
    }
    
    init(type: UnitTypes, locate: Point = Unit.defaultPosition) {
        self.type = type
        self.locate = locate
    }
}

class Room {
    
    let width: Int
    let height: Int
    
    var units: [Unit] {
        get {
        Room.createRoomUnit()
        }
        set {}
    }
    var hero: Unit {
        units.filter{$0.type == .Hero}[0]
    }
    var hole: Unit {
        units.filter{$0.type == .Hole}[0]
    }
    
   static func createRoomUnit( widht: Int = 10, height: Int = 8, level: Int = 8) -> [Unit] {
    
        var units = [Unit]()
        
        let hero = Unit(type: .Hero)
        if let pos = Point.random(units: units, width: widht, height: height) {
            hero.locate = pos
            units.append(hero)
        }
        
        for i in 0..<height {
            var b = Unit(type: .Border, locate: Point(x: 0, y: i))
            units.append(b)
            b = Unit(type: .Border, locate: Point(x: widht - 1, y: i))
            units.append(b)
        }
        for i in 1..<widht - 1 {
            var b = Unit(type: .Border, locate: Point(x: i, y: 0))
            units.append(b)
            b = Unit(type: .Border, locate: Point(x: i, y: height - 1))
            units.append(b)
        }
        
        for _ in 0...level/2 {
            if let pos = Point.random(units: units, width: widht, height: height) {
                let b = Unit(type: .Border, locate: pos)
                units.append(b)
            }
        }
        
        for _ in 0..<level {
            if let pos = Point.random(units: units, width: widht - 1, height: height - 1) {
                let m = Unit(type: .Mushroom, locate: pos)
                units.append(m)
            }
        }
        
        
        let hole = Unit(type: .Hole)
        if let pos = Point.random(units: units, width: widht, height: height) {
            hole.locate = pos
            units.append(hole)
        }

    
        return units
    }
    
    func render() -> String {
        var str = ""
        for i in 0..<height {
            for j in 0..<width {
                let unit = Unit.find(units: units, Point(x: j, y: i))
                str += String(unit?.type.rawValue ?? "⬜️")
            }
            str += "\n"
        }
        return str
    }
    // Unit's index search for remove from array
    func unitIndex(_ unit: Unit) -> Int? {
      for (index, value) in units.enumerated() {
        if unit.locate.x == value.locate.x && unit.locate.y == value.locate.y {
          return index
        }
      }
      return nil
    }
    
    func moveHeroTo(_ direction: Direction) {
        var moveUnits = [Unit]()
        var heroPos = hero.locate
        print("HERO")
        repeat {
            if let unit = Unit.find(units: units, heroPos) {
                if unit.type == .Border {
                    moveUnits.removeAll()
                    break
                }
                if unit.type == .Hole {
                    break
                }
                moveUnits.append(unit)
                
            } else {break}
            
            heroPos.movePoint(direction)
            
        } while true
        
        for unit in moveUnits {
            unit.locate.movePoint(direction)
            if unit.type == .Mushroom && unit.locate.equalTo(hole.locate) {
                let index = unitIndex(unit)
                units.remove(at: index!)
            }
        }
    }
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
       
    }
  convenience init() {
    self.init(width: 10, height: 8)
    }

//var room = Room.createRoom()

func showLabel(_ label: String) {
    print("""






        \(label)






    """)
  }
  
  // Бесконечный цикл для консольного приложения
func start() {
    for _ in 1... {
      print(render())
      print("[w][s] - up , down")
      print("[a][d] - left, right\n[enter] - readLine")
//        guard Unit.find(units: units,) != nil
//        else {break}
      // Ввод c консоли
      let enter = readLine()
      
        switch enter?.lowercased() {
        case "w": _ = moveHeroTo(.Up)
        case "s": _ = moveHeroTo(.Down)
        case "a": _ = moveHeroTo(.Left)
        case "d": _ = moveHeroTo(.Right)
        default: break
        
      
      }
    }
  }
}

var room = Room()
//room.moveHeroTo(.Down)
room.showLabel("LEVEL 1")
sleep(3)
room.start()

//room = Room(width: 7, height: 5)
//room.showLabel("LEVEL 2")
//sleep(1)
//room.start()
//
//sleep(1)
//room.showLabel("YOU WIN!")





