import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:convert/convert.dart';
import 'package:web3dart_explore/transfer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Transfer(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String privateKey =
      'bf4e306788d660e965c008b84333625f55ad4c351525fe57377b45c277263cba';
  String rpcUrl = 'HTTP://10.0.2.2:7545';
  EtherAmount? balance;

  void _incrementCounter() async {
    // final credentials = EthPrivateKey.fromHex(privateKey);
    // final address = credentials.address;
    // print(address.hexEip55);
    // print(hex.encode(credentials.privateKey));
    // print(credentials.publicKey);

    // var a = await credentials.sign(credentials.privateKey);
    // print(hex.encode(a));

    // print(await client.getBalance(address));

    // start a client we can use to send transactions
    final client = Web3Client(rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = credentials.address;

    // print(address.hexEip55);
    // print(await client.getBalance(address));

    var a = await client.signTransaction(
        credentials,
        Transaction(
          to: EthereumAddress.fromHex(
              '0xF82b9dc37ac4b76274a3826725Ac84344582Dd18'),
          gasPrice: EtherAmount.inWei(BigInt.from(200000)),
          maxGas: 100000,
          value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 3),
        ));

    print(hex.encode(a));

    await client.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(
            '0xD6D82E27AC3a91Aa27b3Cee9a9c316F6eb154abb'),
        gasPrice: EtherAmount.inWei(BigInt.from(200000000000000)),
        maxGas: 100000,
        value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 3),
      ),
    );
    balance = await client.getBalance(address);
    print(BigInt.from(200000000000000));
    print(EtherAmount.fromUnitAndValue(EtherUnit.ether, 3).getInWei +
        BigInt.from(200000000000000));
    await client.dispose();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (balance != null)
              SelectableText(
                balance!.getInWei.toString(),
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
