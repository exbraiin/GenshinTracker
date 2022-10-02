import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';

class ValueStreamBuilder<T> extends StreamBuilder<T> {
  ValueStreamBuilder({
    Key? key,
    ValueStream<T>? stream,
    required AsyncWidgetBuilder<T> builder,
  }) : super(
          key: key,
          stream: stream,
          builder: builder,
          initialData: stream?.valueOrNull,
        );
}
