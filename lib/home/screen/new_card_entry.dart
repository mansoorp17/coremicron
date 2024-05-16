import 'package:coremicron/common/error_text.dart';
import 'package:coremicron/common/loader.dart';
import 'package:coremicron/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

class NewCard extends ConsumerStatefulWidget {
  const NewCard({super.key});

  @override
  ConsumerState<NewCard> createState() => _NewCardState();
}

class _NewCardState extends ConsumerState<NewCard> {
  var selectedItem;
  DateTime dateTime = DateTime.now();
  bool search = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ref.watch(getMonthsProvider).when(
                data: (data) {
                  print(data);
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            height: width * 0.16,
                            width: width * 0.5,
                            child: DropdownButtonFormField(
                              icon: Icon(Icons.arrow_drop_down_sharp),
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius:
                                          BorderRadius.circular(width * 0.02)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius:
                                          BorderRadius.circular(width * 0.02)),
                                  hintText: "Choose Month"),
                              items: List.generate(
                                data.length,
                                (index) => DropdownMenuItem(
                                  child: Text(data[index]),
                                  value: data[index],
                                ),
                              ),
                              onChanged: (value) {
                                selectedItem = value;
                                DateFormat date = DateFormat("MMMM yyyy");
                                dateTime = date.parse(selectedItem);
                              },
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          search = true;
                          setState(() {});
                        },
                        child: Container(
                          height: width * 0.1,
                          width: width * 0.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width * 0.02),
                              color: Color(0xff022E44)),
                          child: Center(
                            child: Text(
                              "Search",
                              style: TextStyle(
                                  color: Colors.white, fontSize: width * 0.04),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => Loader(),
              ),
          search == true
              ? Consumer(
                  builder: (context, ref, child) {
                    print("datetime --$dateTime");
                    return ref.watch(searchProvider(dateTime)).when(
                          data: (data) {
                            return data.isEmpty
                                ? Text("Data Not Found")
                                : ListView.separated(
                                    itemBuilder: (context, index) => ListTile(
                                      tileColor: Colors.blueGrey,
                                      leading: Text(
                                        "${index + 1}",
                                        style:
                                            TextStyle(fontSize: width * 0.04),
                                      ),
                                      subtitle: Text(
                                          "Phone No: ${data[index].phone}"),
                                      title: Text(data[index].name.toString()),
                                      style: ListTileStyle.list,
                                    ),
                                    separatorBuilder: (context, index) =>
                                        const Divider(),
                                    itemCount: data.length,
                                    shrinkWrap: true,
                                  );
                          },
                          error: (error, stackTrace) {
                            print(error.toString());
                            return ErrorText(error: error.toString());
                          },
                          loading: () => const Loader(),
                        );
                  },
                )
              : Text("No data Found")
        ],
      ),
    );
  }
}
