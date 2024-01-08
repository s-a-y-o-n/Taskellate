import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskellate/Todo%20App/main.dart';
import 'package:taskellate/Todo%20App/sql_function.dart';

class Addtask extends StatefulWidget {
  const Addtask({super.key});

  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  var datetime_ctrl = TextEditingController();
  var title_c = TextEditingController();
  var content_c = TextEditingController();
  var formkey = GlobalKey<FormState>();
  final format = DateFormat.yMd().add_jm();
  @override
  Widget build(BuildContext context) {
    void addtask(String title, String content, DateTime datetime) async {
      var id = await SQL_function.newtask(title, content, datetime);
      if (id != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (content) => Taskellate()));
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'New ',
                          style: GoogleFonts.lemon(
                              textStyle: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                      TextSpan(
                          text: 'Task',
                          style: GoogleFonts.lemon(
                              textStyle: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(
                                      255, 131, 131, 131)))),
                    ])),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: title_c,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: 'Title',
                        hintStyle: GoogleFonts.lemon(),
                      ),
                      validator: (title) {
                        if (title!.isEmpty) {
                          return "Required field";
                        }
                      },
                    ),
                    TextFormField(
                      controller: content_c,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: 'Content',
                        hintStyle: GoogleFonts.lemon(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 220,
                          child: DateTimeField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.alarm_add),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: 'Set Reminder',
                                hintStyle: GoogleFonts.lemon(),
                              ),
                              controller: datetime_ctrl,
                              format: format,
                              onShowPicker: (context, currentValue) async {
                                return await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2200),
                                        initialDate:
                                            currentValue ?? DateTime.now())
                                    .then((DateTime? date) async {
                                  if (date != null) {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                          currentValue ?? DateTime.now()),
                                    );
                                    return DateTimeField.combine(date, time);
                                  } else {
                                    return currentValue;
                                  }
                                });
                              }),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              var valid = formkey.currentState!.validate();
                              if (valid == true) {
                                addtask(
                                    title_c.text,
                                    content_c.text,
                                    DateFormat.yMd()
                                        .add_jm()
                                        .parse(datetime_ctrl.text));
                              }
                            },
                            child: Text(
                              'Create',
                              style: GoogleFonts.lemon(color: Colors.black),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
