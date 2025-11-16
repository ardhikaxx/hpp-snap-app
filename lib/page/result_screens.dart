import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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

  final Color primaryColor = const Color(0xFF0F6CCB);
  final Color primaryColorLight = const Color(0xFF0F84D4);
  final Color primaryLight = const Color(0xFFE8F2FF);
  final Color backgroundColor = const Color(0xFFF8FBFF);
  final Color successColor = const Color(0xFF00C853);
  final Color warningColor = const Color(0xFFFF9800);
  final Color infoColor = const Color(0xFF2196F3);
  final Color accentColor = const Color(0xFFFF6B35);

  @override
  Widget build(BuildContext context) {
    double validHpp = hpp;
    if (hpp.isNaN || hpp.isInfinite || hpp < 0) {
      validHpp = 0;
    }

    double saranHargaJual = _calculateSafePrice(validHpp, 1.3);
    double saranHargaJual2 = _calculateSafePrice(validHpp, 1.5);
    double saranHargaJual3 = _calculateSafePrice(validHpp, 2.0);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            collapsedHeight: 80,
            pinned: true,
            floating: false,
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 8,
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.chevronLeft,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            title: const Text(
              'Hasil Perhitungan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, primaryColorLight],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      right: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      left: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.asset(
                                'assets/icons/icon.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.white,
                                    child: Icon(
                                      Icons.image,
                                      color: primaryColor,
                                      size: 50,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Text(
                            'HPP SNAP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              _buildHPPCard(validHpp),
              const SizedBox(height: 16),
              _buildInfoProduk(),
              const SizedBox(height: 16),
              _buildRingkasanHPP(),
              const SizedBox(height: 16),
              _buildDetailBiaya(),
              const SizedBox(height: 16),
              _buildSaranHarga(
                saranHargaJual,
                saranHargaJual2,
                saranHargaJual3,
                validHpp,
              ),
              const SizedBox(height: 16),
              _buildActionButtons(context),
              const SizedBox(height: 30),
            ]),
          ),
        ],
      ),
    );
  }

  double _calculateSafePrice(double basePrice, double multiplier) {
    if (basePrice.isNaN || basePrice.isInfinite || basePrice <= 0) {
      return 0;
    }

    try {
      double result = basePrice * multiplier;
      if (result.isNaN || result.isInfinite) {
        return 0;
      }
      return result;
    } catch (e) {
      return 0;
    }
  }

  Widget _buildHPPCard(double hpp) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, primaryColorLight],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.moneyBillTransfer,
                  color: Colors.white.withOpacity(0.9),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Harga Pokok Produksi',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Rp ${_formatCurrency(hpp)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'per produk',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white.withOpacity(0.9),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Total biaya produksi per unit',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoProduk() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.shopping_bag_rounded,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Informasi Produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildEnhancedInfoRow(
                'Nama Produk',
                namaProduk.isEmpty ? '-' : namaProduk,
                FontAwesomeIcons.tag,
              ),
              const SizedBox(height: 12),
              _buildEnhancedInfoRow(
                'Kategori',
                kategori.isEmpty ? '-' : kategori,
                FontAwesomeIcons.layerGroup,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedInfoRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRingkasanHPP() {
    double validHpp = hpp;
    if (hpp.isNaN || hpp.isInfinite || hpp <= 0) {
      validHpp = 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      FontAwesomeIcons.wallet,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Ringkasan Biaya',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildEnhancedHPPItem(
                'Biaya Bahan Baku',
                totalBiayaBahan,
                FontAwesomeIcons.boxesPacking,
                infoColor,
                validHpp,
              ),
              if (totalBiayaTenagaKerja > 0)
                _buildEnhancedHPPItem(
                  'Biaya Tenaga Kerja',
                  totalBiayaTenagaKerja,
                  Icons.engineering_rounded,
                  warningColor,
                  validHpp,
                ),
              _buildEnhancedHPPItem(
                'Alokasi Biaya Tetap',
                totalAlokasiBiayaTetap,
                Icons.business_center_rounded,
                successColor,
                validHpp,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      primaryColor.withOpacity(0.1),
                      primaryColorLight.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.sackDollar,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Total HPP:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Rp ${_formatCurrency(hpp)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHPPItem(
    String label,
    double value,
    IconData icon,
    Color color,
    double totalHpp,
  ) {
    double percentage = 0;
    if (totalHpp > 0 && value > 0) {
      percentage = (value / totalHpp) * 100;
      if (percentage.isNaN || percentage.isInfinite) {
        percentage = 0;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                Text(
                  '${percentage.toStringAsFixed(1)}% dari total HPP',
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Rp ${_formatCurrency(value)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailBiaya() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      FontAwesomeIcons.fileInvoiceDollar,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Detail Biaya',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (listBahan.isNotEmpty) ...[
                _buildDetailSection(
                  'Bahan Baku',
                  Icons.inventory_2_rounded,
                  infoColor,
                  listBahan
                      .map(
                        (bahan) => _buildDetailItem(
                          '${bahan.nama.isEmpty ? 'Bahan' : bahan.nama}',
                          '${bahan.jumlahPakai} ${bahan.satuan}',
                          bahan.biayaProduk,
                          infoColor,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
              ],

              if (totalBiayaTenagaKerja > 0) ...[
                _buildDetailSection(
                  'Tenaga Kerja',
                  Icons.engineering_rounded,
                  warningColor,
                  [
                    _buildDetailItemWithSubtitle(
                      'Tenaga Kerja',
                      biayaTenagaKerja?.keterangan.isNotEmpty == true
                          ? biayaTenagaKerja!.keterangan
                          : 'Biaya pembuatan per produk',
                      totalBiayaTenagaKerja,
                      warningColor,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              if (listBiayaTetap.isNotEmpty) ...[
                _buildDetailSection(
                  'Biaya Tetap',
                  Icons.business_center_rounded,
                  successColor,
                  listBiayaTetap
                      .map(
                        (biaya) => _buildDetailItem(
                          biaya.nama.isEmpty ? 'Biaya Tetap' : biaya.nama,
                          'Alokasi per produk',
                          biaya.alokasiPerProduk,
                          successColor,
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    String title,
    IconData icon,
    Color color,
    List<Widget> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildDetailItem(
    String label,
    String subtitle,
    double value,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            'Rp ${_formatCurrency(value)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItemWithSubtitle(
    String label,
    String subtitle,
    double value,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            'Rp ${_formatCurrency(value)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaranHarga(
    double harga1,
    double harga2,
    double harga3,
    double hpp,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.trending_up_rounded,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Saran Harga Jual',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Pilih strategi harga berdasarkan target pasar dan margin yang diinginkan',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 20),
              _buildEnhancedSaranHargaItem(
                'Konservatif',
                '30% Markup',
                harga1,
                Icons.safety_check_rounded,
                const Color(0xFF4CAF50),
                'Risiko rendah, pasar kompetitif',
                hpp,
              ),
              _buildEnhancedSaranHargaItem(
                'Standar',
                '50% Markup',
                harga2,
                Icons.balance_rounded,
                const Color(0xFF2196F3),
                'Seimbang, pasar menengah',
                hpp,
              ),
              _buildEnhancedSaranHargaItem(
                'Agresif',
                '100% Markup',
                harga3,
                Icons.rocket_launch_rounded,
                const Color(0xFFFF5722),
                'Premium, pasar niche',
                hpp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedSaranHargaItem(
    String strategy,
    String markup,
    double harga,
    IconData icon,
    Color color,
    String description,
    double hpp,
  ) {
    double keuntungan = 0;
    double margin = 0;

    if (harga > 0 && hpp > 0) {
      keuntungan = harga - hpp;
      if (keuntungan > 0 && harga > 0) {
        margin = (keuntungan / harga) * 100;
        if (margin.isNaN || margin.isInfinite) {
          margin = 0;
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strategy,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      markup,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildPriceRow('Harga Jual', harga, true, color),
                _buildPriceRow('Keuntungan', keuntungan, false, color),
                _buildPriceRow('Margin', margin, false, color, isPercent: true),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double value,
    bool isMain,
    Color color, {
    bool isPercent = false,
  }) {
    double validValue = value;
    if (value.isNaN || value.isInfinite) {
      validValue = 0;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: isMain ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            isPercent
                ? '${validValue.toStringAsFixed(1)}%'
                : 'Rp ${_formatCurrency(validValue)}',
            style: TextStyle(
              fontWeight: isMain ? FontWeight.bold : FontWeight.w600,
              color: isMain ? color : Colors.grey[700],
              fontSize: isMain ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.replay_rounded, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Hitung Lagi',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor, primaryColorLight],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () => _exportToPdf(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.filePdf, color: Colors.white),
                      const SizedBox(width: 8),
                      const Text(
                        'Export PDF',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value.isNaN || value.isInfinite) {
      return '0';
    }

    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  Future<void> _exportToPdf(BuildContext context) async {
    try {
      _showLoadingSnackbar(context, 'Membuat PDF...');

      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              _buildPdfHeader(),
              pw.SizedBox(height: 20),
              _buildPdfProductInfo(),
              pw.SizedBox(height: 15),
              _buildPdfHppSummary(),
              pw.SizedBox(height: 15),
              if (listBahan.isNotEmpty) ...[
                _buildPdfMaterialDetails(),
                pw.SizedBox(height: 15),
              ],
              if (totalBiayaTenagaKerja > 0) ...[
                _buildPdfLaborDetails(),
                pw.SizedBox(height: 15),
              ],
              if (listBiayaTetap.isNotEmpty) ...[
                _buildPdfFixedCostDetails(),
                pw.SizedBox(height: 15),
              ],
              _buildPdfPriceSuggestions(),
              pw.SizedBox(height: 15),
              _buildPdfFooter(),
            ];
          },
        ),
      );

      final bytes = await pdf.save();

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      await Printing.sharePdf(
        bytes: bytes,
        filename:
            'Laporan_HPP_${namaProduk.isEmpty ? 'Produk' : namaProduk.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );

      _showSuccessSnackbar(context, 'PDF berhasil diexport!');
    } catch (e) {
      // Tutup snackbar loading jika ada error
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
      _showErrorSnackbar(context, 'Gagal export PDF: ${e.toString()}');
    }
  }

  pw.Widget _buildPdfHeader() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'LAPORAN HPP',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.Text(
                  'HPP SNAP - Aplikasi Perhitungan Harga Pokok Produksi',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
            pw.Text(
              'Tanggal: ${DateTime.now().toString().split(' ')[0]}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
        pw.Divider(thickness: 2),
      ],
    );
  }

  pw.Widget _buildPdfProductInfo() {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blue200),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'INFORMASI PRODUK',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              pw.Text(
                'Nama Produk: ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(namaProduk.isEmpty ? '-' : namaProduk),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              pw.Text(
                'Kategori: ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(kategori.isEmpty ? '-' : kategori),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfHppSummary() {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.green200),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'RINGKASAN BIAYA',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green800,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildPdfCostRow('Biaya Bahan Baku', totalBiayaBahan),
          if (totalBiayaTenagaKerja > 0)
            _buildPdfCostRow('Biaya Tenaga Kerja', totalBiayaTenagaKerja),
          _buildPdfCostRow('Alokasi Biaya Tetap', totalAlokasiBiayaTetap),
          pw.Divider(),
          _buildPdfCostRow('TOTAL HPP', hpp, isTotal: true),
        ],
      ),
    );
  }

  pw.Widget _buildPdfCostRow(
    String label,
    double value, {
    bool isTotal = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: isTotal
                ? pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)
                : null,
          ),
          pw.Text(
            'Rp ${_formatCurrency(value)}',
            style: isTotal
                ? pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)
                : null,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfMaterialDetails() {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.orange200),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'DETAIL BAHAN BAKU',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.orange800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Nama Bahan',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Jumlah Pakai',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Satuan',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Biaya/Produk',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
              for (var bahan in listBahan)
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(bahan.nama.isEmpty ? 'Bahan' : bahan.nama),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(bahan.jumlahPakai.toString()),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(bahan.satuan),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Rp ${_formatCurrency(bahan.biayaProduk)}',
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfLaborDetails() {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.amber200),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'DETAIL TENAGA KERJA',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.amber800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Keterangan',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Biaya/Produk',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      biayaTenagaKerja?.keterangan.isNotEmpty == true
                          ? biayaTenagaKerja!.keterangan
                          : 'Biaya tenaga kerja per produk',
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Rp ${_formatCurrency(totalBiayaTenagaKerja)}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfFixedCostDetails() {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.purple200),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'DETAIL BIAYA TETAP',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.purple800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Nama Biaya',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Total Biaya/Bulan',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Alokasi/Produk',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
              for (var biaya in listBiayaTetap)
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        biaya.nama.isEmpty ? 'Biaya Tetap' : biaya.nama,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Rp ${_formatCurrency(biaya.totalBiaya)}'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Rp ${_formatCurrency(biaya.alokasiPerProduk)}',
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfPriceSuggestions() {
    double saran1 = _calculateSafePrice(hpp, 1.3);
    double saran2 = _calculateSafePrice(hpp, 1.5);
    double saran3 = _calculateSafePrice(hpp, 2.0);

    List<Map<String, dynamic>> saranList = [
      {"strategi": "Konservatif", "markup": "30%", "harga": saran1},
      {"strategi": "Standar", "markup": "50%", "harga": saran2},
      {"strategi": "Agresif", "markup": "100%", "harga": saran3},
    ];

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.red200),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'SARAN HARGA JUAL',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.red800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Strategi',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Markup',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Harga Jual',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Keuntungan',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Margin',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
              for (var saran in saranList)
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(saran["strategi"]),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(saran["markup"]),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Rp ${_formatCurrency(saran["harga"])}'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Rp ${_formatCurrency(saran["harga"] - hpp)}',
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        '${((saran["harga"] - hpp) / saran["harga"] * 100).toStringAsFixed(1)}%',
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfFooter() {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'Catatan:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Laporan ini dibuat secara otomatis oleh aplikasi HPP SNAP. '
            'Pastikan untuk menyesuaikan harga berdasarkan kondisi pasar dan strategi bisnis Anda.',
            style: const pw.TextStyle(fontSize: 10),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showLoadingSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 30),
      ),
    );
  }

  void _showSuccessSnackbar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
