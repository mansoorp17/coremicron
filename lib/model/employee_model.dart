import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel{
  String? name;
  int? phone;
  DateTime? createdTime;
  String? id;
  DocumentReference? reference;
  bool? delete;
  int? attendance;
  List? search;

  EmployeeModel({
    this.name,
    this.phone,
    this.createdTime,
    this.id,
    this.reference,
    this.delete,
    this.attendance,
    this.search,
  });

  EmployeeModel copyWith({
    String? name,
    int? phone,
    DateTime? createdTime,
    String? id,
    DocumentReference? reference,
    bool? delete,
    int? attendance,
    List? search,
  }) {
    return EmployeeModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      createdTime: createdTime ?? this.createdTime,
      id: id ?? this.id,
      reference: reference ?? this.reference,
      delete: delete ?? this.delete,
      attendance: attendance ?? this.attendance,
        search:search ?? this.search,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'phone': this.phone,
      'createdTime': this.createdTime,
      'id': this.id,
      'reference': this.reference,
      'delete': this.delete,
      'attendance': this.attendance,
      'search': this.search,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      name: map['name'] as String,
      phone: map['phone'] as int,
      createdTime: map['createdTime'].toDate(),
      id: map['id'] as String,
      reference: map['reference'] as DocumentReference,
      delete: map['delete'] as bool,
      attendance: map['attendance'] as int,
      search: map['search'] as List,
    );
  }
}