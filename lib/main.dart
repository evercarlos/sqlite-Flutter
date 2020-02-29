import 'package:flutter/material.dart';
import 'package:sqliteflutter/add_editclient.dart';
import 'package:sqliteflutter/db/database.dart';
import 'package:sqliteflutter/model/client_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  _MyhomePageState createState()=>_MyhomePageState();

}

class _MyhomePageState extends State<MyHomePage>{
  @override
  void didUpdateWidget(MyHomePage oldWidget){
    super.didUpdateWidget(oldWidget);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text("Flutter Sqlite"),
        actions: <Widget>[
          RaisedButton(
            color:Theme.of(context).primaryColor,
            onPressed: (){
              ClientDatabaseProvider.db.deteleAllClients();
              setState(() {
                
              });
            },
            child: Text("Delete All",
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              color:Colors.black
            ),
            ),
          ),
        ],
      ),
      body: 
      FutureBuilder<List<Client>>(
        future:ClientDatabaseProvider.db.getAllClients(),
        builder: (BuildContext context,AsyncSnapshot<List<Client>> snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount:snapshot.data.length,          
              itemBuilder: (BuildContext context,int index){
                Client item= snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (diretion){
                    ClientDatabaseProvider.db.deteleClientWithId(item.id);
                  },
                  child: ListTile(
                   title: Text(item.name),
                   subtitle: Text(item.phone),
                   leading: CircleAvatar(child: Text(item.id.toString())), 
                   onTap: (){
                     Navigator.of(context).push(MaterialPageRoute(
                       builder: (context)=>AddEditClient(
                         true,
                         client:item
                       )
                     ));
                   },
                  ),
                );
              }
            );
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
        // para crear un nuevo registro
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>AddEditClient(false)));
        },
      ),
    );
  }
}