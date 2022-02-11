import 'package:flutter/material.dart';

extension SeparateExt on List<Widget> {
  List<Widget> sepWidget({
    Widget? separate,
  }) {
    if (isEmpty) return [];
    removeWhere((element) {
      if (element.runtimeType == Offstage) {
        return (element as Offstage).offstage;
      }

      if (element.runtimeType == Visibility) {
        return !(element as Visibility).visible;
      }
      return false;
    });
    return List.generate(length * 2 - 1, (index) {
      if (index.isEven) {
        return this[index ~/ 2];
      } else {
        return separate ??
            const SizedBox(
              width: 10,
            );
      }
    });
  }
}
