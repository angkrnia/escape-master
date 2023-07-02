// ignore_for_file: file_names

class Transaksi {
  final String id;
  final int total;
  final int bayar;
  final String jam;
  final String kasir;

  Transaksi({required this.id, required this.kasir, required this.total, required this.bayar, required this.jam});

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'],
      total: json['total_price'],
      bayar: json['bayar'],
      jam: json['order_date'],
      kasir: json['created_by'],
    );
  }
}
