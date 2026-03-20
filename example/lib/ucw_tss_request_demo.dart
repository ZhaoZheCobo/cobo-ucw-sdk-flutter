import 'package:flutter/material.dart';
import 'package:ucw_sdk/ucw_sdk.dart';
import 'package:ucw_sdk/data.dart';
import 'secrets_path.dart';
import 'ucw_demo.dart';

class UCWTSSRequestDemo extends StatefulWidget {
  const UCWTSSRequestDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UCWTSSRequestDemoState createState() => _UCWTSSRequestDemoState();
}

class _UCWTSSRequestDemoState extends State<UCWTSSRequestDemo> {
  final TextEditingController _outputController = TextEditingController();
  final TextEditingController _tssRequestIdController = TextEditingController();

  @override
  void dispose() {
    _outputController.dispose();
    _tssRequestIdController.dispose();
    super.dispose();
  }

  void _appendOutput(String text) {
    setState(() {
      _outputController.text += text;
    });
  }

  Future<void> _createUCWInstance() async {
    _appendOutput('--- createUCWInstance ---\n');
    try {
      if (instanceUCW != null) {
        _appendOutput('instanceUCW already exists\n');
        return;
      }
      final secretsFile = await getSecretsFilePath();
      final sdkConfig =
          SDKConfig(env: Env.development, debug: true, timeout: 30);
      instanceUCW = await UCW.create(
        secretsFile: secretsFile,
        config: sdkConfig,
        passphrase: passphrase,
        connCallback: (connCode, message) async {
          print('UCW TSS Request -> Conn Code: $connCode, Message: $message');
        },
      );
      _appendOutput('UCW instance created successfully\n');
    } catch (e) {
      _appendOutput('Failed to create UCW instance: $e\n');
    }
  }

  Future<void> _initSecrets() async {
    _appendOutput('--- initSecrets ---\n');
    try {
      await setLogger((level, message) {
        _appendOutput('[Log] Level: $level, Message: $message\n');
      });
      final secretsFile = await getSecretsFilePath();
      final result = await initializeSecrets(secretsFile, passphrase);
      _appendOutput('TSS Node ID: $result\n');
    } catch (e) {
      _appendOutput('Failed to initialize secrets: $e\n');
    }
  }

  Future<void> _listPendingTSSRequests() async {
    _appendOutput('--- listPendingTSSRequests ---\n');
    try {
      if (instanceUCW == null) {
        _appendOutput('instanceUCW not initialized\n');
        return;
      }
      List<TSSRequest> tssRequests =
          await instanceUCW!.listPendingTSSRequests();
      _appendOutput('Pending TSS requests: ${tssRequests.length}\n');
      for (var req in tssRequests) {
        _appendOutput('  ID: ${req.tssRequestID}, Status: ${req.status}\n');
        for (var group in req.results ?? []) {
          _appendOutput(
              '  Group ID: ${group.tssKeyShareGroupID}, rootPubKey: ${group.rootPubKey}, type: ${group.type}\n');
          for (var participant in group.participants ?? []) {
            _appendOutput(
                '  Participant tssNodeID: ${participant.tssNodeID}, shareID: ${participant.shareID}\n');
          }
        }
        for (var reason in req.failedReasons ?? []) {
          _appendOutput('  failedReason: $reason\n');
        }
      }
    } catch (e) {
      _appendOutput('Failed to list pending TSS requests: $e\n');
    }
  }

  Future<void> _approveTSSRequest() async {
    final id = _tssRequestIdController.text.trim();
    if (id.isEmpty) {
      _appendOutput('Please enter a TSS Request ID\n');
      return;
    }
    _appendOutput('--- approveTSSRequest ($id) ---\n');
    try {
      if (instanceUCW == null) {
        _appendOutput('instanceUCW not initialized\n');
        return;
      }
      await instanceUCW!.approveTSSRequests([id]);
      _appendOutput('Successfully approved TSS request: $id\n');
    } catch (e) {
      _appendOutput('Failed to approve TSS request: $e\n');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UCW TSS Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _initSecrets,
              child: const Text('initSecrets'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _createUCWInstance,
              child: const Text('createUCWInstance'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _listPendingTSSRequests,
              child: const Text('listPendingTSSRequests'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tssRequestIdController,
                    decoration: const InputDecoration(
                      hintText: 'Enter TSS Request ID',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _approveTSSRequest,
                  child: const Text('approveTSSRequest'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextField(
                  controller: _outputController,
                  readOnly: true,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Output will appear here...'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
