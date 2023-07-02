String formatRupiah(int price) {
  String priceString = price.toStringAsFixed(0);
  String formattedPrice = 'Rp ${priceString.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';
  return formattedPrice;
}
