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

String secretsFile = 'secrets.db';
String newSecretsFile = 'secrets1.db';
String passphrase = '1234567890123456';
String exportPassphrase = 'ABCDEFGHIJKLMNOP';
UCW? instanceUCW;

class DoUCWOthers {

  Future<String> doMethods() async {
    String resultStr = '';
    resultStr += await doGetSDKInfo();
    resultStr += await doInit();
    resultStr += await doExportSecrets();
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
      instanceUCW = await UCW.create(secretsFile: secretsFile, config: sdkConfig, passphrase: passphrase, connCallback:
      (connCode, message) async {
        print('UCW Demo -> Conn Code: $connCode, Message: $message');
      });
      return resultStr;
    } catch (e) {
      resultStr += 'Failed to init: $e\n';
      return resultStr;
    }
  }

  Future<String> doExportSecrets() async {
    String resultStr = '';
    try {
      resultStr += 'Starting export of secrets...\n';

      final exportResult = await instanceUCW?.exportSecrets(exportPassphrase);

      resultStr += 'Secrets exported successfully:\n';
      print('$exportResult\n');

      resultStr += await doImportSecrets(exportResult!, exportPassphrase, newSecretsFile, passphrase);
      return resultStr;
    } catch (e) {
      resultStr += 'Failed to doExportSecrets: $e\n';
      return resultStr;
    }
  }

  Future<String> doImportSecrets(
      String jsonRecoverySecrets,
      String exportPassphrase,
      String newSecretsFile,
      String newPassphrase) async {
    String resultStr = '';
    try {
      resultStr += 'Starting import of secrets...\n';

      final importResult = await importSecrets(
          jsonRecoverySecrets, exportPassphrase, newSecretsFile, newPassphrase);

      resultStr += 'Secrets imported successfully:\n';
      resultStr += 'Imported TSS Node ID: $importResult\n';
      return resultStr;
    } catch (e) {
      resultStr += 'Failed to doImportSecrets: $e\n';
      return resultStr;
    }
  }

}
