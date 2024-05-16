import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coremicron/common/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import '../../common/failure.dart';
import '../../common/type_defs.dart';
import '../../constants/firebase_constants.dart';
import '../../model/employee_model.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(firestore: FirebaseFirestore.instance);
});

class HomeRepository {
  final FirebaseFirestore _firestore;
  HomeRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _settings =>
      _firestore.collection(FirebaseConstants.settingsCollection);
  CollectionReference get _employees =>
      _firestore.collection(FirebaseConstants.employeeCollection);

  FutureVoid addEmployee({
    required String name,
    required int phone,
  }) async {
    try {
      String docName = await getUsersCount();
      DocumentReference reference = _employees.doc(docName);
      EmployeeModel employeeModel = EmployeeModel(
          name: name,
          reference: reference,
          phone: phone,
          attendance: 0,
          createdTime: DateTime.now(),
          delete: false,
          id: reference.id,
          search: setSearchParam(name));

      var data = await FirebaseFirestore.instance
          .collection(FirebaseConstants.settingsCollection)
          .doc("settings")
          .get();

      List duplicate = data.get("month");
      var currentMonth =
          DateFormat("MMMM y").format(employeeModel!.createdTime!);
      if (duplicate.contains(currentMonth)) {
        print(duplicate);
      } else {
        duplicate.add(currentMonth);
      }
      _settings.doc('settings').update({"month": duplicate});

      return right(reference.set(employeeModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<String> getUsersCount() async {
    var userId = await _settings.doc("settings").get();
    await userId.reference.update({
      "employees": FieldValue.increment(1),
    });
    return "U${userId.get("employees")}";
  }

  Future getMonth() async {
    var data = await _settings.doc("settings").get();
    return data.get("month");
  }

  Stream<List<EmployeeModel>> getEmployee() {
    return _employees
        .where("delete", isEqualTo: false)
        .orderBy("createdTime", descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => EmployeeModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<EmployeeModel>> getEmployeesByMonth(DateTime date) {
    DateTime newDate=DateTime(date.year, date.month+1,1,23,59,59);
    newDate=newDate.subtract(Duration(days: 1));
    return _employees
        .where("delete", isEqualTo: false)
        .where("createdTime", isGreaterThanOrEqualTo: DateTime(date.year,date.month,1,0,0,0))
        .where("createdTime",
        isLessThanOrEqualTo:newDate)
        .snapshots()
        .map((event) => event.docs
        .map((e) => EmployeeModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  FutureVoid deleteEmployee({required String id}) async {
    try {
      DocumentReference reference = _employees.doc(id);
      return right(reference.update({
        "delete": true,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid editEmployee(
      {required String id, required EmployeeModel employeeModel}) async {
    try {
      DocumentReference reference = _employees.doc(id);
      return right(reference.update(employeeModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
