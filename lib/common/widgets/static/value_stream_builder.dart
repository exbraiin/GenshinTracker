import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';

class ValueStreamBuilder<T> extends StreamBuilder<T> {
  ValueStreamBuilder({
    super.key,
    ValueStream<T>? stream,
    required super.builder,
  }) : super(
          stream: stream?.skip(1),
          initialData: stream?.valueOrNull,
        );
}
