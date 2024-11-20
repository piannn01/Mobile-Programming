import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.circle, color: Colors.purple, size: 28),
            const SizedBox(width: 8),
            Text(
              "iJASA",
              style: TextStyle(
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.message, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_cart, color: Colors.white),
          ),
          // ICON BUTTON HALAMAN PROFILE
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            icon: Icon(Icons.account_circle, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white10,
                hintText: "Apa yang dibutuhkan?",
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            // Title Section
            Text(
              "Kebutuhan Teratas",
              style: TextStyle(
                color: Colors.pinkAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Product Grid (Untuk List Produk dengan metode grid)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigasi ke detail produk
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(product: product),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10)),
                              child: Image.network(
                                product['image'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['title'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Rp ${product['price']},00",
                                  style: TextStyle(
                                    color: Colors.white70,
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman Detail Produk
class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        title: Text(
          "iJASA",
          style: TextStyle(
            color: Colors.pinkAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_cart, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1E1E2C),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar Produk
            Expanded(
              child: Image.network(
                product['image'],
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            // Nama Produk
            Text(
              product['title'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Harga Produk
            Text(
              "Rp ${product['price']}",
              style: TextStyle(
                color: Colors.pinkAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Deskripsi
            Text(
              "Jaminan Internet wifi tercepat tiada banding,Segera gunakanlah Jasa kami, Wifi Irmas.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Tombol Check Out
            ElevatedButton(
              onPressed: () {
                // Tambahkan aksi checkout di sini
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Checkout berhasil!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Check Out",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman Profil
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        title: Text(
          "Profil",
          style: TextStyle(color: Colors.pinkAccent),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/images/fani.jpg'), // Ganti sesuai gambar profil
                ),
                const SizedBox(height: 8),
                Text(
                  "M.FANI ANDRIANSAH",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "PROFIL",
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white54, height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMenuItem(
                    "Alamat", "Mancilan,Mojoagung", Icons.location_on),
                _buildMenuItem(
                    "Rekening Bank", "009898213", Icons.account_balance),
                _buildMenuItem("Pembayaran Instan", "E-Wallet, Kartu kredit",
                    Icons.payment),
                _buildMenuItem("Keamanan Akun",
                    "Kata sandi, PIN, & Verifikasi data diri", Icons.lock),
                _buildMenuItem("Notifikasi", "Atur notifikasi aplikasi",
                    Icons.notifications),
                _buildMenuItem("Privasi Akun", "Atur penggunaan data pribadi",
                    Icons.privacy_tip),
                _buildMenuItem("Log out", "", Icons.logout),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, String subtitle, IconData icon) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.purple),
          title: Text(title, style: TextStyle(color: Colors.white)),
          subtitle: subtitle.isNotEmpty
              ? Text(subtitle, style: TextStyle(color: Colors.white70))
              : null,
          onTap: () {
            // Tambahkan navigasi jika diperlukan
          },
        ),
        const Divider(color: Colors.white24),
      ],
    );
  }
}

// Data Produk
final List<Map<String, dynamic>> products = [
  {
    'title': 'Tukang WIFI',
    'price': '35.000',
    'image': 'assets/images/tukang wifi.jpeg',
  },
  {
    'title': 'Asisten Rumah Tangga',
    'price': '20.000',
    'image': 'assets/images/asisten-rumah-tangga.jpg',
  },
  {
    'title': 'Tukang Kebun',
    'price': '25.000',
    'image': 'assets/images/tukang kebun.jpeg',
  },
  {
    'title': 'Tukang Masak',
    'price': '30.000',
    'image': 'assets/images/tukang masak.jpeg',
  },
  {
    'title': 'Laundry Cuci Bersih',
    'price': '10.000',
    'image': 'assets/images/loundry.jpg',
  },
];
