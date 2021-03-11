class NoteList {
  final String id, title, subtitle;
  NoteList({this.id, this.title, this.subtitle});

  NoteList.fromMap(Map<String, dynamic> data, String id)
      : title = data['title'],
        subtitle = data['subtitle'],
        id = id;

  toMap() {
    return {'id': id, 'title': title, 'subtitle': subtitle};
  }
}
