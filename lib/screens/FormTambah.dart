// // ignore_for_file: file_names, avoid_print, sort_child_properties_last

// import 'package:flutter/material.dart';
// import '../models/TransaksiBarangModel.dart';
// import '../models/BarangModel.dart';
// import '../models/menu_model.dart';
// import '../api/menu_service.dart';
// import 'package:intl/intl.dart';

// class PenjualanForm extends StatefulWidget {
//   const PenjualanForm({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _PenjualanFormState createState() => _PenjualanFormState();
// }

// class _PenjualanFormState extends State<PenjualanForm> {
//   final _formKey = GlobalKey<FormState>();
//   //final _namaController = TextEditingController();
//   final _barangController = TextEditingController();
//   final _jumlahController = TextEditingController();
//   final _bayarController = TextEditingController();
//   int totalbelanja = 0;
//   DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

//   List<Menu> _daftarBarang = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     try {
//       MenuService menuService = MenuService();
//       List<Menu> menuList = await menuService.getMenu();
//       setState(() {
//         _daftarBarang = menuList;
//       });
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }

//   // final List<Barang> _daftarBarang = [
//   //   Barang(nama: 'Ayam Geprek', kategori: 'makanan', harga: 18000),
//   //   Barang(nama: 'Nasi Goreng', kategori: 'makanan', harga: 15000),
//   //   Barang(nama: 'Aqua', kategori: 'minuman', harga: 5000),
//   //   Barang(nama: 'Tea Jus', kategori: 'minuman', harga: 5000),
//   //   Barang(nama: 'Kopi', kategori: 'minuman', harga: 5000),
//   // ];

//   Barang? _selectedBarang;

//   @override
//   void dispose() {
//     //_namaController.dispose();
//     _barangController.dispose();
//     _jumlahController.dispose();
//     _bayarController.dispose();
//     super.dispose();
//   }

//   void _tambahBarang() {
//     if (_selectedBarang != null) {
//       String tnama = _selectedBarang!.nama;
//       String tkategori = _selectedBarang!.kategori;
//       int tjumlah = int.parse(_jumlahController.text);
//       int tharga = _selectedBarang!.harga;
//       int ttotal = tjumlah * tharga;
//       totalbelanja = totalbelanja + ttotal;
//       TransaksiBarang? _TransaksiBarang = TransaksiBarang(nama: tnama, kategori: tkategori, jumlah: tjumlah, harga: tharga, total: ttotal);
//       setState(() {
//         _daftarBarang.add(_TransaksiBarang);
//         _selectedBarang = null;
//         _jumlahController.text = '';
//       });
//     }
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       // Simpan data penjualan
//       //String namaPembeli = _namaController.text;
//       int totalHarga = _daftarBarang.fold(0, (sum, barang) => sum + barang.total);

//       // Lakukan sesuatu dengan data penjualan (misalnya, menyimpan ke database)

//       // Kirim data ke halaman invoice
//       Navigator.pushNamed(
//         context,
//         '/invoice',
//         arguments: {
//           'namaPembeli': 'Administrator',
//           'totalHarga': totalHarga,
//           'bayar' : int.parse(_bayarController.text),
//           'jam' : dateFormat.format(DateTime.now()),
//           'listBarang': _daftarBarang,
//         },
//       );

//       // Reset form
//       //_namaController.clear();
//       _daftarBarang.clear();
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Buat Transaksi'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Kasir : Administrator'),
//                 const SizedBox(height: 16.0),
//                 const Text('Daftar Barang'),
//                 const SizedBox(height: 8.0),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: DataTable(
//                     columnSpacing: 16.0, // Jarak antara kolom
//                     columns: const [
//                       DataColumn(label: Text('No.')),
//                       DataColumn(label: Text('Nama Barang')),
//                       DataColumn(label: Text('Jumlah')),
//                       DataColumn(label: Text('Harga')),
//                       DataColumn(label: Text('Total')),
//                       DataColumn(label: Text('Aksi')),
//                     ],
//                     rows: _daftarBarang
//                         .asMap()
//                         .entries
//                         .map(
//                           (entry) => DataRow(
//                             cells: [
//                               DataCell(Text('${entry.key + 1}')),
//                               DataCell(Text(entry.value.nama)),
//                               DataCell(Text(entry.value.jumlah.toString())), // Jumlah barang sementara 1
//                               DataCell(Text(entry.value.harga.toString())),
//                               DataCell(Text(entry.value.total.toString())), // Total harga sementara harga barang
//                               DataCell(IconButton(
//                                 icon: const Icon(Icons.delete),
//                                 onPressed: () {
//                                   setState(() {
//                                     _daftarBarang.removeAt(entry.key);
//                                   });
//                                 },
//                               )),
//                             ],
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 DropdownButtonFormField<Menu>(
//                   value: _selectedBarang,
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedBarang = value;
//                     });
//                   },
//                   items: _daftarBarang
//                       .map(
//                         (barang) => DropdownMenuItem(
//                           value: barang,
//                           child: Text(barang.name),
//                         ),
//                       )
//                       .toList(),
//                   decoration: const InputDecoration(labelText: 'Barang'),
//                 ),
//                 const SizedBox(height: 8.0),
//                 TextFormField(
//                   controller: _jumlahController,
//                   decoration: const InputDecoration(labelText: 'Jumlah Barang'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 8.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const SizedBox(),
//                     ElevatedButton(
//                       onPressed: _tambahBarang,
//                       child: const Text('Tambah Barang'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8.0),
//                 Text('Total Harga : $totalbelanja'),
//                 const SizedBox(height: 8.0),
//                 TextFormField(
//                   controller: _bayarController,
//                   decoration: const InputDecoration(labelText: 'Bayar'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 16.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: _submitForm,
//                       child: const Text('Submit'),
//                       style: ButtonStyle(
//                         backgroundColor:
//                             MaterialStateProperty.all<Color>(Colors.blue),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
