import 'package:flutter/material.dart';
import 'package:ucw_sdk/ucw_sdk.dart';

class UCWRecoveryDemo extends StatefulWidget {
  const UCWRecoveryDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UCWRecoveryDemoState createState() => _UCWRecoveryDemoState();
}

class _UCWRecoveryDemoState extends State<UCWRecoveryDemo> {
  final TextEditingController _displayController = TextEditingController();

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  Future<void> _executeMethods() async {
    final doUCWRecovery = DoUCWRecovery();
    String result = await doUCWRecovery.doMethods();
    setState(() {
      _displayController.text = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UCW Recovery Demo'),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _executeMethods,
              child: const Text('test UCW Recovery methods'),
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


class DoUCWRecovery {

  Future<String> doMethods() async {
    String resultStr = '';
   
    return resultStr;
  }

}
