// Copyright (c) 2024 weooh
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter/material.dart';

extension TextScaleExtension on TextScaler {
  Size scaleForSize<T extends Size>(T size) =>
      Size(scale(size.width), scale(size.height));
}
