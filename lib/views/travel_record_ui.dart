// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TravelRecordUI extends StatefulWidget {
  const TravelRecordUI({super.key});

  @override
  State<TravelRecordUI> createState() => _TravelRecordUIState();
}

class _TravelRecordUIState extends State<TravelRecordUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'บันทึกการเดินทางของฉัน(เพิ่ม)',
          style: GoogleFonts.kanit(),
        ),
        centerTitle: true,
      ),
    );
  }
}
