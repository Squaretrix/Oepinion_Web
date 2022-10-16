import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'dbhandler.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              createSurvey(context, "", "", "");
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Neue Umfrage'),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alle Umfragen',
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height / 4,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Surveys')

                          //.orderBy('Datum', descending: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Scrollbar(
                          controller: scrollController,
                          child: ListView(
                            shrinkWrap: true,
                            children: snapshot.data!.docs.map((document) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.10),
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                          offset: Offset(0, 2)),
                                    ],
                                  ),
                                  //width: 40,
                                  //height: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          document['title'],
                                          style: TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          document['category'],
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(document['question']),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            /*
                                            IconButton(
                                                onPressed: () {
                                                  // DBHandlerService()
                                                  //     .deleteAppointment(
                                                  //         document.id);
                                                },
                                                icon: Icon(
                                                  Icons.info_outline,
                                                  color: Colors.grey,
                                                )),
                                                */
                                            IconButton(
                                                onPressed: () async {
                                                  await updateSurvey(
                                                      context,
                                                      document.id,
                                                      document['category'],
                                                      document['title'],
                                                      document['question']);
                                                  // go to editappointmentpage with document.id
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute<void>(
                                                  //       builder: (BuildContext
                                                  //               context) =>
                                                  //           EditAppointmentScreen(
                                                  //             docId: document.id,
                                                  //             datum:
                                                  //                 document['Datum'],
                                                  //             kunde: document[
                                                  //                 'Dienstleister'],
                                                  //           )),
                                                  // );
                                                },
                                                icon: Icon(Icons.edit)),
                                            IconButton(
                                                onPressed: () async {
                                                  await confirmDeleteDialog(
                                                      context, document.id);
                                                  // DBHandlerService()
                                                  //     .deleteSurvey(
                                                  //         document.id);
                                                },
                                                icon: Icon(
                                                  Icons.delete_forever_rounded,
                                                  color: Colors.red,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }),
                ),
              ),
            ]),
      ),
    );
  }
}

confirmDeleteDialog(BuildContext context, String doc_id) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Abbrechen"),
    onPressed: () {},
  );
  Widget continueButton = TextButton(
    child: Text("Endgültig Löschen"),
    onPressed: () async {
      DBHandlerService().deleteSurvey(doc_id);
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("AlertDialog"),
    content: Text(
        "Die Umfrage wird entgültig gelöscht und kann nicht mehr hergestellt werden"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

createSurvey(
    BuildContext context, String category, String title, String question) {
  TextEditingController categoryController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  /*
    TextEditingController timeController = TextEditingController();
    TextEditingController anmerkungController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();
    DateTime selectedDate = DateTime.now();
    final dateformat = DateFormat('dd. MMM yyyy');

    _selectTime(BuildContext context) async {
      final TimeOfDay? timeOfDay = await showTimePicker(
          context: context,
          initialTime: selectedTime,
          initialEntryMode: TimePickerEntryMode.dial,
          builder: (context, childWidget) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    Using 24-Hour format
                    alwaysUse24HourFormat: true),
                If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
                child: childWidget!);
          });
      if (timeOfDay != null && timeOfDay != selectedTime) {
        setState(() {
          selectedTime = timeOfDay;
        });
      }
    }

    _selectDate(BuildContext context) async {
      final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2025),
      );
      if (selected != null && selected != selectedDate) {
        setState(() {
          selectedDate = selected;
        });
      }
    }
    */

  // Create button
  Widget okButton = TextButton(
    child: Text(
      "Hochladen",
      style: TextStyle(color: Colors.red),
    ),
    onPressed: () async {
      //DB add
      await DBHandlerService().createSurvey(
        categoryController.text,
        titleController.text,
        questionController.text,
      );

      Navigator.of(context).pop();
    },
  );
  Widget exitButton = TextButton(
    child: Text("Abbrechen", style: TextStyle(color: Colors.grey)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Neue Umfrage erstellen"),
    content: Container(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: 'Kategorie',
              ),
            ),
          ),
          SizedBox(
            width: 50,
          ),
          Expanded(
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Titel',
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: questionController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Frage',
              ),
            ),
          ),
        ],
      ),
    ),
    actions: [
      exitButton,
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

updateSurvey(BuildContext context, String doc_id, String category, String title,
    String question) {
  TextEditingController categoryController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController questionController = TextEditingController();

  categoryController.text = category;
  titleController.text = title;
  questionController.text = question;
  /*
    TextEditingController timeController = TextEditingController();
    TextEditingController anmerkungController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();
    DateTime selectedDate = DateTime.now();
    final dateformat = DateFormat('dd. MMM yyyy');

    _selectTime(BuildContext context) async {
      final TimeOfDay? timeOfDay = await showTimePicker(
          context: context,
          initialTime: selectedTime,
          initialEntryMode: TimePickerEntryMode.dial,
          builder: (context, childWidget) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    Using 24-Hour format
                    alwaysUse24HourFormat: true),
                If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
                child: childWidget!);
          });
      if (timeOfDay != null && timeOfDay != selectedTime) {
        setState(() {
          selectedTime = timeOfDay;
        });
      }
    }

    _selectDate(BuildContext context) async {
      final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2025),
      );
      if (selected != null && selected != selectedDate) {
        setState(() {
          selectedDate = selected;
        });
      }
    }
    */

  // Create button
  Widget okButton = TextButton(
    child: Text(
      "Aktualisieren",
      style: TextStyle(color: Colors.red),
    ),
    onPressed: () async {
      //DB add
      await DBHandlerService().updateSurvey(
        doc_id,
        categoryController.text,
        titleController.text,
        questionController.text,
      );

      Navigator.of(context).pop();
    },
  );
  Widget exitButton = TextButton(
    child: Text("Abbrechen", style: TextStyle(color: Colors.grey)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Umfrage bearbeiten"),
    content: Container(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: 'Kategorie',
              ),
            ),
          ),
          SizedBox(
            width: 50,
          ),
          Expanded(
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Titel',
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: questionController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Frage',
              ),
            ),
          ),
        ],
      ),
    ),
    actions: [
      exitButton,
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
