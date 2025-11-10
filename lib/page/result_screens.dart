import 'package:flutter/material.dart';
import 'home_screens.dart';

class ResultScreen extends StatelessWidget {
  final String namaProduk;
  final String kategori;
  final double hpp;
  final double totalBiayaBahan;
  final double totalAlokasiBiayaTetap;
  final double totalBiayaTenagaKerja;
  final BiayaTenagaKerja? biayaTenagaKerja;
  final List<Bahan> listBahan;
  final List<BiayaTetap> listBiayaTetap;

  const ResultScreen({
    super.key,
    required this.namaProduk,
    required this.kategori,
    required this.hpp,
    required this.totalBiayaBahan,
    required this.totalAlokasiBiayaTetap,
    required this.totalBiayaTenagaKerja,
    this.biayaTenagaKerja,
    required this.listBahan,
    required this.listBiayaTetap,
  });

  // Warna tema
  final Color primaryColor = const Color(0xFF008B0B);
  final Color primaryLight = const Color(0xFFE8F5E9);
  final Color backgroundColor = const Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    double saranHargaJual = hpp * 1.3; // Markup 30%
    double saranHargaJual2 = hpp * 1.5; // Markup 50%
    double saranHargaJual3 = hpp * 2.0; // Markup 100%

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hasil Perhitungan HPP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInfoProduk(),
            const SizedBox(height: 20),
            _buildRingkasanHPP(),
            const SizedBox(height: 20),
            _buildDetailBiaya(),
            const SizedBox(height: 20),
            _buildSaranHarga(saranHargaJual, saranHargaJual2, saranHargaJual3),
            const SizedBox(height: 30),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoProduk() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.inventory_2, color: primaryColor),
                const SizedBox(width: 12),
                const Text(
                  'Informasi Produk',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Nama Produk', namaProduk.isEmpty ? '-' : namaProduk),
            const SizedBox(height: 8),
            _buildInfoRow('Kategori', kategori.isEmpty ? '-' : kategori),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRingkasanHPP() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: primaryColor),
                const SizedBox(width: 12),
                const Text(
                  'Ringkasan HPP',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildHPPItem('Total Biaya Bahan', totalBiayaBahan),
            if (totalBiayaTenagaKerja > 0)
              _buildHPPItem('Biaya Tenaga Kerja', totalBiayaTenagaKerja),
            _buildHPPItem('Total Alokasi Biaya Tetap', totalAlokasiBiayaTetap),
            const Divider(thickness: 2, color: Colors.grey),
            _buildHPPItem('Harga Pokok Penjualan (HPP)', hpp, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildHPPItem(String label, double value, {bool isTotal = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isTotal ? primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isTotal ? Border.all(color: primaryColor.withOpacity(0.3)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? primaryColor : Colors.black87,
            ),
          ),
          Text(
            'Rp ${_formatCurrency(value)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? primaryColor : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailBiaya() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list_alt, color: primaryColor),
                const SizedBox(width: 12),
                const Text(
                  'Detail Biaya',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Biaya Bahan
            _buildSectionTitle('Biaya Bahan:'),
            ...listBahan.map((bahan) {
              return _buildDetailItem(
                '${bahan.nama.isEmpty ? 'Bahan' : bahan.nama} (${bahan.jumlahPakai} ${bahan.satuan})',
                bahan.biayaProduk,
              );
            }).toList(),
            
            // Biaya Tenaga Kerja
            if (totalBiayaTenagaKerja > 0) ...[
              const SizedBox(height: 16),
              _buildSectionTitle('Biaya Tenaga Kerja:'),
              _buildDetailItemWithSubtitle(
                'Tenaga Kerja',
                totalBiayaTenagaKerja,
                biayaTenagaKerja?.keterangan.isNotEmpty ?? false 
                    ? biayaTenagaKerja!.keterangan 
                    : null,
              ),
            ],
            
            // Biaya Tetap
            const SizedBox(height: 16),
            _buildSectionTitle('Biaya Tetap:'),
            ...listBiayaTetap.map((biaya) {
              return _buildDetailItem(
                biaya.nama.isEmpty ? 'Biaya Tetap' : biaya.nama,
                biaya.alokasiPerProduk,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, double value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          Text(
            'Rp ${_formatCurrency(value)}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItemWithSubtitle(String label, double value, String? subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          Text(
            'Rp ${_formatCurrency(value)}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSaranHarga(double harga1, double harga2, double harga3) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.attach_money, color: primaryColor),
                const SizedBox(width: 12),
                const Text(
                  'Saran Harga Jual',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Berikut beberapa pilihan harga jual berdasarkan markup yang umum digunakan:',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildSaranHargaItem('Markup 30% (Konservatif)', harga1, Icons.trending_down),
            _buildSaranHargaItem('Markup 50% (Standar)', harga2, Icons.trending_flat),
            _buildSaranHargaItem('Markup 100% (Agresif)', harga3, Icons.trending_up),
          ],
        ),
      ),
    );
  }

  Widget _buildSaranHargaItem(String label, double harga, IconData icon) {
    double keuntungan = harga - hpp;
    double margin = (keuntungan / harga) * 100;

    Color getColor() {
      if (icon == Icons.trending_down) return Colors.blue;
      if (icon == Icons.trending_flat) return primaryColor;
      return Colors.orange;
    }

    Color color = getColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSaranRow('Harga Jual:', 'Rp ${_formatCurrency(harga)}', true),
          _buildSaranRow('Keuntungan:', 'Rp ${_formatCurrency(keuntungan)}', false),
          _buildSaranRow('Margin:', '${margin.toStringAsFixed(1)}%', false),
        ],
      ),
    );
  }

  Widget _buildSaranRow(String label, String value, bool isBold) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? primaryColor : Colors.black87,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: primaryColor),
            ),
            child: Text(
              'Hitung Lagi',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _showSaveDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Simpan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.save, color: primaryColor),
            const SizedBox(width: 8),
            const Text('Simpan Perhitungan'),
          ],
        ),
        content: const Text('Fitur penyimpanan akan segera tersedia!'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}