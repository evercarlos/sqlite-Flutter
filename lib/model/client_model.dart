 class Client {
   int id;
   String name;
   String phone;
  
  Client ({this.id,this.name,this.phone});

  // para insertar los datos en la bd, necesitamos convertirlo en un map
  Map<String,dynamic> toMap()=>{
    "id":id,
    "name":name,
    "phone":phone,
  };
  // para recibir los datos necesitamos pararlo de map a json
  factory Client.fromMap(Map<String,dynamic>json)=>new Client(
    id:json["id"],
    name:json["name"], 
    phone:json["phone"]
    );
 }