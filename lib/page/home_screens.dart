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

  final Color primaryColor = const Color(0xFF008B0B);
  final Color primaryLight = const Color(0xFFE8F5E9);
  final Color backgroundColor = const Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HPP Snap App',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildInfoProduk(),
              const SizedBox(height: 20),
              _buildBahanSection(),
              const SizedBox(height: 20),
              _buildBiayaTenagaKerjaSection(),
              const SizedBox(height: 20),
              _buildBiayaTetapSection(),
              const SizedBox(height: 30),
              _buildHitungButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoProduk() {
    return Card(
      elevation: 2,
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
      elevation: 2,
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.inventory_2, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'Belum ada bahan baku',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
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
          bahan.nama.isEmpty ? 'Bahan ${index + 1}' : bahan.nama,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${bahan.jumlahPakai} ${bahan.satuan} per produk',
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
          icon: Icon(Icons.more_vert, color: primaryColor),
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
                  Icon(Icons.edit, size: 20, color: Colors.blue,),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 20),
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
      text: bahanEdit.jumlahPakai.toString(),
    );
    TextEditingController satuanController = TextEditingController(
      text: bahanEdit.satuan,
    );
    TextEditingController totalHargaController = TextEditingController(
      text: bahanEdit.totalHarga.toString(),
    );
    TextEditingController jumlahBeliController = TextEditingController(
      text: bahanEdit.jumlahBeli.toString(),
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
            Icon(isEdit ? Icons.edit : Icons.post_add_rounded, color: primaryColor),
            const SizedBox(width: 8),
            Text(isEdit ? 'Edit Bahan Baku' : 'Tambah Bahan Baku'),
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
                  labelText: 'Total Harga Pembelian (Rp)',
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
            child: Text('Batal', style: TextStyle(color: primaryColor),),
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
    if (jumlahBeli > 0 && totalHarga > 0) {
      double biayaPerUnit = totalHarga / jumlahBeli;
      return biayaPerUnit * jumlahPakai;
    }
    return 0;
  }

  Widget _buildBiayaTenagaKerjaSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
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
      elevation: 2,
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.attach_money, size: 48, color: Colors.grey[400]),
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
          child: Icon(Icons.attach_money, color: primaryColor),
        ),
        title: Text(
          biaya.nama.isEmpty ? 'Biaya ${index + 1}' : biaya.nama,
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
          icon: Icon(Icons.more_vert, color: primaryColor),
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
                  Icon(Icons.edit, size: 20, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 20),
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
        : BiayaTetap(
            nama: '',
            totalBiaya: 0,
            alokasiPerProduk: 0,
          );

    TextEditingController namaController = TextEditingController(
      text: biayaEdit.nama,
    );
    TextEditingController totalBiayaController = TextEditingController(
      text: biayaEdit.totalBiaya.toString(),
    );
    TextEditingController alokasiController = TextEditingController(
      text: biayaEdit.alokasiPerProduk.toString(),
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
                Icon(isEdit ? Icons.edit : Icons.money, color: primaryColor),
                const SizedBox(width: 8),
                Text(isEdit ? 'Edit Biaya Tetap' : 'Tambah Biaya Tetap'),
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
                        saranAlokasi = _hitungSaranAlokasi(double.tryParse(value) ?? 0);
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: _hitungHPP,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.3),
        ),
        child: Text('Hitung HPP & Saran Harga'),
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
    if (target > 0) {
      return totalBiaya / target;
    }
    return 0;
  }

  String _formatCurrency(double value) {
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  void _hitungHPP() {
    if (_formKey.currentState!.validate()) {
      double totalBiayaBahan = listBahan.fold(
        0,
        (sum, bahan) => sum + bahan.biayaProduk,
      );

      double totalAlokasiBiayaTetap = listBiayaTetap.fold(
        0,
        (sum, biaya) => sum + biaya.alokasiPerProduk,
      );

      double totalBiayaTenagaKerja = biayaTenagaKerja?.biayaPerProduk ?? 0;

      double hpp = totalBiayaBahan + totalAlokasiBiayaTetap + totalBiayaTenagaKerja;

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
