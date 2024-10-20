import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

part 'src/cupid_bow.dart';

class Poem extends StatefulWidget {
  const Poem({super.key});

  @override
  State<Poem> createState() => _PoemState();
}

class _PoemState extends State<Poem> {
  @override
  Widget build(BuildContext context) {
    return const CupidBow();
  }
}
