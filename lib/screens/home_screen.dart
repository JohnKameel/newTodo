import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preference/core/db_sqflite.dart';
import 'package:shared_preference/core/shared_pref_helper.dart';
import 'package:shared_preference/screens/login_screen.dart';
import 'package:shared_preference/widgets/custom_text_form_field.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SqfLiteHelper database = SqfLiteHelper();
  TextEditingController _addNoteController = TextEditingController();
  TextEditingController _addDesController = TextEditingController();
  String username = '';
  List<Map<String, dynamic>> mynotes = [];

  @override
  void initState() {
    super.initState();
    loadUserName();
    getAllNotes();
  }

  SqfLiteHelper sqfLiteHelper = SqfLiteHelper();

  getAllNotes() async {
    final listOfNotes = await database.getAllNotes();

    setState(() {
      mynotes = listOfNotes;
    });
  }

  Future addNote() async {
    print('insert is working');
    await sqfLiteHelper.insertNote(
        _addNoteController.text, _addDesController.text);
    print('Note add');
    getAllNotes();
  }

  Future<void> editNote(int id, String title, String dec) async {
    await sqfLiteHelper.updateNote(id, title, dec);
    getAllNotes();
  }

  Future<void> deleteNote(int id) async {
    await SqfLiteHelper().deleteNote(id);
    getAllNotes();
  }

  loadUserName() {
    String? usernameDB = SharedPrefHelper.getUserName();
    setState(() {
      username = usernameDB ?? '';
    });
  }

  @override
  void dispose() {
    _addNoteController.dispose();
    _addDesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Welcome $username',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 32,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Note'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextFormField(
                      controller: _addNoteController,
                      hintText: 'Title',
                    ),
                    CustomTextFormField(
                      controller: _addDesController,
                      hintText: 'Des',
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await addNote();
                      _addNoteController.clear();
                      _addDesController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Add Note'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addNoteController.clear();
                      _addDesController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: mynotes.isEmpty
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/Animation - 1745883415011.json'),
                    const Text(
                      'Nothing here yet..',
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await SharedPrefHelper.clear();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text('Log out'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: mynotes.length,
              itemBuilder: (context, index) {
                final note = mynotes[index];
                return Slidable(
                  key: Key(note['id'].toString()),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        onPressed: (_) async {
                          await deleteNote(note['id']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Note ${note['title']} deleted",
                              ),
                            ),
                          );
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 2,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        note['title'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        note['dec'],
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black54),
                      ),
                      // update ntoe
                      onLongPress: () {
                        _addNoteController.text = note['title'];
                        _addDesController.text = note['dec'];

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Edit Note'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextFormField(
                                    controller: _addNoteController,
                                    hintText: 'Title',
                                  ),
                                  CustomTextFormField(
                                    controller: _addDesController,
                                    hintText: 'Des',
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    await editNote(
                                      note['id'],
                                      _addNoteController.text,
                                      _addDesController.text,
                                    );
                                    _addNoteController.clear();
                                    _addDesController.clear();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Save'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _addNoteController.clear();
                                    _addDesController.clear();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
