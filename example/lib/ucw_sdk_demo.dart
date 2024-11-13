import 'package:flutter/material.dart';
// import 'package:ucw_sdk/type.dart';
import 'package:ucw_sdk/ucw_sdk.dart';

class UCWSDKDemo extends StatefulWidget {
  const UCWSDKDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UCWSDKDemoState createState() => _UCWSDKDemoState();
}

class _UCWSDKDemoState extends State<UCWSDKDemo> {
  final TextEditingController _displayController = TextEditingController();

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  Future<void> _executeMethods() async {
    final doUCWSDK = DoUCWSDK();
    String result = await doUCWSDK.doMethods();
    setState(() {
      _displayController.text = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UCW SDK Demo'),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _executeMethods,
              child: const Text('test UCWSDK methods'),
            ),
            const SizedBox(height: 20),
            Container(
              height: 500,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(
                controller: _displayController,
                readOnly: true,
                maxLines: null,
                decoration: const InputDecoration.collapsed(hintText: ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoUCWSDK {

   Future<String> doMethods() async {
    String resultStr = '';
    try {
      String database = '~/ucw_sdk_flutter_plugin/secrets.db';
      String passphrase = '1234567890123456';
      resultStr += 'Do initialize secrets\n';
      final result = await initializeSecrets(database, passphrase);
      resultStr += 'TSS Node ID: $result\n';

      return resultStr;
    } catch (e) {
      
      print('Failed to execute UCWSDK methods: $e');

      resultStr +=  'Failed to execute UCWSDK methods: $e';
      return resultStr;
    }
  }
}
