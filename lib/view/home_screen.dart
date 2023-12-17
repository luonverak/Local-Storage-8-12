import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:local_storagee/controller/note_controller.dart';
import 'package:local_storagee/model/note_model.dart';
import 'package:local_storagee/view/add_edit_screen.dart';
import 'package:local_storagee/widget/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<NoteModel>>? list;
  late NoteController controller;
  refresh() async {
    controller = NoteController();
    setState(() {
      list = controller.getData();
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          'Dating note',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAndEditScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
      body: FutureBuilder<List<NoteModel>>(
        future: list,
        builder: (context, AsyncSnapshot<List<NoteModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Icon(
                Icons.info,
                color: Colors.red,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          borderRadius: BorderRadius.circular(10),
                          onPressed: (context) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddAndEditScreen(noteModel: item),
                              ),
                            );
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          borderRadius: BorderRadius.circular(10),
                          onPressed: (context) async {
                            await NoteController()
                                .deleteData(item.id)
                                .whenComplete(() => refresh());
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Remove',
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                              ),
                              Text(
                                item.description,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                item.date,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
