import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'result_screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Bahan {
  String nama;
  double jumlahPakai;
  String satuan;
  double totalHarga;
  double jumlahBeli;
  String satuanBeli;
  double biayaProduk;

  Bahan({
    required this.nama,
    required this.jumlahPakai,
    required this.satuan,
    required this.totalHarga,
    required this.jumlahBeli,
    required this.satuanBeli,
    required this.biayaProduk,
  });

  Bahan.copy(Bahan other)
    : nama = other.nama,
      jumlahPakai = other.jumlahPakai,
      satuan = other.satuan,
      totalHarga = other.totalHarga,
      jumlahBeli = other.jumlahBeli,
      satuanBeli = other.satuanBeli,
      biayaProduk = other.biayaProduk;
}

class BiayaTetap {
  String nama;
  double totalBiaya;
  double alokasiPerProduk;

  BiayaTetap({
    required this.nama,
    required this.totalBiaya,
    required this.alokasiPerProduk,
  });

  BiayaTetap.copy(BiayaTetap other)
    : nama = other.nama,
      totalBiaya = other.totalBiaya,
      alokasiPerProduk = other.alokasiPerProduk;
}

class BiayaTenagaKerja {
  double biayaPerProduk;
  String keterangan;

  BiayaTenagaKerja({required this.biayaPerProduk, required this.keterangan});
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController namaProdukController = TextEditingController();
  TextEditingController kategoriController = TextEditingController();
  TextEditingController targetPenjualanController = TextEditingController();
  TextEditingController biayaTenagaKerjaController = TextEditingController();
  TextEditingController keteranganTenagaKerjaController =
      TextEditingController();

  List<Bahan> listBahan = [];

  List<BiayaTetap> listBiayaTetap = [];

  BiayaTenagaKerja? biayaTenagaKerja;
  bool showBiayaTenagaKerja = false;

  final Color primaryColor = const Color(0xFF0F6CCB);
  final Color primaryColorLight = const Color(0xFF0F84D4);
  final Color primaryLight = const Color(0xFFE8F2FF);
  final Color backgroundPrimary = const Color(0xFFF8FBFF);
  final Color gradientStart = const Color(0xFF0F6CCB);
  final Color gradientEnd = const Color(0xFF0F84D4);
  final Color accentColor = const Color(0xFFFF6B35);
  final Color successColor = const Color(0xFF00C853);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundPrimary,
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
            title: const Text(
              'HPP SNAP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                fontFamily: 'SuperTrend',
                letterSpacing: 1.2,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () {
                    _showHelpDialog(context);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.circleInfo,
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, primaryColorLight],
                  ),
                  borderRadius: BorderRadius.only(
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
                                    child: const Icon(
                                      Icons.shopping_bag_rounded,
                                      color: Color(0xFF0F6CCB),
                                      size: 50,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Text(
                            'Hitung Harga Pokok Produksi',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildInfoProduk(),
                      const SizedBox(height: 14),
                      _buildBahanSection(),
                      const SizedBox(height: 14),
                      _buildBiayaTenagaKerjaSection(),
                      const SizedBox(height: 14),
                      _buildBiayaTetapSection(),
                      const SizedBox(height: 16),
                      _buildHitungButton(),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: SizedBox(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, primaryLight.withOpacity(0.3)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.2),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CustomPaint(
                    painter: _HelpDialogPainter(primaryColor),
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [primaryColor, primaryColorLight],
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.book,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Panduan HPP SNAP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'SuperTrend',
                                    letterSpacing: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Ikuti langkah-langkah berikut untuk menghitung Harga Pokok Produksi (HPP) dengan mudah dan cepat',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    _buildEnhancedHelpStep(
                                      number: 1,
                                      icon: Icons.shopping_bag_rounded,
                                      title: 'Informasi Produk',
                                      description:
                                          'Isi nama dan kategori produk Anda untuk identifikasi',
                                      color: primaryColor,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildEnhancedHelpStep(
                                      number: 2,
                                      icon: FontAwesomeIcons.boxesPacking,
                                      title: 'Bahan Baku',
                                      description:
                                          'Tambahkan semua bahan yang digunakan beserta detail harga dan jumlah pemakaian',
                                      color: accentColor,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildEnhancedHelpStep(
                                      number: 3,
                                      icon: Icons.attach_money,
                                      title: 'Biaya Tenaga Kerja',
                                      description:
                                          'Atur biaya pembuatan per produk (opsional)',
                                      color: const Color(0xFF9C27B0),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildEnhancedHelpStep(
                                      number: 4,
                                      icon: Icons.business_center_rounded,
                                      title: 'Biaya Tetap',
                                      description:
                                          'Alokasikan biaya operasional bulanan ke setiap produk',
                                      color: successColor,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildEnhancedHelpStep(
                                      number: 5,
                                      icon: Icons.calculate_rounded,
                                      title: 'Hitung HPP',
                                      description:
                                          'Dapatkan HPP dan saran harga jual yang optimal',
                                      color: const Color(0xFFFF9800),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: primaryColor.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.lightbulb_rounded,
                                                color: const Color(0xFFFFC107),
                                                size: 24,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Tips Penting',
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          _buildTipItem(
                                            'Pastikan semua bahan tercatat dengan lengkap',
                                          ),
                                          _buildTipItem(
                                            'Perhatikan satuan yang digunakan untuk konsistensi',
                                          ),
                                          _buildTipItem(
                                            'Target penjualan membantu alokasi biaya tetap yang akurat',
                                          ),
                                          _buildTipItem(
                                            'Biaya tenaga kerja dapat meningkatkan akurasi perhitungan',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: primaryColor,
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Tutup',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHelpStep({
    required int number,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color,
                  Color.alphaBlend(color.withOpacity(0.7), color),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoProduk() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withAlpha(70),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_bag, color: primaryColor),
                const SizedBox(width: 12),
                const Text(
                  'Informasi Produk',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: namaProdukController,
              decoration: InputDecoration(
                labelText: 'Nama Produk',
                labelStyle: TextStyle(color: Colors.grey[500]),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                filled: true,
                fillColor: primaryLight,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan nama produk';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: kategoriController,
              decoration: InputDecoration(
                labelText: 'Kategori Produk',
                labelStyle: TextStyle(color: Colors.grey[500]),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                filled: true,
                fillColor: primaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBahanSection() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withAlpha(70),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(FontAwesomeIcons.boxesPacking, color: primaryColor),
                const SizedBox(width: 12),
                const Text(
                  'Bahan Baku',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => _showTambahBahanPopup(null),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Daftar bahan baku yang digunakan:',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 12),
            ...listBahan.asMap().entries.map((entry) {
              int index = entry.key;
              Bahan bahan = entry.value;
              return _buildBahanCard(index, bahan);
            }),
            if (listBahan.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/img/bahan.png',
                      width: 220,
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          FontAwesomeIcons.boxOpen,
                          size: 48,
                          color: Colors.grey[400],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Belum ada bahan baku',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _showTambahBahanPopup(null),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Tambah Bahan Baku Pertama'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBahanCard(int index, Bahan bahan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primaryColor.withOpacity(0.1), width: 2),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(FontAwesomeIcons.boxOpen, color: primaryColor),
        ),
        title: Text(
          bahan.nama.isEmpty ? 'Bahan Baku ${index + 1}' : bahan.nama,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${_formatNumber(bahan.jumlahPakai)} ${bahan.satuan} per produk',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              'Biaya: Rp ${_formatCurrency(bahan.biayaProduk)}',
              style: TextStyle(
                fontSize: 12,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          color: Colors.white,
          icon: Icon(FontAwesomeIcons.ellipsis, color: primaryColor),
          onSelected: (value) {
            if (value == 'edit') {
              _showTambahBahanPopup(index);
            } else if (value == 'delete') {
              _hapusBahan(index);
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.penToSquare, size: 16, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.trashCan, color: Colors.red, size: 16),
                  SizedBox(width: 8),
                  Text('Hapus'),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _showTambahBahanPopup(index),
      ),
    );
  }

  void _showTambahBahanPopup(int? index) {
    bool isEdit = index != null;
    Bahan bahanEdit = isEdit
        ? Bahan.copy(listBahan[index])
        : Bahan(
            nama: '',
            jumlahPakai: 0,
            satuan: 'pcs',
            totalHarga: 0,
            jumlahBeli: 0,
            satuanBeli: 'pcs',
            biayaProduk: 0,
          );

    TextEditingController namaController = TextEditingController(
      text: bahanEdit.nama,
    );
    TextEditingController jumlahPakaiController = TextEditingController(
      text: bahanEdit.jumlahPakai == 0
          ? ''
          : _formatNumberInput(bahanEdit.jumlahPakai),
    );
    TextEditingController satuanController = TextEditingController(
      text: bahanEdit.satuan,
    );
    TextEditingController totalHargaController = TextEditingController(
      text: bahanEdit.totalHarga == 0
          ? ''
          : _formatNumberInput(bahanEdit.totalHarga),
    );
    TextEditingController jumlahBeliController = TextEditingController(
      text: bahanEdit.jumlahBeli == 0
          ? ''
          : _formatNumberInput(bahanEdit.jumlahBeli),
    );
    TextEditingController satuanBeliController = TextEditingController(
      text: bahanEdit.satuanBeli,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(
              isEdit ? Icons.edit : Icons.post_add_rounded,
              color: primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              isEdit ? 'Edit Bahan Baku' : 'Tambah Bahan Baku',
              style: TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Bahan',
                  labelStyle: TextStyle(color: Colors.grey[500]),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: primaryLight,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: jumlahPakaiController,
                      decoration: InputDecoration(
                        labelText: 'Jumlah Pakai',
                        labelStyle: TextStyle(color: Colors.grey[500]),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: primaryLight,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: satuanController,
                      decoration: InputDecoration(
                        labelText: 'Satuan',
                        labelStyle: TextStyle(color: Colors.grey[500]),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: primaryLight,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Info Pembelian Bahan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: totalHargaController,
                decoration: InputDecoration(
                  labelText: 'Total Harga Pembelian',
                  labelStyle: TextStyle(color: Colors.grey[500]),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: primaryLight,
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: jumlahBeliController,
                      decoration: InputDecoration(
                        labelText: 'Jumlah Beli',
                        labelStyle: TextStyle(color: Colors.grey[500]),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: primaryLight,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: satuanBeliController,
                      decoration: InputDecoration(
                        labelText: 'Satuan Beli',
                        labelStyle: TextStyle(color: Colors.grey[500]),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: primaryLight,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor),
                ),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.boxOpen, color: primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Biaya per Produk:',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Rp ${_formatCurrency(_hitungBiayaProduk(double.tryParse(totalHargaController.text) ?? 0, double.tryParse(jumlahBeliController.text) ?? 0, double.tryParse(jumlahPakaiController.text) ?? 0))}',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: primaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              _simpanBahan(
                index,
                namaController.text,
                double.tryParse(jumlahPakaiController.text) ?? 0,
                satuanController.text,
                double.tryParse(totalHargaController.text) ?? 0,
                double.tryParse(jumlahBeliController.text) ?? 0,
                satuanBeliController.text,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(isEdit ? 'Simpan' : 'Tambah'),
          ),
        ],
      ),
    );
  }

  void _simpanBahan(
    int? index,
    String nama,
    double jumlahPakai,
    String satuan,
    double totalHarga,
    double jumlahBeli,
    String satuanBeli,
  ) {
    double biayaProduk = _hitungBiayaProduk(
      totalHarga,
      jumlahBeli,
      jumlahPakai,
    );

    setState(() {
      if (index == null) {
        listBahan.add(
          Bahan(
            nama: nama,
            jumlahPakai: jumlahPakai,
            satuan: satuan,
            totalHarga: totalHarga,
            jumlahBeli: jumlahBeli,
            satuanBeli: satuanBeli,
            biayaProduk: biayaProduk,
          ),
        );
      } else {
        listBahan[index] = Bahan(
          nama: nama,
          jumlahPakai: jumlahPakai,
          satuan: satuan,
          totalHarga: totalHarga,
          jumlahBeli: jumlahBeli,
          satuanBeli: satuanBeli,
          biayaProduk: biayaProduk,
        );
      }
    });
  }

  double _hitungBiayaProduk(
    double totalHarga,
    double jumlahBeli,
    double jumlahPakai,
  ) {
    if (jumlahBeli <= 0 || totalHarga <= 0 || jumlahPakai <= 0) {
      return 0;
    }

    try {
      double biayaPerUnit = totalHarga / jumlahBeli;
      double result = biayaPerUnit * jumlahPakai;

      if (result.isNaN || result.isInfinite) {
        return 0;
      }

      return result;
    } catch (e) {
      return 0;
    }
  }

  Widget _buildBiayaTenagaKerjaSection() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withAlpha(70),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(FontAwesomeIcons.sackDollar, color: primaryColor),
                const SizedBox(width: 12),
                const Text(
                  'Biaya Tenaga Kerja',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Switch(
                  value: showBiayaTenagaKerja,
                  onChanged: (value) {
                    setState(() {
                      showBiayaTenagaKerja = value;
                      if (!value) {
                        biayaTenagaKerja = null;
                        biayaTenagaKerjaController.clear();
                        keteranganTenagaKerjaController.clear();
                      }
                    });
                  },
                  activeThumbColor: primaryColor,
                  activeTrackColor: primaryLight,
                  inactiveThumbColor: Colors.grey.shade500,
                  inactiveTrackColor: Colors.grey.shade100,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan biaya tenaga kerja per produk (opsional)',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            if (showBiayaTenagaKerja) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: biayaTenagaKerjaController,
                decoration: InputDecoration(
                  labelText: 'Biaya Tenaga Kerja per Produk (Rp)',
                  labelStyle: TextStyle(color: Colors.grey[500]),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: primaryLight,
                  prefixText: 'Rp ',
                  helperText: 'Masukkan biaya untuk membuat 1 produk',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _updateBiayaTenagaKerja();
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: keteranganTenagaKerjaController,
                decoration: InputDecoration(
                  labelText: 'Keterangan (Opsional)',
                  labelStyle: TextStyle(color: Colors.grey[500]),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: primaryLight,
                  helperText: 'Contoh: Upah karyawan, biaya pembuatan, dll.',
                ),
                onChanged: (value) {
                  _updateBiayaTenagaKerja();
                },
              ),
              const SizedBox(height: 8),
              if (biayaTenagaKerja != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryLight,
                    border: Border.all(color: primaryColor),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Biaya tenaga kerja: Rp ${_formatCurrency(biayaTenagaKerja!.biayaPerProduk)} per produk',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBiayaTetapSection() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withAlpha(70),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.business_center, color: primaryColor),
                const SizedBox(width: 12),
                const Text(
                  'Alokasi Biaya Tetap',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => _showTambahBiayaTetapPopup(null),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Alokasikan sebagian total biaya bulanan Anda ke setiap produk yang terjual',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: targetPenjualanController,
              decoration: InputDecoration(
                labelText: 'Jumlah Target Penjualan per Bulan',
                labelStyle: TextStyle(color: Colors.grey[500]),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                filled: true,
                fillColor: primaryLight,
                helperText:
                    'Digunakan untuk memberi saran alokasi biaya yang ideal',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _updateSaranAlokasi();
                });
              },
            ),
            const SizedBox(height: 20),
            ...listBiayaTetap.asMap().entries.map((entry) {
              int index = entry.key;
              BiayaTetap biaya = entry.value;
              return _buildBiayaTetapCard(index, biaya);
            }).toList(),
            if (listBiayaTetap.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/img/biaya.png',
                      width: 220,
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.attach_money,
                          size: 48,
                          color: Colors.grey[400],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Belum ada biaya tetap',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _showTambahBiayaTetapPopup(null),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Tambah Biaya Tetap Pertama'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiayaTetapCard(int index, BiayaTetap biaya) {
    _hitungSaranAlokasi(biaya.totalBiaya);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primaryColor.withOpacity(0.1), width: 2),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(FontAwesomeIcons.fileInvoiceDollar, color: primaryColor),
        ),
        title: Text(
          biaya.nama.isEmpty ? 'Biaya Tetap ${index + 1}' : biaya.nama,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Total: Rp ${_formatCurrency(biaya.totalBiaya)}/bulan',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              'Alokasi: Rp ${_formatCurrency(biaya.alokasiPerProduk)}/produk',
              style: TextStyle(
                fontSize: 12,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          color: Colors.white,
          icon: Icon(FontAwesomeIcons.ellipsis, color: primaryColor),
          onSelected: (value) {
            if (value == 'edit') {
              _showTambahBiayaTetapPopup(index);
            } else if (value == 'delete') {
              _hapusBiayaTetap(index);
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.penToSquare, size: 16, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.trashCan, color: Colors.red, size: 16),
                  SizedBox(width: 8),
                  Text('Hapus'),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _showTambahBiayaTetapPopup(index),
      ),
    );
  }

  void _showTambahBiayaTetapPopup(int? index) {
    bool isEdit = index != null;
    BiayaTetap biayaEdit = isEdit
        ? BiayaTetap.copy(listBiayaTetap[index])
        : BiayaTetap(nama: '', totalBiaya: 0, alokasiPerProduk: 0);

    TextEditingController namaController = TextEditingController(
      text: biayaEdit.nama,
    );
    TextEditingController totalBiayaController = TextEditingController(
      text: biayaEdit.totalBiaya == 0
          ? ''
          : _formatNumberInput(biayaEdit.totalBiaya),
    );
    TextEditingController alokasiController = TextEditingController(
      text: biayaEdit.alokasiPerProduk == 0
          ? ''
          : _formatNumberInput(biayaEdit.alokasiPerProduk),
    );

    double saranAlokasi = _hitungSaranAlokasi(biayaEdit.totalBiaya);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Icon(isEdit ? Icons.edit : FontAwesomeIcons.sackDollar, color: primaryColor),
                const SizedBox(width: 8),
                Text(isEdit ? 'Edit Biaya Tetap' : 'Tambah Biaya Tetap', style: TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama Biaya',
                      labelStyle: TextStyle(color: Colors.grey[500]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      filled: true,
                      fillColor: primaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: totalBiayaController,
                    decoration: InputDecoration(
                      labelText: 'Total Biaya per Bulan (Rp)',
                      labelStyle: TextStyle(color: Colors.grey[500]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      filled: true,
                      fillColor: primaryLight,
                      prefixText: 'Rp ',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setDialogState(() {
                        saranAlokasi = _hitungSaranAlokasi(
                          double.tryParse(value) ?? 0,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: alokasiController,
                    decoration: InputDecoration(
                      labelText: 'Alokasi per Produk (Rp)',
                      labelStyle: TextStyle(color: Colors.grey[500]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      filled: true,
                      fillColor: primaryLight,
                      prefixText: 'Rp ',
                      helperText: 'Saran: Rp ${_formatCurrency(saranAlokasi)}',
                      helperStyle: TextStyle(color: primaryColor),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb, color: primaryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saran Alokasi:',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Rp ${_formatCurrency(saranAlokasi)} per produk',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (saranAlokasi > 0)
                                Text(
                                  'Berdasarkan target ${targetPenjualanController.text.isEmpty ? '0' : targetPenjualanController.text} penjualan/bulan',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 10,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal', style: TextStyle(color: primaryColor)),
              ),
              ElevatedButton(
                onPressed: () {
                  _simpanBiayaTetap(
                    index,
                    namaController.text,
                    double.tryParse(totalBiayaController.text) ?? 0,
                    double.tryParse(alokasiController.text) ?? 0,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(isEdit ? 'Simpan' : 'Tambah'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _simpanBiayaTetap(
    int? index,
    String nama,
    double totalBiaya,
    double alokasiPerProduk,
  ) {
    setState(() {
      if (index == null) {
        listBiayaTetap.add(
          BiayaTetap(
            nama: nama,
            totalBiaya: totalBiaya,
            alokasiPerProduk: alokasiPerProduk,
          ),
        );
      } else {
        listBiayaTetap[index] = BiayaTetap(
          nama: nama,
          totalBiaya: totalBiaya,
          alokasiPerProduk: alokasiPerProduk,
        );
      }
    });
  }

  Widget _buildHitungButton() {
    bool hasData =
        listBahan.isNotEmpty ||
        listBiayaTetap.isNotEmpty ||
        showBiayaTenagaKerja;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: hasData
            ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: hasData ? _hitungHPP : null,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: hasData
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryColor, primaryColorLight],
                    )
                  : LinearGradient(
                      colors: [Colors.grey.shade400, Colors.grey.shade500],
                    ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                hasData
                    ? 'Hitung HPP & Saran Harga'
                    : 'Tambahkan Data Terlebih Dahulu',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _hapusBahan(int index) {
    setState(() {
      listBahan.removeAt(index);
    });
  }

  void _hapusBiayaTetap(int index) {
    setState(() {
      listBiayaTetap.removeAt(index);
    });
  }

  void _updateBiayaTenagaKerja() {
    double biaya = double.tryParse(biayaTenagaKerjaController.text) ?? 0;
    if (biaya > 0) {
      setState(() {
        biayaTenagaKerja = BiayaTenagaKerja(
          biayaPerProduk: biaya,
          keterangan: keteranganTenagaKerjaController.text,
        );
      });
    } else {
      setState(() {
        biayaTenagaKerja = null;
      });
    }
  }

  void _updateSaranAlokasi() {
    setState(() {});
  }

  double _hitungSaranAlokasi(double totalBiaya) {
    double target = double.tryParse(targetPenjualanController.text) ?? 0;
    if (target <= 0 || totalBiaya <= 0) {
      return 0;
    }

    try {
      double result = totalBiaya / target;
      if (result.isNaN || result.isInfinite) {
        return 0;
      }

      return result;
    } catch (e) {
      return 0;
    }
  }

  String _formatNumber(double value) {
    if (value.isNaN || value.isInfinite) {
      return '0';
    }

    if (value == value.toInt()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  String _formatNumberInput(double value) {
    if (value == 0) {
      return '';
    }
    return _formatNumber(value);
  }

  String _formatCurrency(double value) {
    if (value.isNaN || value.isInfinite) {
      return '0';
    }

    String numberString;
    if (value == value.toInt()) {
      numberString = value.toInt().toString();
    } else {
      numberString = value.toStringAsFixed(
        0,
      );
    }

    return numberString.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _hitungHPP() {
    if (_formKey.currentState!.validate()) {
      double totalBiayaBahan = listBahan.fold(0, (sum, bahan) {
        double biaya = bahan.biayaProduk;
        if (biaya.isNaN || biaya.isInfinite) {
          return sum;
        }
        return sum + biaya;
      });

      double totalAlokasiBiayaTetap = listBiayaTetap.fold(0, (sum, biaya) {
        double alokasi = biaya.alokasiPerProduk;
        if (alokasi.isNaN || alokasi.isInfinite) {
          return sum;
        }
        return sum + alokasi;
      });

      double totalBiayaTenagaKerja = biayaTenagaKerja?.biayaPerProduk ?? 0;

      if (totalBiayaTenagaKerja.isNaN || totalBiayaTenagaKerja.isInfinite) {
        totalBiayaTenagaKerja = 0;
      }

      double hpp =
          totalBiayaBahan + totalAlokasiBiayaTetap + totalBiayaTenagaKerja;

      if (hpp.isNaN || hpp.isInfinite) {
        hpp = 0;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            namaProduk: namaProdukController.text,
            kategori: kategoriController.text,
            hpp: hpp,
            totalBiayaBahan: totalBiayaBahan,
            totalAlokasiBiayaTetap: totalAlokasiBiayaTetap,
            totalBiayaTenagaKerja: totalBiayaTenagaKerja,
            biayaTenagaKerja: biayaTenagaKerja,
            listBahan: listBahan,
            listBiayaTetap: listBiayaTetap,
          ),
        ),
      );
    }
  }
}

class _HelpDialogPainter extends CustomPainter {
  final Color primaryColor;

  _HelpDialogPainter(this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.2,
        size.width * 0.6,
        size.height * 0.25,
      )
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.3,
        size.width,
        size.height * 0.25,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
