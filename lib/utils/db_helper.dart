//File นี้จำทำงานกับ Database: Sqlite
//ทั้งการสร้าง Database, Table
//ทั้ง ลบ แก้ไข ค้นหา ดู ดึง ข้อมูลจาก Table
// ignore_for_file: prefer_is_empty

import 'package:me_travel_app/models/user.dart';
import 'package:sqflite/sqflite.dart';

class DBhelper {
  static Future<Database> db() async {
    return openDatabase(
      'metravelapp.db',
      version: 1,
      onCreate: (Database database, int version) async {
        await createTable(database);
      },
    );
  }

  static Future<void> createTable(Database database) async {
    await database.execute("""
    CREATE TABLE usertb(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      fullname TEXT,
      email TEXT,
      phone TEXT,
      username TEXT,
      password TEXT,
      picture TEXT,
    )
    """);
  }

  //โค้ดคำสั่ง ลบ แก้ไข ค้นหา ดู ดึง ข้อมูลจาก Table
  static Future<int> createUser(User user) async {
    //ติดต่อ Database
    final db = await DBhelper.db();

    //เพิ่มข้อมูลลง Table ใน Database
    final id = await db.insert(
      'usertb',
      user.toMap(),
    );
    return id;
  }

  //Medtod Sign in
  static Future<User?> signinUser(String? username, String? Password) async {
    //ติดต่อ Database
    final db = await DBhelper.db();
    //เอาข้อมูล username, password ที่ส่งมาไปดูว่ามีในตาราง usertb ไหม
    List<Map<String, dynamic>> result = await db.query(
      'usertb',
      where: 'username = ? AND Password = ?',
      whereArgs: [username, Password],
    );

    //ตรวจสอบผลการดูข้อมูลว่ามีไหม
    if (result.length > 0) {
      return User.fromMap(result[0]);
    } else {
      return null;
    }
  }
}
