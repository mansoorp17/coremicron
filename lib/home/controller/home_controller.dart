import 'package:coremicron/model/employee_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/utils.dart';
import '../repository/home_repository.dart';

final homeControllerProvider = NotifierProvider<HomeController, bool>(() {
  return HomeController();
});

final getEmployeeProvider = StreamProvider((ref) {
  return ref.read(homeControllerProvider.notifier).getEmployee();
});

final getMonthsProvider = FutureProvider((ref) {
  return ref.read(homeControllerProvider.notifier).getMonth();
});

final searchProvider = StreamProvider.family((ref,DateTime month) {
  return ref.read(homeControllerProvider.notifier).getEmployeesByMonth(month: month);
});

class HomeController extends Notifier<bool> {
  HomeRepository get _homeRepository => ref.read(homeRepositoryProvider);

  void addEmployee({
    required String name,
    required int phone,
    required BuildContext context,
  }) async {
    final res = await ref
        .read(homeRepositoryProvider)
        .addEmployee(phone: phone, name: name);
    res.fold((l) => showSnackBar(context, "Error"), (r) {
      showSnackBar(context, "Employee Added");
      return Navigator.pop(context);
    });
  }

  Future getMonth() {
    return _homeRepository.getMonth();
  }

  Stream<List<EmployeeModel>> getEmployee() {
    return _homeRepository.getEmployee();
  }

  Stream<List<EmployeeModel>> getEmployeesByMonth({required DateTime month}) {
    return _homeRepository.getEmployeesByMonth(month);
    }

  void deleteEmployee({
    required String id,
    required BuildContext context,
  }) async {
    final res = await _homeRepository.deleteEmployee(
      id: id,
    );
    res.fold((l) => showSnackBar(context, "error"), (r) {
      showSnackBar(context, "Employee Deleted");
    });
  }

  void editEmployee({
    required String id,
    required EmployeeModel employeeModel,
    required BuildContext context,
  }) async {
    final res = await _homeRepository.editEmployee(
        id: id, employeeModel: employeeModel);
    res.fold((l) => showSnackBar(context, "error"), (r) {
      Navigator.pop(context);
      showSnackBar(context, "Employee Edited");
    });
  }

  @override
  bool build() {
    return false;
    // TODO: implement build
    throw UnimplementedError();
  }
}
