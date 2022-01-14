import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class Transfer extends StatefulWidget {
  const Transfer({Key? key}) : super(key: key);

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  String rpcUrl = 'HTTP://10.0.2.2:7545';
  EtherAmount? balance;
  TextEditingController privateKey = TextEditingController();
  TextEditingController textAddress = TextEditingController();
  TextEditingController textAmount = TextEditingController();

  Future<void Function()?>? send() async {
    final client = Web3Client(rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(privateKey.text);
    final address = credentials.address;

    await client.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(textAddress.text),
        // gasPrice: EtherAmount.inWei(BigInt.from(200000000000000)),
        gasPrice: null,
        // maxGas: 100000,
        maxGas: null,
        value: EtherAmount.fromUnitAndValue(EtherUnit.ether, textAmount.text),
      ),
    );
    balance = await client.getBalance(address);

    await client.dispose();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ETH Send'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const Text('Your Balance'),
            Text(
              (balance == null ? 0 : balance!.getInEther).toString() + ' ETH',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text('Your Private Key'),
            TextField(
              controller: privateKey,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Send to'),
            TextField(
              controller: textAddress,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Amount (ETH)'),
            TextField(
              controller: textAmount,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: send, child: const Text('Send'))
          ],
        ),
      ),
    );
  }
}
