import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqliteflutter/db/database.dart';
import 'package:sqliteflutter/model/client_model.dart';

class AddEditClient extends StatefulWidget {
  final bool edit;
  final Client client;

  AddEditClient(this.edit,{this.client})
  :assert(edit==true || client==null);

  @override
  _AddEditClientState createState() => _AddEditClientState();
}

class _AddEditClientState extends State<AddEditClient> {
 //PARA CAMPTURAR DE LOS INPUT
 TextEditingController nameEditingController = TextEditingController();
 TextEditingController phoneEditingController = TextEditingController();
 final _formKey=GlobalKey<FormState>(); // PARA VALIDACIONES; SI ESTA VACIO, ETC
 //END
 @override
 void initState(){   // PARA QUE CARGUE PRIMERO
   super.initState();
   if(widget.edit==true){
     nameEditingController.text=widget.client.name;
     phoneEditingController.text= widget.client.phone;
   }
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.edit? "Edit Client":"Add Client"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,// CENTRE EL LOGO
              children: <Widget>[
                FlutterLogo(
                  size:300,
                ),
                textFormField(nameEditingController,"name","Enter Name", //PARA HACER VALIDACIONES
                Icons.person,widget.edit ? widget.client.name:"name"), 
               textFormField(phoneEditingController,"Phone","Enter phone", //PARA HACER VALIDACIONES
                Icons.person,widget.edit ? widget.client.phone:"name"), 
                RaisedButton(
                  color: Colors.red,
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text("Save",
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Colors.white
                  ),
                  ),
                  onPressed: () async {
                    if(!_formKey.currentState.validate()){
                      Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Processing Data"),)
                      );
                    }else if(widget.edit==true){
                      ClientDatabaseProvider.db.updateClient(new Client(
                        name:nameEditingController.text,
                        phone: phoneEditingController.text,
                        id:widget.client.id
                        ));
                        Navigator.pop(context);
                    }else{
                      await ClientDatabaseProvider.db.addClientToDatabase(new Client(
                        name:nameEditingController.text,
                        phone: phoneEditingController.text
                      ));
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
          ),
      ),
    );
  }

  textFormField(TextEditingController t, String label, String hint,
   IconData iconData,String initialValue){
     return Padding(
       padding: const EdgeInsets.only(
         top:20
       ),
       child: TextFormField(
         validator: (value){
           if(value.isEmpty){
             return 'Please enter some text';
           }
         },
         controller: t,
         textCapitalization: TextCapitalization.words,
         decoration: InputDecoration(
           prefixIcon: Icon(iconData),
           hintText: label,
           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
         ),
       ),
       );
  }
}