import 'package:collection/collection.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:taskellate/Todo%20App/addtask.dart';
import 'package:taskellate/Todo%20App/sql_function.dart';

void main() {
  runApp(MaterialApp(
    home: Taskellate(),
    debugShowCheckedModeBanner: false,
  ));
}

class Taskellate extends StatefulWidget {
  const Taskellate({super.key});

  @override
  State<Taskellate> createState() => _TaskellateState();
}

class _TaskellateState extends State<Taskellate> {
  List<Map<String, dynamic>> todo = [];
  @override
  void initState() {
    getAlltask();
    super.initState();
  }

  void getAlltask() async {
    var tasks = await SQL_function.fetchalltask();

    setState(() {
      todo = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    var title_ctrl = TextEditingController();
    var content_ctrl = TextEditingController();
    var datetime_ctrl = TextEditingController();
    final format = DateFormat.yMd().add_jm();

    void edittask(int id, String title, String content, String date) {
      setState(() {
        title_ctrl.text = title;
        content_ctrl.text = content;
        datetime_ctrl.text = date;
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Edit',
                style: GoogleFonts.lemon(),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: title_ctrl,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: content_ctrl,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(labelText: 'Content'),
                  ),
                  DateTimeField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.alarm_add),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
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
                                initialDate: currentValue ?? DateTime.now())
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
                  ElevatedButton(
                      onPressed: () async {
                        await SQL_function.updatetask(
                            id,
                            title_ctrl.text,
                            content_ctrl.text,
                            DateFormat.yMd()
                                .add_jm()
                                .parse(datetime_ctrl.text));
                        Navigator.of(context).pop();
                        getAlltask();
                      },
                      child: Text(
                        'Update',
                        style: GoogleFonts.lemon(),
                      ))
                ],
              ),
            );
          });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        elevation: 20,
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                  image: NetworkImage(
                                      "https://images.unsplash.com/photo-1571512599285-9ac4fdf3dba9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8M3wyMzExNjAyfHxlbnwwfHx8fHw%3D"),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.settings,
                            color: Colors.black,
                            size: 25,
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Hey! ',
                        style: GoogleFonts.lemon(
                            textStyle: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                    TextSpan(
                        text: 'Mike',
                        style: GoogleFonts.lemon(
                            textStyle: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color:
                                    const Color.fromARGB(255, 126, 126, 126))))
                  ]),
                ),
                Text(
                  'Waana Do Something?',
                  style: GoogleFonts.lemon(
                      textStyle: TextStyle(fontSize: 14, color: Colors.black)),
                ),
                SizedBox(
                  height: 60,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(todo.length, (index) {
                      DateTime date = DateTime.fromMillisecondsSinceEpoch(
                          todo[index]['datetime']);
                      var formateddate = DateFormat.yMd().add_jm().format(date);
                      var textcolor =
                          (index % 2 == 0) ? Colors.black : Colors.white;
                      if (todo.isNotEmpty) {
                        return InkWell(
                          child: Card(
                            elevation: 15,
                            margin: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            color: (index % 2 == 0)
                                ? Colors.white
                                : Color.fromARGB(255, 0, 1, 37),
                            surfaceTintColor: Colors.transparent,
                            child: Container(
                              width: 250,
                              height: 300,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Text(
                                        todo[index]["title"],
                                        style: GoogleFonts.lemon(
                                            color: textcolor, fontSize: 17),
                                      ),
                                    ),
                                    Text(
                                      todo[index]["content"],
                                      style: GoogleFonts.lemon(
                                          color: textcolor, fontSize: 12),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        formateddate,
                                        style: GoogleFonts.lemon(
                                            color: textcolor, fontSize: 11),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onLongPress: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        child: ListTile(
                                          leading: Icon(Icons.edit),
                                          title: Text('Edit'),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          edittask(
                                              todo[index]["id"],
                                              todo[index]["title"],
                                              todo[index]["content"],
                                              formateddate);
                                        },
                                      ),
                                      InkWell(
                                        child: ListTile(
                                          leading: Icon(Icons.delete),
                                          title: Text('Delete'),
                                        ),
                                        onTap: () {
                                          deletetask(
                                              todo[index]["id"], context);
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                        );
                      } else {
                        return Card(
                          elevation: 15,
                          margin: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: Colors.white,
                          surfaceTintColor: Colors.transparent,
                          child: Container(
                            height: 300,
                            width: 250,
                            child: Center(
                              child: Text(
                                "Nothing to do",
                                style: GoogleFonts.lemon(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
          bottomBarCenterModel: BottomBarCenterModel(
              centerBackgroundColor: Color.fromARGB(255, 33, 221, 174),
              centerIcon: const FloatingCenterButton(
                  child: Icon(
                Icons.add,
                color: Colors.white,
              )),
              centerIconChild: [
                FloatingCenterButtonChild(
                  child: const Icon(
                    Icons.note_alt_outlined,
                    color: Colors.white,
                  ),
                  onTap: () {},
                ),
                FloatingCenterButtonChild(
                  child: const Icon(
                    Icons.add_task,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Addtask()));
                  },
                )
              ]),
          bottomBar: const [
            BottomBarItem(
              icon: Icon(
                Icons.home_filled,
                color: Colors.black,
              ),
              iconSelected: Icon(
                Icons.home_filled,
                color: Color.fromARGB(255, 33, 221, 174),
              ),
              dotColor: AppColors.white,

              // onTap: (){}
            ),
            BottomBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              iconSelected: Icon(
                Icons.person,
                color: Color.fromARGB(255, 33, 221, 174),
              ),
              dotColor: AppColors.white,

              // onTap: (){}
            )
          ]),
    );
  }

  void deletetask(int id, BuildContext context) async {
    await SQL_function.deletetask(id);
    getAlltask();
    Navigator.of(context).pop();
  }
}
