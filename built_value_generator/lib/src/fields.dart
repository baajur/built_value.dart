// Copyright (c) 2017, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:collection';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:built_collection/built_collection.dart';

/// Gets fields, including from interfaces.
///
/// If a field is overriden then just the closest (overriding) field is
/// returned.
BuiltList<FieldElement> collectFields(ClassElement element) {
  final fields = <FieldElement>[];
  // Add fields from this class before interfaces, so they're added to the set
  // first below. Re-added fields from interfaces are ignored.
  fields.addAll(element.fields);

  new Set<InterfaceType>.from(element.interfaces)
    ..addAll(element.mixins)
    ..forEach((interface) => fields.addAll(collectFields(interface.element)));

// Overridden fields have multiple declarations, so deduplicate by adding
// to a set that compares on field name.
  final fieldSet = new LinkedHashSet<FieldElement>(
      equals: (a, b) => a.displayName == b.displayName,
      hashCode: (a) => a.displayName.hashCode);
  fieldSet.addAll(fields);
  return new BuiltList<FieldElement>(fieldSet);
}