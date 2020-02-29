 class Client {
   int id;
   String name;
   String phone;
  
  Client ({this.id,this.name,this.phone});

  // para insertar los datos en la bd, necesitamos convertirlo en un map ...class
  // Convierte en un Map. Las llaves deben corresponder con los nombres de las columnas en la base de datos.
  Map<String,dynamic> toMap()=>{
    "id":id,
    "name":name,
    "phone":phone,
  };
  // para recibir los datos de la bd necesitamos pasarlo de map a json
  factory Client.fromMap(Map<String,dynamic>json)=>new Client(
    id:json["id"],
    name:json["name"], 
    phone:json["phone"]
    );
 }