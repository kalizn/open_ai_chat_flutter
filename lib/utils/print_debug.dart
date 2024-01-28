import 'package:flutter/foundation.dart';

class Debugger {
  static const bool trace = true;
  final StackTrace _trace;

  late String fileName;
  late int lineNumber;
  late String? traceLine;

  Debugger(this._trace) {
    _parseTrace();
  }

  void _parseTrace() {
    var traceTarLine = _trace.toString().split("\n")[1];

    /* Search through the string and find the index of the file name by looking for the '.dart' regex */
    var indexOfFileName = traceTarLine.indexOf(RegExp(r'[A-Za-z]+.dart'));
    var fileInfo = traceTarLine.substring(indexOfFileName);
    var listOfInfo = fileInfo.split(":");

    traceLine = (RegExp(r'\((.*?)\)').stringMatch(traceTarLine));

    fileName = listOfInfo[0];
    lineNumber = int.parse(listOfInfo[1]);
  }

  @override
  String toString() {
    if(trace){
      return '$traceLine ';
    }
    return '[$fileName | $lineNumber] ';
  }
}

// @formatter:off
printDebug(Object? e) {
  if (kDebugMode) {
    print('${Debugger(StackTrace.current)}$e');
  }
}