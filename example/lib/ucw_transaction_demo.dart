import 'package:flutter/material.dart';
import 'package:ucw_sdk/ucw_sdk.dart';
import 'package:ucw_sdk/data.dart';
import 'secrets_path.dart';
import 'ucw_demo.dart';

class UCWTransactionDemo extends StatefulWidget {
  const UCWTransactionDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UCWTransactionDemoState createState() => _UCWTransactionDemoState();
}

class _UCWTransactionDemoState extends State<UCWTransactionDemo> {
  final TextEditingController _outputController = TextEditingController();
  final TextEditingController _transactionIdController =
      TextEditingController();

  @override
  void dispose() {
    _outputController.dispose();
    _transactionIdController.dispose();
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
          print('UCW Transaction -> Conn Code: $connCode, Message: $message');
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

  Future<void> _listPendingTransactions() async {
    _appendOutput('--- listPendingTransactions ---\n');
    try {
      if (instanceUCW == null) {
        _appendOutput('instanceUCW not initialized\n');
        return;
      }
      List<Transaction> transactions =
          await instanceUCW!.listPendingTransactions();
      _appendOutput('Pending transactions: ${transactions.length}\n');
      for (var tx in transactions) {
        _appendOutput('  ID: ${tx.transactionID}, Status: ${tx.status}\n');
        for (var result in tx.results ?? []) {
          _appendOutput(
              '  signatureType: ${result.signatureType}, tssProtocol: ${result.tssProtocol}\n');
          for (var sig in result.signatures ?? []) {
            _appendOutput(
                '  bip32Path: ${sig.bip32Path}, msgHash: ${sig.msgHash}\n');
          }
        }
        for (var reason in tx.failedReasons ?? []) {
          _appendOutput('  failedReason: $reason\n');
        }
        for (var signDetail in tx.signDetails ?? []) {
          _appendOutput(
              '  signatureType: ${signDetail.signatureType}, tssProtocol: ${signDetail.tssProtocol}\n');
          _appendOutput(
              '  bip32PathList: ${signDetail.bip32PathList}, msgHashList: ${signDetail.msgHashList}\n');
        }
      }
    } catch (e) {
      _appendOutput('Failed to list pending transactions: $e\n');
    }
  }

  Future<void> _approveTransaction() async {
    final id = _transactionIdController.text.trim();
    if (id.isEmpty) {
      _appendOutput('Please enter a Transaction ID\n');
      return;
    }
    _appendOutput('--- approveTransaction ($id) ---\n');
    try {
      if (instanceUCW == null) {
        _appendOutput('instanceUCW not initialized\n');
        return;
      }
      await instanceUCW!.approveTransactions([id]);
      _appendOutput('Successfully approved transaction: $id\n');
    } catch (e) {
      _appendOutput('Failed to approve transaction: $e\n');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UCW Transaction'),
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
              onPressed: _listPendingTransactions,
              child: const Text('listPendingTransactions'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _transactionIdController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Transaction ID',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _approveTransaction,
                  child: const Text('approveTransaction'),
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
