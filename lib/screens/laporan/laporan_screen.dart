// ignore_for_file: library_private_types_in_public_api
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../helpers/format_angka.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({Key? key}) : super(key: key);

  @override
  _LaporanScreenState createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  List<Map<String, dynamic>> _daftarOrders = [];
  bool isBtnLoading = false;
  int totalPendapatan = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cetak Laporan"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tanggal Awal',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _selectStartDate(context);
                    },
                    child: Text(_formatDate(_startDate)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tanggal Akhir',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _selectEndDate(context);
                    },
                    child: Text(_formatDate(_endDate)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _cetakLaporan();
            },
            child: const Text('Lihat Laporan'),
          ),
          const SizedBox(height: 16),
          if (_daftarOrders.isNotEmpty)
            Text(
              'Total Pendapatan: ${formatRupiah(totalPendapatan)}',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Order id')),
                  DataColumn(label: Text('Tanggal')),
                  DataColumn(label: Text('Total')),
                  DataColumn(label: Text('Cashier')),
                ],
                rows: _daftarOrders.isNotEmpty
                  ? _daftarOrders.map((order) {
                      return DataRow(cells: [
                        DataCell(Text(order['order_id'].toString())),
                        DataCell(Text(formatDateTime(order['order_date'].toString()))),
                        DataCell(Text(formatRupiah(order['total_price']))),
                        DataCell(Text(order['cashier'].toString())),
                      ]);
                    }).toList()
                  : [],
              ),
            )
        ],
      ),
    );
  }

  void _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  String formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final formatter = DateFormat('dd MMMM yyyy HH:mm:ss');
    return formatter.format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }

  String addOneDay(String date) {
    final dateTime = DateTime.parse(date);
    final newDateTime = dateTime.add(const Duration(days: 1));
    return _formatDate(newDateTime);
  }

  _cetakLaporan() {
    generateLaporan(_formatDate(_startDate), addOneDay(_endDate.toString()));
  }

  Future<void> generateLaporan(String from, String to) async {
    try {
      final uri = Uri.parse('https://calm-red-dove-fez.cyclic.app/laporan/range?from=$from&to=$to');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          _daftarOrders = List<Map<String, dynamic>>.from(jsonResponse['data']['laporan']);
          totalPendapatan = jsonResponse['data']['total_pendapatan'];
        });
      }
    } catch (e) {
      print('Error fetching data laporan: $e');
    }
  }
}
