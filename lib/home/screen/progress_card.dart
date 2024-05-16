import 'package:coremicron/common/error_text.dart';
import 'package:coremicron/common/loader.dart';
import 'package:coremicron/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../model/employee_model.dart';

class ProgressCard extends ConsumerStatefulWidget {
  const ProgressCard({super.key});

  @override
  ConsumerState<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends ConsumerState<ProgressCard> {
  TextEditingController name_Controller = TextEditingController();
  TextEditingController phoneno_Controller = TextEditingController();
  void editEmployee(
      {required String id, required EmployeeModel employeeModel}) {
    ref
        .read(homeControllerProvider.notifier)
        .editEmployee(id: id, employeeModel: employeeModel, context: context);
  }

  void delete({required String id}) {
    ref
        .read(homeControllerProvider.notifier)
        .deleteEmployee(id: id, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ref.watch(getEmployeeProvider).when(
                data: (data) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      int count = index + 1;
                      return ListTile(
                        tileColor: Colors.blueGrey,
                        leading: Text(
                          count.toString(),
                          style: TextStyle(fontSize: width * 0.05),
                        ),
                        title: Text(
                          data[index].name.toString(),
                          style: TextStyle(fontSize: width * 0.06),
                        ),
                        subtitle: Text(
                          data[index].phone.toString(),
                          style: TextStyle(fontSize: width * 0.04),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  name_Controller.text = data[index].name!;
                                  phoneno_Controller.text =
                                      data[index].phone!.toString();
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text("Edit Employee"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: name_Controller,
                                                  decoration: InputDecoration(
                                                      label: Text(
                                                          'Employee Name')),
                                                ),

                                                TextField(
                                                  controller:
                                                      phoneno_Controller,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLength: 10,
                                                  decoration: InputDecoration(
                                                      label:
                                                          Text('Phone Number')),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: width * 0.04),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      editEmployee(
                                                          id: data[index].id!,
                                                          employeeModel: data[index].copyWith(
                                                              name:
                                                                  name_Controller
                                                                      .text,
                                                              phone: int.parse(
                                                                  phoneno_Controller
                                                                      .text
                                                                      .trim())));
                                                    },
                                                    child: Container(
                                                      height: width * 0.13,
                                                      width: width * 0.4,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      width *
                                                                          0.03)),
                                                      child: Center(
                                                          child: Text(
                                                        "Update",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                width * 0.07),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ));
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: width * 0.08,
                                  color: Colors.blueAccent,
                                )),
                            GestureDetector(
                                onTap: () {
                                  delete(id: data[index].id!);
                                },
                                child: Icon(
                                  Icons.delete,
                                  size: width * 0.08,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                    itemCount: data.length,
                  );
                },
                error: (error, stackTrace) {
                  print(error.toString());
                  return ErrorText(error: error.toString());
                },
                loading: () => Loader(),
              ),
        ],
      ),
    );
  }
}
