import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/textEditor': (context) => TextEditor(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _navigateToTextEditor() {
    Navigator.pushNamed(context, '/textEditor');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToTextEditor,
              child: const Text('Go to Text Editor'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TextEditor extends StatefulWidget {
  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  TextEditingController _controller = TextEditingController();
  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;

  void _connectToDevice() async {
    FlutterBlue flutterBlue = FlutterBlue.instance;

    // Scan for devices
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    var scanSubscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.name == "Your Laptop Bluetooth Name") {
          flutterBlue.stopScan();
          setState(() {
            _device = r.device;
          });
          _device!.connect();
          _discoverServices();
          break;
        }
      }
    });

    await scanSubscription.asFuture();
  }

  void _discoverServices() async {
    if (_device != null) {
      var services = await _device!.discoverServices();
      services.forEach((service) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == "your-characteristic-uuid") {
            setState(() {
              _characteristic = characteristic;
            });
          }
        });
      });
    }
  }

  void _sendText() async {
    String text = _controller.text;
    if (_characteristic != null) {
      await _characteristic!.write(text.codeUnits);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Editor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(hintText: 'Enter text here'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendText,
              child: const Text('Send to Laptop'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _connectToDevice,
              child: const Text('Connect to Laptop'),
            ),
          ],
        ),
      ),
    );
  }
}
