import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _scanBarcode = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  void _launchURL() async {
    if (!await launch(_scanBarcode)) throw 'Could not launch $_scanBarcode';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Barcode scanner'),
          centerTitle: true,
        ),
        drawer: const Drawer(),
        body: Builder(builder: (BuildContext context) {
          return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            onPressed: () => scanBarcodeNormal(),
                            icon: const Icon(
                              Icons.qr_code_scanner,
                              size: 60,
                            )),
                      ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text('Scan result : ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Text("$_scanBarcode\n",
                          style: const TextStyle(fontSize: 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    final data =
                                        ClipboardData(text: _scanBarcode);
                                    Clipboard.setData(data);
                                  },
                                  icon: const Icon(Icons.copy)),
                              const Text("Copy")
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () => _launchURL(),
                                  icon: const Icon(Icons.open_in_browser)),
                              const Text("Open")
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    if (_scanBarcode.isNotEmpty) {
                                      Share.share(_scanBarcode);
                                    } else {
                                      return null;
                                    }
                                  },
                                  icon: const Icon(Icons.share)),
                              const Text("Share")
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              ));
        }));
  }
}
