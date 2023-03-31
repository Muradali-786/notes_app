import 'package:data_base/Models/notes.dart';
import 'package:data_base/View/db_Helper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper=DBHelper();
    loadData();
  }

  loadData(){
    notesList=dbHelper!.getNotesList();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("NOTES APP"),
      )
      ,body:Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: notesList,
              builder: (context,AsyncSnapshot<List<NotesModel>>snapshot){

            if(snapshot.hasData){
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        dbHelper!.update(
                          NotesModel(
                              id: snapshot.data![index].id!,
                              title:'Updated',
                              age: 20,
                              description: 'after the updation the following result is shown',
                              email: 'khan'
                          )
                        );
                        setState(() {
                          notesList=dbHelper!.getNotesList();
                        });

                      },
                      child: Dismissible(
                        direction: DismissDirection.endToStart,
                        onDismissed: (DismissDirection direction){
                         setState(() {
                           dbHelper!.delete(snapshot.data![index].id!);
                           notesList=dbHelper!.getNotesList();
                           snapshot.data!.remove(snapshot.data![index]);
                         });

                        },
                        key: ValueKey<int>(snapshot.data![index].id!),
                        background: Container(
                          color: Colors.red,
                          child: Icon(Icons.delete_forever),
                        ),

                        child: Card(
                            child: ListTile(
                              // contentPadding: EdgeInsets.all(0),
                              title: Text(snapshot.data![index].title.toString()),
                              subtitle: Text(snapshot.data![index].description.toString()),
                              trailing: Text(snapshot.data![index].age.toString()),
                            )

                        ),

                      ),
                    );

                  });
            }else{
              return CircularProgressIndicator();

            }

          }),
        ),


      ],
    ),floatingActionButton: FloatingActionButton(
      onPressed: (){
       dbHelper!.insert(
        NotesModel(title: 'Second notes',
            age: 19,
            description: 'hey i am learning the sqflite',
            email: 'swatikhan@gmail.com'
        )
       ).then((value){
         print('value is added');
         setState((){
           notesList=dbHelper!.getNotesList();
         });

       }).onError((error, stackTrace){

         print(error.toString());
       });


      },
      child: Icon(Icons.add),
    ),
    );
  }
}
