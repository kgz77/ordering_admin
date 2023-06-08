import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void fodaPrint(dynamic value) {
  debugPrint(value.toString());
}

int timeNow() {
  return DateTime.now().millisecondsSinceEpoch;
}

DateTime timestampToDateTime(int timestamp) {
  return DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
}

List f = [1, 2, 2, 4];

// 1686006531536
void main() {
  print(timestampToDateTime(1682863779));
  print(DateTime.now());
  print(DateTime.now().difference(timestampToDateTime(1682863779)).inDays);
}
