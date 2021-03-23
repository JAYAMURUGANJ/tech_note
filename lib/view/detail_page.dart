import 'package:flutter/material.dart';

class NoteDetails extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final String? id;
  final String? imgUrl;

  NoteDetails({this.title, this.subtitle, this.id, this.imgUrl});
  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.all(0.8),
              stretchModes: <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              background: Image.network(
                widget.imgUrl.toString(),
                width: 120,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
              delegate:
                  SliverChildListDelegate([Text(widget.title.toString())]))
        ],
      ),
    );
  }
}
