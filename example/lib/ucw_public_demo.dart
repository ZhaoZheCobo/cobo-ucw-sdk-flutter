import 'package:flutter/material.dart';
// import 'package:ucw_sdk/type.dart';
import 'package:ucw_sdk/ucw_sdk.dart';

class UCWPublicDemo extends StatefulWidget {
  const UCWPublicDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UCWPublicDemoState createState() => _UCWPublicDemoState();
}

class _UCWPublicDemoState extends State<UCWPublicDemo> {
  final TextEditingController _displayController = TextEditingController();

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  Future<void> _executeMethods() async {
    final doUCWPublic = DoUCWPublic();
    String result = await doUCWPublic.doMethods();
    setState(() {
      _displayController.text = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UCW Public Demo'),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _executeMethods,
              child: const Text('test UCW Public methods'),
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

String secretsFile = '~/ucw_sdk_flutter_plugin/secrets.db';
late UCWPublic instanceUCWPublic;

class DoUCWPublic {

  Future<String> doMethods() async {
    String resultStr = '';
    resultStr += await doOpenPublic();
    resultStr += await doGetTSSNodeID();
    resultStr += await doGetTSSKeyShareGroups();
    resultStr += await doListTSSKeyShareGroups();
    instanceUCWPublic.dispose();
    return resultStr;
  }

  Future<String> doOpenPublic() async {
    String resultStr = '';
    try {
      resultStr += 'Do openPublic\n';
      instanceUCWPublic = UCWPublic(secretsFile: secretsFile); 
      await instanceUCWPublic.init();
      return resultStr;
    } catch (e) {
      resultStr += 'Failed to openPublic: $e\n';
      return resultStr;
    }
  }

  Future<String> doGetTSSNodeID() async {
    String resultStr = '';
    try {
      resultStr += 'Do getTSSNodeID\n';
      final tssNodeID = await instanceUCWPublic.getTSSNodeID();
      resultStr += 'TSS Node ID: $tssNodeID\n';
      return resultStr;
    } catch (e) {
      resultStr += 'Failed to getTSSNodeID: $e\n';
      return resultStr;
    }
  }

  Future<String> doGetTSSKeyShareGroups() async {
    String resultStr = '';
    try {
      resultStr += 'Do getTSSKeyShareGroups\n';
      final groups = await instanceUCWPublic.getTSSKeyShareGroups(['mockID']);
      resultStr += 'TSS Key Share Groups: ${groups.length}\n';
      for (var group in groups) {
        resultStr += 'Group ID: ${group.tssKeyShareGroupID}, Name: ${group.rootPubKey}\n';
      }
      return resultStr;
    } catch (e) {
      resultStr += 'Failed to getTSSKeyShareGroups: $e\n';
      return resultStr;
    }
  }

  Future<String> doListTSSKeyShareGroups() async {
    String resultStr = '';
    try {
      resultStr += 'Do listTSSKeyShareGroups\n';
      final groups = await instanceUCWPublic.listTSSKeyShareGroups();
      resultStr += 'TSS Key Share Groups (list): ${groups.length}\n';
      for (var group in groups) {
        resultStr += 'Group ID: ${group.tssKeyShareGroupID}, Name: ${group.rootPubKey}\n';
      }
      return resultStr;
    } catch (e) {
      resultStr += 'Failed to listTSSKeyShareGroups: $e\n';
      return resultStr;
    }
  }

  Future<void> dispose() async {
    instanceUCWPublic.dispose();
  }
}
