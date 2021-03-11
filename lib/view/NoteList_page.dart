import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomeText extends StatelessWidget {
  const CustomeText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Search Result',
    );
  }
}

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  Icon customIcon = Icon(Icons.search);
  Widget space = CustomeText();
  bool check = true;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140.0),
        child: Column(
          children: [
            AppBar(
              title: Text("Note"),
              elevation: 0.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: space),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          check ? Icons.search : Icons.clear,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          setState(() {
                            if (check) {
                              check = false;
                              space = Container(
                                  child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Search here',
                                  hintText: 'Search here',
                                ),
                                autofocus: false,
                                //onChanged: searchResult,
                              ));
                            } else {
                              check = true;
                              space = CustomeText();
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.sort_by_alpha),
                        color: Theme.of(context).accentColor,
                        onPressed: () {},
                        // onPressed: () {
                        //   setState(() {
                        //     announcementList =
                        //         announcementList.reversed.toList();
                        //   });
                        // },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        // ignore: deprecated_member_use
        stream: FirebaseFirestore.instance.collection('NoteList').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // ignore: deprecated_member_use
          var note = snapshot.data.docs;
          int length = note.length;
          if (snapshot.data == null && !snapshot.hasData && snapshot.hasError) {
            return CircularProgressIndicator();
          }
          return Stack(
            children: [
              Container(
                width: width,
                height: 250,
                child: Image.network(
                    "https://ouch-cdn.icons8.com/thumb/598/ed13b122-5f70-4132-9255-c08e083dd925.png"),
              ),
              DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  minChildSize: 0.3,
                  maxChildSize: 0.8,
                  builder: (context, animationController) {
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: Container(
                            child: length == 0
                                ? CircularProgressIndicator()
                                : ListView.builder(
                                    itemCount: length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        title: Text(
                                            note.elementAt(index)['title']),
                                        subtitle: Text(
                                            note.elementAt(index)['subtitle']),
                                      );
                                    }),
                          ),
                        )
                      ],
                    );
                  })
            ],
          );
        },
      ),
    );
  }
}
