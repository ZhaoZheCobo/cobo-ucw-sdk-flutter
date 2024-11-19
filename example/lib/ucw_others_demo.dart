import 'package:flutter/material.dart';
import 'package:ucw_sdk/ucw_sdk.dart';
import 'package:ucw_sdk/data.dart';

class UCWOthersDemo extends StatefulWidget {
  const UCWOthersDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UCWOthersDemoState createState() => _UCWOthersDemoState();
}

class _UCWOthersDemoState extends State<UCWOthersDemo> {
  final TextEditingController _displayController = TextEditingController();

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  Future<void> _executeMethods() async {
    final doUCWOthers = DoUCWOthers();
    String result = await doUCWOthers.doMethods();
    setState(() {
      _displayController.text = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UCW Others Demo'),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _executeMethods,
              child: const Text('test UCW Others methods'),
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

//String secretsFile = '~/ucw_sdk_flutter_plugin/secrets.db';
String secretsFile = '/Users/zhaozhe/waas2/ucw_flutter/secrets4.db';
String passphrase = '1234567890123456';
UCW? instanceUCW;

class DoUCWOthers {

  Future<String> doMethods() async {
    String resultStr = '';
    resultStr += await doGetSDKInfo();
    return resultStr;
  }

  Future<String> doGetSDKInfo() async {
    String resultStr = '';
    try {
      resultStr += 'Do getSDKInfo\n';
      final sdkInfo =  await getSDKInfo();
      var version = sdkInfo.version;
      resultStr += 'SDK Info: $version\n';
      return resultStr;
    } catch (e) {
      resultStr += 'Failed to doGetSDKInfo: $e\n';
      return resultStr;
    }
  }

  Future<String> doInit() async {
    String resultStr = '';
    try {
      resultStr += 'Do init\n';
      if (instanceUCW != null) {
        resultStr += 'InstanceUCW exists\n';       
        return resultStr;
      } 

      final sdkConfig = SDKConfig(env: Env.local, debug: true, timeout: 30);
      instanceUCW = UCW(secretsFile: secretsFile, config: sdkConfig);   
      await instanceUCW?.init1(passphrase, (connCode, message) {
        print('UCW Demo -> Conn Code: $connCode, Message: $message');
      });
      return resultStr;
    } catch (e) {
      resultStr += 'Failed to init: $e\n';
      return resultStr;
    }
  }

  
}
