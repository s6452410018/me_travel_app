// ignore_for_file: prefer_const_constructors, prefer_is_empty, implementation_imports, unused_import, unnecessary_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:me_travel_app/models/user.dart';
import 'package:me_travel_app/utils/db_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({super.key});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  //ตัวควบคุม TextField
  TextEditingController fullnameCtrl = TextEditingController(text: '');
  TextEditingController emailCtrl = TextEditingController(text: '');
  TextEditingController phoneCtrl = TextEditingController(text: '');
  TextEditingController usernameCtrl = TextEditingController(text: '');
  TextEditingController passwordCtrl = TextEditingController(text: '');

  //แสดงตัวแปรควบคุมการแสดงรหัสผ่าน
  bool passwordShowFlag = true;

  //ตัวแปรอ้างอิงรูปที่มาจาก Gallery/Camera เพื่อใช้แสดงหน้าจอ
  File? imgFile;

  String pictureDir = '';

  //method เปิด gallery
  selectImageFromGallery() async {
    XFile? img = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (img == null) return; //กรณีเปิด Gallery แล้วไม่เลือก ให้ยกเลิก

    //เปลี่ยนชื่อรูป และนำรูปเก็บใน Directory ของ App
    Directory directory = await getApplicationDocumentsDirectory();
    String newFllieDir = directory.path + Uuid().v4();
    pictureDir = newFllieDir;

    //แสดงรูปที่หน้าจอ
    File imgFileNew = File(newFllieDir);
    await imgFileNew.writeAsBytes(File(img.path).readAsBytesSync());
    setState(() {
      imgFile = imgFileNew;
    });
  }

  //method เปิด Camera
  selectImageFromCamera() async {
    XFile? img = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (img == null) return; //กรณีเปิด Camera แล้วไม่ถ่าย ให้ยกเลิก

    //เปลี่ยนชื่อรูป และนำรูปเก็บใน Directory ของ App
    Directory directory = await getApplicationDocumentsDirectory();
    String newFllieDir = directory.path + Uuid().v4();
    pictureDir = newFllieDir;

    //แสดงรูปที่หน้าจอ
    File imgFileNew = File(newFllieDir);
    await imgFileNew.writeAsBytes(File(img.path).readAsBytesSync());
    setState(() {
      imgFile = imgFileNew;
    });
  }

  //Method แสดง Dialog เป็นข้อความเตือน
  showWarningDialog(BuildContext context, String msg) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'คำเตื่อน',
              style: GoogleFonts.kanit(),
            ),
            content: Text(
              msg,
              style: GoogleFonts.kanit(),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.kanit(),
                ),
              ),
            ],
          );
        });
  }

  //Method แสดง Dialog เป็นข้อความเมื่อทำงานเสร็จ
  Future showCompleteDialog(BuildContext context, String msg) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'ผลการทำงาน',
              style: GoogleFonts.kanit(),
            ),
            content: Text(
              msg,
              style: GoogleFonts.kanit(),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.kanit(),
                ),
              ),
            ],
          );
        });
  }

  //Method บันทีกข้อมูล User
  saveUserToDB(context) async {
    int id = await DBhelper.createUser(
      User(
        fullname: fullnameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        username: usernameCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
        picture: pictureDir,
      ),
    );

    if (id != 0) {
      showCompleteDialog(context, 'บันทึกข้อมูลเสร็จเรียบร้อย').then((value) {
        Navigator.pop(context);
      });
    } else {
      showCompleteDialog(context, 'มีข้อผิดพลาดเกิดขึ้นในการบันทึกข้อมูล');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'ลงทะเบียนเข้าใช้งาน',
          style: GoogleFonts.kanit(),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                imgFile == Null
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
                          imgFile!,
                        ),
                      ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              onTap: () {
                                selectImageFromCamera();
                                Navigator.pop(context);
                              },
                              leading: Icon(FontAwesomeIcons.camera),
                              title: Text(
                                'ถ่ายรูป',
                                style: GoogleFonts.kanit(),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              onTap: () {
                                selectImageFromGallery();
                                Navigator.pop(context);
                              },
                              leading: Icon(Icons.camera),
                              title: Text(
                                'เลือกรูป',
                                style: GoogleFonts.kanit(),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    FontAwesomeIcons.cameraRetro,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15,
              ),
              child: TextField(
                controller: fullnameCtrl,
                style: GoogleFonts.kanit(),
                decoration: InputDecoration(
                  labelText: 'ชื่อ-สกุล',
                  labelStyle: GoogleFonts.kanit(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'ป้อนชื่อและนามสกุล',
                  hintStyle: GoogleFonts.kanit(
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15,
                bottom: MediaQuery.of(context).size.width * 0.05,
              ),
              child: TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.kanit(),
                decoration: InputDecoration(
                  labelText: 'อีเมล',
                  labelStyle: GoogleFonts.kanit(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'ป้อนอีเมล',
                  hintStyle: GoogleFonts.kanit(
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15,
                bottom: MediaQuery.of(context).size.width * 0.05,
              ),
              child: TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.kanit(),
                decoration: InputDecoration(
                  labelText: 'เบอร์โทร',
                  labelStyle: GoogleFonts.kanit(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'ป้อนเบอร์โทร',
                  hintStyle: GoogleFonts.kanit(
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15,
                bottom: MediaQuery.of(context).size.width * 0.05,
              ),
              child: TextField(
                controller: usernameCtrl,
                style: GoogleFonts.kanit(),
                decoration: InputDecoration(
                  labelText: 'ชื่อผู้ใช้',
                  labelStyle: GoogleFonts.kanit(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'ป้อนชื่อผู้ใช้',
                  hintStyle: GoogleFonts.kanit(
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15,
                bottom: MediaQuery.of(context).size.width * 0.05,
              ),
              child: TextField(
                controller: passwordCtrl,
                obscureText: passwordShowFlag,
                style: GoogleFonts.kanit(),
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  labelStyle: GoogleFonts.kanit(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'ป้อนรหัสผ่าน',
                  hintStyle: GoogleFonts.kanit(
                    color: Colors.grey[400],
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        if (passwordShowFlag == true) {
                          passwordShowFlag == false;
                        } else {
                          passwordShowFlag == true;
                        }
                      });
                    },
                    icon: Icon(
                      passwordShowFlag == true
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
            ),
            ElevatedButton(
              onPressed: () {
                if (fullnameCtrl.text.trim().length == 0) {
                  showWarningDialog(context, 'ป้อนชื่อ-สกุลด้วย...');
                } else if (emailCtrl.text.trim().length == 0) {
                  showWarningDialog(context, 'ป้อนอีเมลด้วย...');
                } else if (phoneCtrl.text.trim().length == 0) {
                  showWarningDialog(context, 'ป้อนเบอร์โทรด้วย...');
                } else if (usernameCtrl.text.trim().length == 0) {
                  showWarningDialog(context, 'ป้อนชื่อผู้ใช้ด้วย...');
                } else if (passwordCtrl.text.trim().length == 0) {
                  showWarningDialog(context, 'ป้อนรหัสด้วย...');
                } else if (pictureDir.length == 0) {
                  showWarningDialog(context, 'เลือกหรือใส่รูปภาพด้วย...');
                } else {
                  saveUserToDB(context);
                }
              },
              child: Text(
                'ลงทะเบียน',
                style: GoogleFonts.kanit(),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(
                  MediaQuery.of(context).size.width * 0.2,
                  MediaQuery.of(context).size.width * 0.125,
                ),
                backgroundColor: Colors.green,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.15,
            ),
          ],
        ),
      ),
    );
  }
}
