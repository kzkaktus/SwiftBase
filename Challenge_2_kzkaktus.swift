class Ship {
  var locations: [Location]
  var passengerList: [Passenger]
  var crewList: [CrewMember]
  var engines: [Engine]

  init(locations: [Location], passengerList: [Passenger], crewList: [CrewMember], engines: [Engine]) {
    self.locations = locations
    self.passengerList = passengerList
    self.crewList = crewList
    self.engines = engines
  }
}

class Engine {
  let name: String
  let kHP: Double
  var isActive: Bool

  func switchState() {
    self.isActive = !(self.isActive)
  }

  func turn(person: Person, toON: Bool, stateName: String, stateDesc: String) {
    let isOperating: Bool = self.isActive
    if (person is Captain) {
      if (isOperating == toON) {
        print("Can't turn engine \(stateName) - it's already \(stateDesc).")
      } else {
        print("Engine \(self.name) is now \(stateDesc).")
        self.switchState()
      }
    } else {
      print("\(person.firstName) \(person.lastName) can't turn engine \(stateName) - only ship captain can do that.")
    }
  }

  func turnOff(person: Person) {
    self.turn(person: person, toON: false, stateName: "off", stateDesc: "inactive")
  }

  func turnOn(person: Person) {
    self.turn(person: person, toON: true, stateName: "on", stateDesc: "active")
  }

  init(name: String, kHP: Double, isActive: Bool) {
    self.name = name
    self.kHP = kHP
    self.isActive = isActive
  }
}

class Person {
  let age: Int
  let firstName: String
  let lastName: String

  init(age: Int, firstName: String, lastName: String) {
    self.age = age
    self.firstName = firstName
    self.lastName = lastName
  }
}

class Passenger: Person {
  var cabinNumber: Int
  var whereNow: Location
  var friendlist: [Passenger] //in challenge description tourist can be assigned to a cabin with their friends

  init(age: Int, firstName: String, lastName: String, whereNow: Location, cabinNumber: Int, friendlist: [Passenger]) {
    self.cabinNumber = cabinNumber
    self.whereNow = whereNow
    self.friendlist = friendlist
    super.init(age: age, firstName: firstName, lastName: lastName)
  }
}

class CrewMember: Person {

}

class Captain: CrewMember {

}

class Location {
  let capacity: Int
  var occupancy: Int
  let name: String

  func writeOccupancy() {
    print("\(self.name) current occupancy: \(self.occupancy)")
  }

  func enter(person: Passenger) {
    person.whereNow.occupancy -= 1
    person.whereNow = self
    person.whereNow.occupancy += 1
    print("Passenger \(person.firstName) \(person.lastName) succesfully entered \(self.name)")
  }

  func enterAttempt(person: Passenger) {
    if (capacity == occupancy) {
      print("Passenger \(person.firstName) \(person.lastName) can't enter \(self.name) - it's full.")
    } else {
      self.enter(person: person)
    }
  }

  init(capacity: Int, occupancy: Int, name: String) {
    self.capacity = capacity
    self.occupancy = occupancy
    self.name = name
  }
}

class Cabin: Location {
  let number: Int

  func assign(person: Passenger) {
    if (self.capacity == self.occupancy) {
      print("can't assign passenger to the cabin - it's full.")
    } else {
      self.occupancy += 1
      person.cabinNumber = self.number
    }
  }

  override func enterAttempt(person: Passenger) {
    if (person.cabinNumber == self.number) {
      self.enter(person: person)
    } else {
      print("Passenger \(person.firstName) \(person.lastName) can't enter cabin number \(self.number) - they are not assigned to this cabin")
    }
  }

  init(capacity: Int, occupancy: Int, name: String, number: Int) {
    self.number = number
    super.init(capacity: capacity, occupancy: occupancy, name: name)
  }

}

class Bar: Location {
  override func enterAttempt(person: Passenger) {
    if (person.age < 18) {
      print("Passenger \(person.firstName) \(person.lastName) can't enter \(self.name) - they are underage")
    } else if (capacity == occupancy) {
      print("Passenger \(person.firstName) \(person.lastName) can't enter \(self.name) - it's full.")
    } else {
      self.enter(person: person)
    }
  }
}

class Restaurant: Location {

}

//creating example data
var smallEngine = Engine(name: "Small engine", kHP: 2, isActive: false)
var bigEngine = Engine(name: "Big engine", kHP: 4, isActive: false)
var engines: [Engine] = [smallEngine, bigEngine]
var defaultLocation = Location(capacity: 1000, occupancy: 0, name: "Default location")
var passengers: [Passenger] = []
for i in 1...350 {
  let examplePassenger = Passenger(age: 30, firstName: "ExamplePassenger", lastName: "Number\(i)", whereNow: defaultLocation, cabinNumber: 0, friendlist: [])
  if (i == 40) {
    let underagePassenger = Passenger(age: 15, firstName: "John", lastName: "Smith", whereNow: defaultLocation, cabinNumber: 0, friendlist: [])
    passengers.append(underagePassenger)
  } else {
    passengers.append(examplePassenger)
  }
  
}
var locations: [Location] = []
for i in 1...50 {
  let bigCabin = Cabin(capacity: 4, occupancy: 0, name: "cabin \(i)", number: i)
  let x = (i - 1)*4
  for j in (x)...(x+3) {
    bigCabin.assign(person: passengers[j])
  }
  locations.append(bigCabin)
}
for i in 51...125 {
  let smallCabin = Cabin(capacity: 2, occupancy: 0, name: "cabin \(i)", number: i)
  let x = 200 + (i - 51)*2
  for j in (x)...(x+1) {
    smallCabin.assign(person: passengers[j])
  }
  locations.append(smallCabin)
}
for i in 0...349 {
  let p = passengers[i]
  p.whereNow = locations[p.cabinNumber - 1]
}
let bar1 = Bar(capacity: 50, occupancy: 0, name: "bar 1")
locations.append(bar1)
let bar2 = Bar(capacity: 50, occupancy: 0, name: "bar 2")
locations.append(bar2)
let restaurant = Restaurant(capacity: 300, occupancy: 0, name: "restaurant")
locations.append(restaurant)
var crew: [CrewMember] = []
for _ in 1...49 {
  let defaultCrewMember = CrewMember(age: 45, firstName: "Default", lastName: "CrewMember")
  crew.append(defaultCrewMember)
}
let captain = Captain(age: 55, firstName: "Default", lastName: "ShipCaptain")
crew.append(captain)
let myShip = Ship(locations: locations, passengerList: passengers, crewList: crew, engines: engines)

//examples
print("\nEXAMPLE: FULL BAR")
for i in 100...150 {
  bar1.enterAttempt(person: passengers[i])
}
print("\nEXAMPLE: UNDERAGE PASSENGER & CABINS")
var underage = passengers[39]
print("\(underage.firstName) \(underage.lastName)'s cabin number is \(underage.cabinNumber)")
locations[9].writeOccupancy()
restaurant.writeOccupancy()
restaurant.enterAttempt(person: underage)
locations[9].writeOccupancy()
restaurant.writeOccupancy()
bar1.writeOccupancy()
bar1.enterAttempt(person: underage)
bar1.writeOccupancy()
locations[9].writeOccupancy()
locations[9].enterAttempt(person: underage)
locations[9].writeOccupancy()
restaurant.writeOccupancy()
locations[10].enterAttempt(person: underage)
print("\nEXAMPLE: ENGINES")
smallEngine.turnOff(person: captain)
smallEngine.turnOn(person: captain)
smallEngine.turnOff(person: passengers[55])


