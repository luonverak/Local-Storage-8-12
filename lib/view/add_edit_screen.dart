import 'dart:math';

import 'package:flutter/material.dart';
import 'package:local_storagee/controller/note_controller.dart';
import 'package:local_storagee/model/note_model.dart';
import 'package:local_storagee/view/home_screen.dart';

import '../widget/colors.dart';
import '../widget/input_field.dart';

class AddAndEditScreen extends StatefulWidget {
  AddAndEditScreen({super.key, this.noteModel});
  NoteModel? noteModel;
  @override
  State<AddAndEditScreen> createState() => _AddAndEditScreenState();
}

class _AddAndEditScreenState extends State<AddAndEditScreen> {
  var title = TextEditingController();
  var description = TextEditingController();
  var date = DateTime.now();
  update() async {
    title.text = widget.noteModel!.title;
    description.text = widget.noteModel!.description;
  }

  @override
  void initState() {
    widget.noteModel != null ? update() : Text('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          (widget.noteModel == null) ? 'Add note' : 'Edit note',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              (widget.noteModel == null)
                  ? await NoteController().insertData(
                      NoteModel(
                        id: Random().nextInt(1000),
                        title: title.text,
                        description: description.text,
                        date:
                            '${date.year}-${date.month}-${date.day}', // 2023-12-18
                      ),
                    )
                  : await NoteController()
                      .updateData(
                        NoteModel(
                          id: widget.noteModel!.id,
                          title: title.text,
                          description: description.text,
                          date:
                              '${date.year}-${date.month}-${date.day}', // 2023-12-18
                        ),
                      )
                      .whenComplete(
                        () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (route) => false),
                      );
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InputField(
              controller: title,
              hintText: 'Note title',
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              controller: description,
              hintText: 'Note decription',
              maxLines: 10,
            ),
          ],
        ),
      ),
    );
  }
}
