import 'package:coremicron/home/controller/home_controller.dart';
import 'package:coremicron/home/screen/new_card_entry.dart';
import 'package:coremicron/home/screen/progress_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/utils.dart';
import '../../main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectIndex = 0;
  List pages = [
    NewCard(),
    ProgressCard(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3C377E),
        title: Text("CMIS",style: TextStyle(color: Colors.white),),
        actions: [
          GestureDetector(
            onTap: () {
              return _showPopUp(context);
            },
            child: Icon(
              Icons.add,
              size: width * 0.1,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: pages[selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add_outlined),
            label: "New Card",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.note_alt_rounded), label: "Progress Card"),
        ],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: selectIndex,
        onTap: (value) {
          selectIndex = value;
          setState(() {});
        },
      ),
    );
  }
}

void _showPopUp(BuildContext context) {
  TextEditingController empNameController = TextEditingController();
  TextEditingController empNoController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      void addEmployee({required String name,required int phone,required WidgetRef ref}){
        ref.read(homeControllerProvider.notifier)
            .addEmployee(name: name, phone: phone, context: context);
      }
      return AlertDialog(
        title: Text("Add Employee"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: empNameController,
              decoration: InputDecoration(label: Text('Employee Name')),
            ),
            TextField(
              controller: empNoController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: InputDecoration(label: Text('Phone Number')),
            ),
            Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return GestureDetector(
                onTap: () {
                  if (empNameController.text == '' ||
                      empNoController.text == '') {
                    return showSnackBar(context, "Please Fill All Fields");
                  }
                  else{
                    addEmployee(name: empNameController.text.trim(), phone: int.parse(empNoController.text.trim()), ref: ref);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(top: width * 0.04),
                  child: Container(
                    height: width * 0.13,
                    width: width * 0.4,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(width * 0.03)),
                    child: Center(
                        child: Text(
                          "Add",
                          style:
                          TextStyle(color: Colors.white, fontSize: width * 0.07),
                        )),
                  ),
                ),
              );
            },

            )
          ],
        ),
      );
    },
  );
}
