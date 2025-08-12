import 'package:flutter/material.dart';
import 'package:etl_application/features/home/dashboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// นำเข้า DefaultFirebaseOptions ที่สร้างโดย FlutterFire CLI
import 'firebase_options.dart'; // ไฟล์นี้จะถูกสร้างโดย FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // ใช้ตัวเลือกที่เหมาะสมกับแพลตฟอร์ม
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ETL Sim',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: DashboardScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // วิดเจ็ตนี้เป็นหน้าหลักของแอปพลิเคชันของคุณ เป็น stateful หมายความว่า
  // มีอ็อบเจ็กต์ State (กำหนดไว้ด้านล่าง) ที่มีฟิลด์ซึ่งมีผลต่อการแสดงผล

  // คลาสนี้เป็นการกำหนดค่าของ state โดยจะเก็บค่าต่าง ๆ (ในที่นี้คือ title)
  // ที่ได้รับมาจาก parent (ในที่นี้คือ App widget) และใช้โดยเมธอด build ของ State
  // ฟิลด์ใน Widget subclass จะถูกกำหนดเป็น "final" เสมอ

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // การเรียก setState นี้จะแจ้งให้ Flutter framework ทราบว่ามีการเปลี่ยนแปลงใน State
      // ซึ่งจะทำให้เมธอด build ด้านล่างถูกรันใหม่ เพื่อให้แสดงผลค่าที่อัปเดต
      // ถ้าเปลี่ยนค่า _counter โดยไม่เรียก setState() เมธอด build จะไม่ถูกเรียกใหม่
      // และจะไม่มีอะไรเกิดขึ้นบนหน้าจอ
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // เมธอดนี้จะถูกรันใหม่ทุกครั้งที่เรียก setState เช่นที่ใช้ในเมธอด _incrementCounter ด้านบน
    //
    // Flutter framework ถูกออกแบบมาให้การรัน build method ใหม่ทำได้รวดเร็ว
    // คุณจึงสามารถสร้างวิดเจ็ตใหม่ที่ต้องการอัปเดตได้โดยไม่ต้องเปลี่ยนแปลงวิดเจ็ตแต่ละตัวทีละตัว
    return Scaffold(
      appBar: AppBar(
        // ลองเปลี่ยนสีตรงนี้เป็นสีอื่น (เช่น Colors.amber) แล้วกด hot reload เพื่อดูผลลัพธ์
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // ตรงนี้จะนำค่าจากอ็อบเจ็กต์ MyHomePage ที่ถูกสร้างโดย App.build มาใช้เป็นชื่อใน AppBar
        title: Text(widget.title),
      ),
      body: Center(
        // Center เป็นวิดเจ็ตสำหรับจัดวางตำแหน่งลูกให้อยู่ตรงกลางของ parent
        child: Column(
          // Column ก็เป็นวิดเจ็ตสำหรับจัดวางลูกในแนวตั้ง โดยปกติจะปรับขนาดตัวเองให้พอดีกับลูกในแนวนอน
          // และพยายามสูงเท่ากับ parent
          //
          // Column มี property หลายตัวสำหรับควบคุมขนาดและตำแหน่งลูก เช่นที่นี่ใช้ mainAxisAlignment
          // เพื่อจัดลูกให้อยู่ตรงกลางในแนวตั้ง (main axis คือแนวตั้ง เพราะ Column เป็นแนวตั้ง)
          //
          // ลองใช้ "debug painting" (เลือก "Toggle Debug Paint" ใน IDE หรือกด "p" ใน console)
          // เพื่อดูโครงร่างของแต่ละวิดเจ็ต
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
