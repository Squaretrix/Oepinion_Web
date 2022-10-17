import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oepinion_web/data/dbhandler.dart';

class SurveyItem extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> data;

  const SurveyItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 2)),
        ],
      ),
      width: 340,
      //height: 150,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data['title'],
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              data['category'],
              style:
                  const TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(data['question']),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
                      await updateSurvey(context, data.id, data['category'],
                          data['title'], data['question']);
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
                    icon: const Icon(Icons.edit)),
                IconButton(
                    onPressed: () async {
                      await confirmDeleteDialog(context, data.id);
                      // DBHandlerService()
                      //     .deleteSurvey(
                      //         document.id);
                    },
                    icon: const Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.red,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

confirmDeleteDialog(BuildContext context, String doc_id) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Abbrechen"),
    onPressed: () {},
  );
  Widget continueButton = TextButton(
    child: const Text("Endgültig Löschen"),
    onPressed: () async {
      DBHandlerService().deleteSurvey(doc_id);
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("AlertDialog"),
    content: const Text(
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
    child: const Text(
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
    child: const Text("Abbrechen", style: TextStyle(color: Colors.grey)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Neue Umfrage erstellen"),
    content: Container(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Kategorie',
              ),
            ),
          ),
          const SizedBox(
            width: 50,
          ),
          Expanded(
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Titel',
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: questionController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: const InputDecoration(
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
    child: const Text(
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
    child: const Text("Abbrechen", style: TextStyle(color: Colors.grey)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Umfrage bearbeiten"),
    content: Container(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Kategorie',
              ),
            ),
          ),
          const SizedBox(
            width: 50,
          ),
          Expanded(
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Titel',
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: questionController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: const InputDecoration(
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
