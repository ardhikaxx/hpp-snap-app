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

  List<Bahan> listBahan = [
    Bahan(
      nama: '',
      jumlahPakai: 0,
      satuan: 'pcs',
      totalHarga: 0,
      jumlahBeli: 0,
      satuanBeli: 'pcs',
      biayaProduk: 0,
    ),
  ];

  List<BiayaTetap> listBiayaTetap = [
    BiayaTetap(nama: '', totalBiaya: 0, alokasiPerProduk: 0),
  ];

  BiayaTenagaKerja? biayaTenagaKerja;
  bool showBiayaTenagaKerja = false;

  // Warna tema
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
      elevation: 4,
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
                  borderSide: BorderSide(color: Colors.grey.shade100),
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
                  borderSide: BorderSide(color: Colors.grey.shade100),
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
      elevation: 4,
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
                    onPressed: _tambahBahan,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...listBahan.asMap().entries.map((entry) {
              int index = entry.key;
              Bahan bahan = entry.value;
              return _buildBahanItem(index, bahan);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBahanItem(int index, Bahan bahan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          if (index > 0)
            Divider(color: primaryColor.withOpacity(0.3), height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: bahan.nama,
                  decoration: InputDecoration(
                    labelText: 'Nama Bahan',
                    labelStyle: TextStyle(color: Colors.grey[500]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(18),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: primaryLight,
                  ),
                  onChanged: (value) {
                    setState(() {
                      listBahan[index].nama = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  initialValue: bahan.jumlahPakai.toString(),
                  decoration: InputDecoration(
                    labelText: 'Jumlah',
                    labelStyle: TextStyle(color: Colors.grey[500]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(18),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: primaryLight,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      listBahan[index].jumlahPakai =
                          double.tryParse(value) ?? 0;
                      _hitungBiayaProdukBahan(index);
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  initialValue: bahan.satuan,
                  decoration: InputDecoration(
                    labelText: 'Satuan',
                    labelStyle: TextStyle(color: Colors.grey[500]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(18),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: primaryLight,
                  ),
                  onChanged: (value) {
                    setState(() {
                      listBahan[index].satuan = value;
                    });
                  },
                ),
              ),
              if (index > 0)
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red.shade600),
                  onPressed: () => _hapusBahan(index),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Info Pembelian Bahan',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: bahan.totalHarga.toString(),
                  decoration: InputDecoration(
                    labelText: 'Total Harga (Rp)',
                    labelStyle: TextStyle(color: Colors.grey[500]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(18),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: primaryLight,
                    prefixText: 'Rp ',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      listBahan[index].totalHarga = double.tryParse(value) ?? 0;
                      _hitungBiayaProdukBahan(index);
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  initialValue: bahan.jumlahBeli.toString(),
                  decoration: InputDecoration(
                    labelText: 'Jumlah Beli',
                    labelStyle: TextStyle(color: Colors.grey[500]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(18),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: primaryLight,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      listBahan[index].jumlahBeli = double.tryParse(value) ?? 0;
                      _hitungBiayaProdukBahan(index);
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  initialValue: bahan.satuanBeli,
                  decoration: InputDecoration(
                    labelText: 'Satuan',
                    labelStyle: TextStyle(color: Colors.grey[500]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(18),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: primaryLight,
                  ),
                  onChanged: (value) {
                    setState(() {
                      listBahan[index].satuanBeli = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            enabled: false,
            initialValue:
                'Biaya Produk: Rp ${_formatCurrency(bahan.biayaProduk)}',
            decoration: InputDecoration(
              labelText: 'Biaya Produk (Otomatis)',
              labelStyle: TextStyle(color: Colors.grey[500]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              filled: true,
              fillColor: primaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiayaTenagaKerjaSection() {
    return Card(
      elevation: 4,
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
                    borderSide: BorderSide(color: Colors.grey.shade100),
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
                    borderSide: BorderSide(color: Colors.grey.shade100),
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
      elevation: 4,
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
                  'Alokasi Biaya Tetap per Produk',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  borderSide: BorderSide(color: Colors.grey.shade100),
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
              return _buildBiayaTetapItem(index, biaya);
            }).toList(),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.add, color: Colors.white),
                label: const Text('Tambah Biaya'),
                onPressed: _tambahBiayaTetap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiayaTetapItem(int index, BiayaTetap biaya) {
    double saranAlokasi = _hitungSaranAlokasi(biaya.totalBiaya);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          if (index > 0)
            Divider(color: primaryColor.withOpacity(0.3), height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: biaya.nama,
                  decoration: InputDecoration(
                    labelText: 'Nama Biaya',
                    labelStyle: TextStyle(color: Colors.grey[500]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(18),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: primaryLight,
                  ),
                  onChanged: (value) {
                    setState(() {
                      listBiayaTetap[index].nama = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  initialValue: biaya.totalBiaya.toString(),
                  decoration: InputDecoration(
                    labelText: 'Total Biaya (Rp/Bulan)',
                    labelStyle: TextStyle(color: Colors.grey[500]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(18),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: primaryLight,
                    prefixText: 'Rp ',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      listBiayaTetap[index].totalBiaya =
                          double.tryParse(value) ?? 0;
                      _updateSaranAlokasi();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: biaya.alokasiPerProduk.toString(),
            decoration: InputDecoration(
              labelText: 'Alokasi per Produk (Rp)',
              labelStyle: TextStyle(color: Colors.grey[500]),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: Colors.grey.shade100),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:  BorderRadius.circular(18),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              filled: true,
              fillColor: primaryLight,
              prefixText: 'Rp ',
              helperText: 'Saran: Rp ${_formatCurrency(saranAlokasi)}',
              helperStyle: TextStyle(color: primaryColor),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                listBiayaTetap[index].alokasiPerProduk =
                    double.tryParse(value) ?? 0;
              });
            },
          ),
          if (index > 0)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: Icon(Icons.delete, size: 18),
                onPressed: () => _hapusBiayaTetap(index),
                label: const Text('Hapus'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red.shade600,
                ),
              ),
            ),
        ],
      ),
    );
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
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.3),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calculate, size: 24),
            SizedBox(width: 12),
            Text('Hitung HPP & Saran Harga'),
          ],
        ),
      ),
    );
  }

  void _tambahBahan() {
    setState(() {
      listBahan.add(
        Bahan(
          nama: '',
          jumlahPakai: 0,
          satuan: 'pcs',
          totalHarga: 0,
          jumlahBeli: 0,
          satuanBeli: 'pcs',
          biayaProduk: 0,
        ),
      );
    });
  }

  void _hapusBahan(int index) {
    setState(() {
      listBahan.removeAt(index);
    });
  }

  void _tambahBiayaTetap() {
    setState(() {
      listBiayaTetap.add(
        BiayaTetap(nama: '', totalBiaya: 0, alokasiPerProduk: 0),
      );
    });
  }

  void _hapusBiayaTetap(int index) {
    setState(() {
      listBiayaTetap.removeAt(index);
    });
  }

  void _hitungBiayaProdukBahan(int index) {
    Bahan bahan = listBahan[index];
    if (bahan.jumlahBeli > 0 && bahan.totalHarga > 0) {
      double biayaPerUnit = bahan.totalHarga / bahan.jumlahBeli;
      double biayaProduk = biayaPerUnit * bahan.jumlahPakai;
      setState(() {
        listBahan[index].biayaProduk = biayaProduk;
      });
    }
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
      // Hitung total biaya bahan
      double totalBiayaBahan = listBahan.fold(
        0,
        (sum, bahan) => sum + bahan.biayaProduk,
      );

      // Hitung total alokasi biaya tetap
      double totalAlokasiBiayaTetap = listBiayaTetap.fold(
        0,
        (sum, biaya) => sum + biaya.alokasiPerProduk,
      );

      // Hitung biaya tenaga kerja
      double totalBiayaTenagaKerja = biayaTenagaKerja?.biayaPerProduk ?? 0;

      // Hitung HPP
      double hpp =
          totalBiayaBahan + totalAlokasiBiayaTetap + totalBiayaTenagaKerja;

      // Navigasi ke hasil
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
