import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/note_class.dart';

class OpenNote extends StatefulWidget {
  const OpenNote({Key key}) : super(key: key);

  @override
  _OpenNoteState createState() => _OpenNoteState();
}

void updateDataAtIndex(String _title, String _content, int index) {
  try {
    final dataBox = Hive.box<Note>('noteBox');
    final Note note = Note(
      title: _title,
      noteContent: _content,
      timeModified: DateTime.now(),
    );
    dataBox.putAt(index, note);
  } catch (err) {
    print(err.toString());
  }
}

class _OpenNoteState extends State<OpenNote> {
  @override
  Widget build(BuildContext context) {
    var noteData = ModalRoute.of(context).settings.arguments as Map;
    String _title = noteData['_title'];
    String _content = noteData['_content'];
    final index = noteData['index'];
    TextEditingController titleController = TextEditingController(text: _title);
    TextEditingController contentController = TextEditingController(text: _content);
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            updateDataAtIndex(_title, _content, index);
            Navigator.pop(context);
            return false;
          },
          child: ListView(
            padding: EdgeInsets.fromLTRB(10, 12, 10, 0),
            children: [
              // for title
              TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: titleController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: TextStyle(
                      fontSize: 27,
                    ),
                    suffix: IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        updateDataAtIndex(_title, _content, index);
                        Navigator.pop(context);
                      },
                    )
                ),
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff4d5284),
                ),
                onChanged: (value) {
                  _title = value;
                },
              ),
              // for note content
              TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: contentController,
                decoration: InputDecoration(
                  hintText: 'Enter your content',
                  border: InputBorder.none,
                ),
                maxLines: null,
                style: TextStyle(
                  fontSize: 18.5,
                  color: Color(0xff4d5284),
                ),
                onChanged: (value) {
                  _content = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
