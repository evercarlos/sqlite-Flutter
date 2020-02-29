import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqliteflutter/model/client_model.dart';

class ClientDatabaseProvider {
  ClientDatabaseProvider._(); 
  static final ClientDatabaseProvider db= ClientDatabaseProvider._(); 
  Database _database;// INSTACIOMOS LA CLASE
  // Para evitar qu abra varias conexiones una y otra vez podemos usar algo como esto...
  Future<Database> get database async{
    if(_database!=null) return _database;
    _database= await getDatabaseInstance();
    return _database;
  }
  Future<Database> getDatabaseInstance() async{
    Directory directory= await getApplicationDocumentsDirectory();
    String path= join(directory.path,'client.db'); // join es de PATH
    return await openDatabase(path,version: 1,
    onCreate: (Database db, int version) async{
      await db.execute("CREATE TABLE Client("
        "id integer primary key,"
        "name TEXT,"
        "phone TEXT"
        ")");
    });
  }

// query 
//select todos los clientes de la bd
  Future<List<Client>>getAllClients() async{
    final db= await database;
    var response= await db.query("Client");
    List<Client> list= response.map((c)=>Client.fromMap(c)).toList();// MAPEA A JSON TODA LA TABLA
    return list;
  }
//select solo un cliente de la bd
  Future<Client>getClientWithId(int id) async{
    final db= await database;
    var response= await db.query("Client",where: "id=?",whereArgs: [id]);
    return response.isNotEmpty? Client.fromMap(response.first):null;
  }
  // insert
  addClientToDatabase (Client client) async{
    final db= await database;
    var table= await db.rawQuery("SELECT MAX(id)+1 as id FROM Client");// PODEMOS CABMIAR EL NOMBRE DE LA TABLA
    int id =table.first["id"];
    client.id=id;
    var raw= await db.insert(
      "Client", // // PODEMOS CABMIAR EL NOMBRE DE LA TABLA
      client.toMap(), // CON ESTO SE MAPEA Y SE INSERTA TODOS LOS CAMPOS DE LA TABLA // toMap es de client_model.dart
      conflictAlgorithm: ConflictAlgorithm.replace // PARA QUE NO
      );
  }

  // Delete
  // delete client with id
  deteleClientWithId(int id) async{
    final db = await database;
    return  db.delete("Client",where: "id=?",whereArgs: [id]);
  }
    // delete client all
  deteleAllClients() async{
    final db = await database;
    db.delete("Client");
  }

  // Editar
  updateClient(Client client) async{
    final db= await database;
    var response= await db.update(
      "Client",
       client.toMap(),
       where: "id=?",
       whereArgs: [client.id]
       );
    return response;
  }


}