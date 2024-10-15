import 'dart:io';

void main() {
  CLI cli = CLI();
  cli.start();
}

// --- Data Models ---

class Person {
  String? name;
  int? personNumber;

  Person({this.name, this.personNumber});

  @override
  String toString() {
    return 'Person: Name: $name, Person Number: $personNumber';
  }
}

class Vehicle {
  int? regNumber;
  String? type;
  Person? owner;

  Vehicle({this.regNumber, this.type, this.owner});

  @override
  String toString() {
    return 'Vehicle: Reg Number: $regNumber, Type: $type, Owner: ${owner?.name}';
  }
}

class ParkingSpace {
  String? id;
  String? address;
  int? price;

  ParkingSpace({this.id, this.address, this.price});

  @override
  String toString() {
    return 'ParkingSpace: ID: $id, Address: $address, Price: $price';
  }
}

class Parking {
  Vehicle? vehicle;
  ParkingSpace? parkingPlace;
  DateTime? startTime;
  DateTime? endTime;

  Parking({this.vehicle, this.parkingPlace, this.startTime, this.endTime});

  @override
  String toString() {
    return 'Parking: Vehicle: ${vehicle?.regNumber}, Parking Place: ${parkingPlace?.id}, Start: $startTime, End: $endTime';
  }
}

// --- Repository Interfaces ---

abstract class Repository<T, ID> {
  void add(T item);
  List<T> getAll();
  T? getById(ID id); // T? makes the return type nullable, handling the case where an item might not be found
  void update(T item);
  void delete(ID id);
}

// --- Repositories ---

class PersonRepository implements Repository<Person, int> {
  List<Person> _persons = [];

  @override
  void add(Person person) {
    _persons.add(person);
  }

  @override
  List<Person> getAll() => _persons;

  @override
  Person? getById(int id) {
    try {
      return _persons.firstWhere((p) => p.personNumber == id);
    } catch (e) {
      return null; // Return null when not found
    }
  }

  @override
  void update(Person person) {
    var index = _persons.indexWhere((p) => p.personNumber == person.personNumber);
    if (index != -1) {
      _persons[index] = person;
    }
  }

  @override
  void delete(int id) {
    _persons.removeWhere((p) => p.personNumber == id);
  }
}

class VehicleRepository implements Repository<Vehicle, int> {
  List<Vehicle> _vehicles = [];

  @override
  void add(Vehicle vehicle) {
    _vehicles.add(vehicle);
  }

  @override
  List<Vehicle> getAll() => _vehicles;

  @override
  Vehicle? getById(int id) {
    try {
      return _vehicles.firstWhere((v) => v.regNumber == id);
    } catch (e) {
      return null; // Return null when not found
    }
  }

  @override
  void update(Vehicle vehicle) {
    var index = _vehicles.indexWhere((v) => v.regNumber == vehicle.regNumber);
    if (index != -1) {
      _vehicles[index] = vehicle;
    }
  }

  @override
  void delete(int id) {
    _vehicles.removeWhere((v) => v.regNumber == id);
  }
}

class ParkingSpaceRepository implements Repository<ParkingSpace, String> {
  List<ParkingSpace> _parkingSpaces = [];

  @override
  void add(ParkingSpace space) {
    _parkingSpaces.add(space);
  }

  @override
  List<ParkingSpace> getAll() => _parkingSpaces;

  @override
  ParkingSpace? getById(String id) {
    try {
      return _parkingSpaces.firstWhere((p) => p.id == id);
    } catch (e) {
      return null; // Return null when not found
    }
  }

  @override
  void update(ParkingSpace space) {
    var index = _parkingSpaces.indexWhere((p) => p.id == space.id);
    if (index != -1) {
      _parkingSpaces[index] = space;
    }
  }

  @override
  void delete(String id) {
    _parkingSpaces.removeWhere((p) => p.id == id);
  }
}

class ParkingRepository implements Repository<Parking, int> {
  List<Parking> _parkings = [];

  @override
  void add(Parking parking) {
    _parkings.add(parking);
  }

  @override
  List<Parking> getAll() => _parkings;

  @override
  Parking? getById(int id) {
    try {
      return _parkings.firstWhere((p) => p.vehicle?.regNumber == id);
    } catch (e) {
      return null; // Return null when not found
    }
  }

  @override
  void update(Parking parking) {
    var index = _parkings.indexWhere((p) => p.vehicle?.regNumber == parking.vehicle?.regNumber);
    if (index != -1) {
      _parkings[index] = parking;
    }
  }

  @override
  void delete(int id) {
    _parkings.removeWhere((p) => p.vehicle?.regNumber == id);
  }
}

// --- CLI Implementation ---

class CLI {
  final personRepo = PersonRepository();
  final vehicleRepo = VehicleRepository();
  final parkingSpaceRepo = ParkingSpaceRepository();
  final parkingRepo = ParkingRepository();

  void start() {
    while (true) {
      print('Välkommen till Parkeringsappen!');
      print('Vad vill du hantera?');
      print('1. Personer');
      print('2. Fordon');
      print('3. Parkeringsplatser');
      print('4. Parkeringar');
      print('5. Avsluta');
      stdout.write('Välj ett alternativ (1-5): ');

      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          handlePersons();
          break;
        case '2':
          handleVehicles();
          break;
        case '3':
          handleParkingSpaces();
          break;
        case '4':
          handleParkings();
          break;
        case '5':
          print('Avslutar programmet...');
          return;
        default:
          print('Ogiltigt val, försök igen.');
      }
    }
  }

  // --- Methods for handling Person operations ---

  void handlePersons() {
    while (true) {
      print('Du har valt att hantera Personer. Vad vill du göra?');
      print('1. Skapa ny person');
      print('2. Visa alla personer');
      print('3. Uppdatera person');
      print('4. Ta bort person');
      print('5. Gå tillbaka till huvudmenyn');
      stdout.write('Välj ett alternativ (1-5): ');

      String? choice = stdin.readLineSync();

      switch (choice) {
        case "1":
          createPerson();
          break;
        case '2':
          listAllPersons();
          break;
        case '3':
          updatePerson();
          break;
        case '4':
          deletePerson();
          break;
        case '5':
          return; // Go back to the previous menu
        default:
          print('Ogiltigt val, försök igen.');
      }
    }
  }

  void createPerson() {
    stdout.write('Ange namn: ');
    String? name = stdin.readLineSync();
    stdout.write('Ange personnummer: ');
    int? personNumber = int.tryParse(stdin.readLineSync()!);
    if (name != null && personNumber != null) {
      personRepo.add(Person(name: name, personNumber: personNumber));
      print('Ny person skapad.');
    } else {
      print('Ogiltiga inmatningar, försök igen.');
    }
  }

  void listAllPersons() {
    var persons = personRepo.getAll();
    if (persons.isNotEmpty) {
      print('Alla personer:');
      persons.forEach((p) => print(p));
    } else {
      print('Inga personer tillgängliga.');
    }
  }

  void updatePerson() {
    stdout.write('Ange personnummer på personen du vill uppdatera: ');
    int? personNumber = int.tryParse(stdin.readLineSync()!);
    var person = personRepo.getById(personNumber!);
    if (person != null) {
      stdout.write('Ange nytt namn (aktuellt namn: ${person.name}): ');
      String? newName = stdin.readLineSync();
      if (newName != null) {
        person.name = newName;
        personRepo.update(person);
        print('Person uppdaterad.');
      } else {
        print('Ogiltig inmatning.');
      }
    } else {
      print('Personen hittades inte.');
    }
  }

  void deletePerson() {
    stdout.write('Ange personnummer på personen du vill ta bort: ');
    int? personNumber = int.tryParse(stdin.readLineSync()!);
    if (personRepo.getById(personNumber!) != null) {
      personRepo.delete(personNumber);
      print('Person borttagen.');
    } else {
      print('Personen hittades inte.');
    }
  }

// --- Other handlers for Vehicles, ParkingSpaces, and Parkings (similar logic to handlePersons) ---

  void handleVehicles() {
    while (true) {
      print('Du har valt att hantera Fordon. Vad vill du göra?');
      print('1. Skapa nytt fordon');
      print('2. Visa alla fordon');
      print('3. Uppdatera fordon');
      print('4. Ta bort fordon');
      print('5. Gå tillbaka till huvudmenyn');
      stdout.write('Välj ett alternativ (1-5): ');

      String? choice = stdin.readLineSync();

      switch (choice) {
        case "1":
          createVehicle();
          break;
        case '2':
          listAllVehicles();
          break;
        case '3':
          updateVehicle();
          break;
        case '4':
          deleteVehicle();
          break;
        case '5':
          return;
        default:
          print('Ogiltigt val, försök igen.');
      }
    }
  }

  void createVehicle() {
    stdout.write('Ange registreringsnummer: ');
    int? regNumber = int.tryParse(stdin.readLineSync()!);
    stdout.write('Ange typ av fordon (t.ex. bil, motorcykel): ');
    String? type = stdin.readLineSync();
    stdout.write('Ange personnummer för ägaren: ');
    int? ownerNumber = int.tryParse(stdin.readLineSync()!);
    
    Person? owner = personRepo.getById(ownerNumber!);

    if (regNumber != null && type != null && owner != null) {
      vehicleRepo.add(Vehicle(regNumber: regNumber, type: type, owner: owner));
      print('Nytt fordon skapat.');
    } else {
      print('Ogiltiga inmatningar eller ägare hittades inte.');
    }
  }

  void listAllVehicles() {
    var vehicles = vehicleRepo.getAll();
    if (vehicles.isNotEmpty) {
      print('Alla fordon:');
      vehicles.forEach((v) => print(v));
    } else {
      print('Inga fordon tillgängliga.');
    }
  }

  void updateVehicle() {
    stdout.write('Ange registreringsnummer på fordonet du vill uppdatera: ');
    int? regNumber = int.tryParse(stdin.readLineSync()!);
    var vehicle = vehicleRepo.getById(regNumber!);
    if (vehicle != null) {
      stdout.write('Ange ny typ av fordon (aktuell typ: ${vehicle.type}): ');
      String? newType = stdin.readLineSync();
      if (newType != null) {
        vehicle.type = newType;
        vehicleRepo.update(vehicle);
        print('Fordon uppdaterat.');
      } else {
        print('Ogiltig inmatning.');
      }
    } else {
      print('Fordonet hittades inte.');
    }
  }

  void deleteVehicle() {
    stdout.write('Ange registreringsnummer på fordonet du vill ta bort: ');
    int? regNumber = int.tryParse(stdin.readLineSync()!);
    if (vehicleRepo.getById(regNumber!) != null) {
      vehicleRepo.delete(regNumber);
      print('Fordon borttaget.');
    } else {
      print('Fordonet hittades inte.');
    }
  }

  void handleParkingSpaces() {
    while (true) {
      print('Du har valt att hantera Parkeringsplatser. Vad vill du göra?');
      print('1. Skapa ny parkeringsplats');
      print('2. Visa alla parkeringsplatser');
      print('3. Uppdatera parkeringsplats');
      print('4. Ta bort parkeringsplats');
      print('5. Gå tillbaka till huvudmenyn');
      stdout.write('Välj ett alternativ (1-5): ');

      String? choice = stdin.readLineSync();

      switch (choice) {
        case "1":
          createParkingSpace();
          break;
        case '2':
          listAllParkingSpaces();
          break;
        case '3':
          updateParkingSpace();
          break;
        case '4':
          deleteParkingSpace();
          break;
        case '5':
          return;
        default:
          print('Ogiltigt val, försök igen.');
      }
    }
  }

  void createParkingSpace() {
    stdout.write('Ange ID för parkeringsplats: ');
    String? id = stdin.readLineSync();
    stdout.write('Ange adress: ');
    String? address = stdin.readLineSync();
    stdout.write('Ange pris: ');
    int? price = int.tryParse(stdin.readLineSync()!);
    if (id != null && address != null && price != null) {
      parkingSpaceRepo.add(ParkingSpace(id: id, address: address, price: price));
      print('Ny parkeringsplats skapad.');
    } else {
      print('Ogiltiga inmatningar, försök igen.');
    }
  }

  void listAllParkingSpaces() {
    var parkingSpaces = parkingSpaceRepo.getAll();
    if (parkingSpaces.isNotEmpty) {
      print('Alla parkeringsplatser:');
      parkingSpaces.forEach((p) => print(p));
    } else {
      print('Inga parkeringsplatser tillgängliga.');
    }
  }

  void updateParkingSpace() {
    stdout.write('Ange ID på parkeringsplatsen du vill uppdatera: ');
    String? id = stdin.readLineSync();
    var parkingSpace = parkingSpaceRepo.getById(id!);
    if (parkingSpace != null) {
      stdout.write('Ange ny adress (aktuell adress: ${parkingSpace.address}): ');
      String? newAddress = stdin.readLineSync();
      if (newAddress != null) {
        parkingSpace.address = newAddress;
        parkingSpaceRepo.update(parkingSpace);
        print('Parkeringsplats uppdaterad.');
      } else {
        print('Ogiltig inmatning.');
      }
    } else {
      print('Parkeringsplatsen hittades inte.');
    }
  }

  void deleteParkingSpace() {
    stdout.write('Ange ID på parkeringsplatsen du vill ta bort: ');
    String? id = stdin.readLineSync();
    if (parkingSpaceRepo.getById(id!) != null) {
      parkingSpaceRepo.delete(id);
      print('Parkeringsplats borttagen.');
    } else {
      print('Parkeringsplatsen hittades inte.');
    }
  }

  void handleParkings() {
    while (true) {
      print('Du har valt att hantera Parkeringar. Vad vill du göra?');
      print('1. Skapa ny parkering');
      print('2. Visa alla parkeringar');
      print('3. Uppdatera parkering');
      print('4. Ta bort parkering');
      print('5. Gå tillbaka till huvudmenyn');
      stdout.write('Välj ett alternativ (1-5): ');

      String? choice = stdin.readLineSync();

      switch (choice) {
        case "1":
          createParking();
          break;
        case '2':
          listAllParkings();
          break;
        case '3':
          updateParking();
          break;
        case '4':
          deleteParking();
          break;
        case '5':
          return;
        default:
          print('Ogiltigt val, försök igen.');
      }
    }
  }

  void createParking() {
    stdout.write('Ange registreringsnummer för fordonet: ');
    int? regNumber = int.tryParse(stdin.readLineSync()!);
    stdout.write('Ange parkeringsplatsens ID: ');
    String? parkingId = stdin.readLineSync();
    stdout.write('Ange starttid (yyyy-mm-dd hh:mm): ');
    DateTime? startTime = DateTime.tryParse(stdin.readLineSync()!);
    stdout.write('Ange sluttid (yyyy-mm-dd hh:mm): ');
    DateTime? endTime = DateTime.tryParse(stdin.readLineSync()!);

    Vehicle? vehicle = vehicleRepo.getById(regNumber!);
    ParkingSpace? parkingSpace = parkingSpaceRepo.getById(parkingId!);

    if (vehicle != null && parkingSpace != null && startTime != null && endTime != null) {
      parkingRepo.add(Parking(
        vehicle: vehicle,
        parkingPlace: parkingSpace,
        startTime: startTime,
        endTime: endTime,
      ));
      print('Ny parkering skapad.');
    } else {
      print('Ogiltiga inmatningar, försök igen.');
    }
  }

  void listAllParkings() {
    var parkings = parkingRepo.getAll();
    if (parkings.isNotEmpty) {
      print('Alla parkeringar:');
      parkings.forEach((p) => print(p));
    } else {
      print('Inga parkeringar tillgängliga.');
    }
  }

  void updateParking() {
    stdout.write('Ange registreringsnummer på fordonet för den parkering du vill uppdatera: ');
    int? regNumber = int.tryParse(stdin.readLineSync()!);
    var parking = parkingRepo.getById(regNumber!);
    if (parking != null) {
      stdout.write('Ange ny sluttid (yyyy-mm-dd hh:mm) (aktuell sluttid: ${parking.endTime}): ');
      DateTime? newEndTime = DateTime.tryParse(stdin.readLineSync()!);
      if (newEndTime != null) {
        parking.endTime = newEndTime;
        parkingRepo.update(parking);
        print('Parkering uppdaterad.');
      } else {
        print('Ogiltig inmatning.');
      }
    } else {
      print('Parkeringen hittades inte.');
    }
  }

  void deleteParking() {
    stdout.write('Ange registreringsnummer på fordonet för den parkering du vill ta bort: ');
    int? regNumber = int.tryParse(stdin.readLineSync()!);
    if (parkingRepo.getById(regNumber!) != null) {
      parkingRepo.delete(regNumber);
      print('Parkering borttagen.');
    } else {
      print('Parkeringen hittades inte.');
    }
  }
}