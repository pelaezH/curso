import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyHomeWorks',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xfff4f4f4),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xfff4f4f4),
        title: Text(
          'MyHomeWorks',
          style: TextStyle(color: Colors.grey, fontSize: 20),
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Image.asset(
                        'images/images7.png',
                        height: 200,
                      ),
                    )),
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.filter_list, color: Colors.grey),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                'My List',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 13,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 50.0),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection('works')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError)
                                  return new Center(
                                      child: Text('Error: ${snapshot.error}'));
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Center(
                                        child: new CircularProgressIndicator());
                                  default:
                                    return new ListView(
                                      children: snapshot.data.documents
                                          .map((DocumentSnapshot document) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              left: 20.0,
                                              right: 20.0,
                                              bottom: 8.0),
                                          child: InkWell(
                                            onTap: () => {
                                              //print(document.documentID),
                                              showModalBottomSheet(
                                                  elevation: alto * 0.8,
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          0, 0, 0, 0),
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (context) {
                                                    return _homeWorkModal(
                                                        context, document);
                                                  }),
                                            },
                                            child: Container(
                                              height: alto * .1,
                                              decoration: BoxDecoration(
                                                  color: Color(0xfff4f4f4),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Icon(
                                                        document['subject'] ==
                                                                "Matematicas"
                                                            ? Icons.functions
                                                            : Icons.attach_file,
                                                        color: Colors.grey,
                                                        size: 40,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: Center(
                                                      child: ListTile(
                                                        title: new Text(
                                                            document['title']),
                                                        subtitle: new Text(
                                                            document[
                                                                'subject']),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  //Navigator.of(context).push(NewHomeWork());
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewHomeWork()),
                  );
                },
                child: Container(
                  height: 50,
                  //color: Colors.purple,}
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff6441a9),
                        Color(0xff634db5),
                      ],
                    ),
                  ),
                  child: Center(
                      child: Text(
                    'Add New',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeWorkModal(BuildContext context, DocumentSnapshot document) {
    final ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height;
    print(document.documentID);
    print(document.data['title']);
    return Container(
      decoration: BoxDecoration(
        color: Color(0xfff4f4f4),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      width: ancho,
      height: alto * 0.4,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              document['subject'] == "Matematicas"
                  ? Icons.functions
                  : Icons.attach_file,
              color: Colors.grey,
              size: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
                child: Text(
              document.data['title'],
              style: TextStyle(
                fontSize: 20,
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(document.data['subject']),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 40.0, bottom: 8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xffffffff)),
                width: ancho,
                height: alto * 0.05,
                child: Center(
                    child: Text(
                  'Volver a la lista',
                  style: TextStyle(color: Colors.grey),
                )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Firestore.instance
                    .collection("works")
                    .document(document.documentID)
                    .delete();
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xffc94b7a)),
                width: ancho,
                height: alto * 0.05,
                child: Center(
                    child: Text(
                  'Tarea Hecha',
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewHomeWork extends StatefulWidget {
  @override
  _NewHomeWorkState createState() => _NewHomeWorkState();
}

class _NewHomeWorkState extends State<NewHomeWork> {
  TextEditingController _tituloController;
  TextEditingController _materiaController;

  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _materiaController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final queryData = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                Text(
                  'Back',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Image.asset('images/images6.png',
                      width: queryData.width * .8),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Add New Homework',
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _tituloController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _materiaController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Subject',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      if (_tituloController.text.isNotEmpty) {
                        if (_materiaController.text.isNotEmpty) {
                          Firestore.instance
                              .collection('works')
                              .document()
                              .setData({
                            'title': _tituloController.text,
                            'subject': _materiaController.text
                          });
                          _materiaController.clear();
                          _tituloController.clear();
                          Navigator.of(context).pop();
                        } else {
                          print('subject vacio');
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Center(
                                      child: Text('Subject field is empty')),
                                  content: Image.asset(
                                    'images/image4.png',
                                    height: 150,
                                  ),
                                );
                              });
                        }
                      } else {
                        print('title vacio');
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title:
                                    Center(child: Text('Title field is empty')),
                                content: Image.asset(
                                  'images/image4.png',
                                  height: 150,
                                ),
                              );
                            });

                        //print('titulo vacio');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff6441a9),
                            Color(0xff634db5),
                          ],
                        ),
                      ),
                      width: queryData.width,
                      height: (queryData.height) * 0.05,
                      child: Center(
                          child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
