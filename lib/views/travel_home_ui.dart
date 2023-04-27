import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:me_travel_app/models/user.dart';
import 'package:me_travel_app/views/travel_record_ui.dart';

class TravelHomeUI extends StatefulWidget {
  User? user;
  TravelHomeUI({super.key, this.user});

  @override
  State<TravelHomeUI> createState() => _TravelHomeUIState();
}

class _TravelHomeUIState extends State<TravelHomeUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'บันทึกการเดินทาง',
          style: GoogleFonts.kanit(),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
            ),
            widget.user!.picture!.length == 0
                ? CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.2,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/travel.png',
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.2,
                    backgroundImage: FileImage(
                      File(widget.user!.picture!),
                    ),
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
            ),
            Text(
              widget.user!.fullname!,
              style: GoogleFonts.kanit(
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
            ),
            Text(
              'เบอร์โทร :' + widget.user!.phone!,
              style: GoogleFonts.kanit(
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //เปิดหน้า TravelRecordUI
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TravelRecordUI(),
            ),
          );
        },
        label: Text(
          'บันทึกการเดินทาง (เพิ่ม)',
          style: GoogleFonts.kanit(),
        ),
        icon: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
