import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';

class ValueStreamBuilder<T> extends StreamBuilder<T> {
  ValueStreamBuilder({
    super.key,
    ValueStream<T>? super.stream,
    required super.builder,
  }) : super(
          initialData: stream?.valueOrNull,
        );
}
