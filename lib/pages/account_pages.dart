import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  Widget _buildProfileSection(BuildContext context) {
    final auth = context.auth;
    final name = auth.userName.isNotEmpty ? auth.userName : 'Abu Setiawan';
    final email =
        auth.userEmail.isNotEmpty ? auth.userEmail : 'abusetiawan@example.com';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4C53A5), Color(0xFF6C72C9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color(0x334C53A5),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 39,
              backgroundColor: const Color(0xFFEDECF2),
              child: ClipOval(
                child: Image.asset(
                  'assets/web_dev.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFF4C53A5),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDanger ? Colors.red : const Color(0xFF4C53A5),
          size: 26,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDanger ? Colors.red : Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: isDanger ? Colors.red : Colors.grey.shade400,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Apakah Anda yakin ingin keluar dari akun Anda?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                context.cart.clearCart();
                context.auth.logout();

                Navigator.pop(dialogContext);

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: const Text('Ya, Logout',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      children: [
        _buildSettingItem(
          context: context,
          icon: Icons.person_outline,
          title: 'My Profile',
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              builder: (_) => const _EditProfileSheet(),
            );
          },
        ),
        _buildSettingItem(
          context: context,
          icon: Icons.shopping_bag_outlined,
          title: 'My Orders',
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              builder: (_) => const _MyOrdersSheet(),
            );
          },
        ),
        _buildSettingItem(
          context: context,
          icon: Icons.lock_outline,
          title: 'Change Password',
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              builder: (_) => const _ChangePasswordSheet(),
            );
          },
        ),
        _buildSettingItem(
          context: context,
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              builder: (_) => const _NotificationSettingsSheet(),
            );
          },
        ),
        _buildSettingItem(
          context: context,
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              builder: (_) => const _HelpSupportSheet(),
            );
          },
        ),
        const SizedBox(height: 10),
        _buildSettingItem(
          context: context,
          icon: Icons.logout,
          title: 'Logout',
          isDanger: true,
          onTap: () {
            _showLogoutDialog(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDFCF2),
      appBar: AppBar(
        title: const Text('My Account',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF4C53A5),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileSection(context),
            const SizedBox(height: 20),
            _buildSettingsSection(context),
          ],
        ),
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet();

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final auth = context.auth;
      _nameController = TextEditingController(
        text: auth.userName.isNotEmpty ? auth.userName : 'Abu Setiawan',
      );
      _emailController = TextEditingController(
        text: auth.userEmail.isNotEmpty
            ? auth.userEmail
            : 'abusetiawan@example.com',
      );
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.auth.updateProfile(
        name: _nameController.text,
        email: _emailController.text,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Profil berhasil diperbarui!'),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C53A5).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person,
                        color: Color(0xFF4C53A5), size: 28),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Edit Profil',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C53A5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon:
                      const Icon(Icons.person_outline, color: Color(0xFF4C53A5)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF4C53A5), width: 2),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon:
                      const Icon(Icons.email_outlined, color: Color(0xFF4C53A5)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF4C53A5), width: 2),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!val.contains('@')) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C53A5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveProfile,
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _savePassword() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Kata sandi berhasil diperbarui!'),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C53A5).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_outline,
                        color: Color(0xFF4C53A5), size: 28),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Ubah Kata Sandi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C53A5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _oldPassController,
                obscureText: _obscureOld,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi Saat Ini',
                  prefixIcon:
                      const Icon(Icons.lock, color: Color(0xFF4C53A5)),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureOld ? Icons.visibility_off : Icons.visibility),
                    onPressed: () =>
                        setState(() => _obscureOld = !_obscureOld),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF4C53A5), width: 2),
                  ),
                ),
                validator: (val) => val == null || val.isEmpty
                    ? 'Masukkan kata sandi saat ini'
                    : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _newPassController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi Baru',
                  prefixIcon: const Icon(Icons.lock_clock_outlined,
                      color: Color(0xFF4C53A5)),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureNew ? Icons.visibility_off : Icons.visibility),
                    onPressed: () =>
                        setState(() => _obscureNew = !_obscureNew),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF4C53A5), width: 2),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Masukkan kata sandi baru';
                  }
                  if (val.length < 6) return 'Kata sandi minimal 6 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _confirmPassController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Kata Sandi Baru',
                  prefixIcon:
                      const Icon(Icons.lock_reset, color: Color(0xFF4C53A5)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF4C53A5), width: 2),
                  ),
                ),
                validator: (val) {
                  if (val != _newPassController.text) {
                    return 'Konfirmasi kata sandi tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C53A5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _savePassword,
                  child: const Text(
                    'Simpan Kata Sandi',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyOrdersSheet extends StatefulWidget {
  const _MyOrdersSheet();

  @override
  State<_MyOrdersSheet> createState() => _MyOrdersSheetState();
}

class _MyOrdersSheetState extends State<_MyOrdersSheet> {
  String _selectedFilter = 'Semua';

  final List<Map<String, dynamic>> _mockOrders = [
    {
      'id': 'ORD-10293',
      'date': '24 Agt 2026',
      'items': 'Leather Bag, Running Shoes',
      'itemCount': 2,
      'price': 175.0,
      'status': 'Selesai',
      'statusColor': Colors.green,
    },
    {
      'id': 'ORD-10288',
      'date': '22 Agt 2026',
      'items': 'Smart Watch',
      'itemCount': 1,
      'price': 85.0,
      'status': 'Dalam Pengiriman',
      'statusColor': Colors.blue,
    },
    {
      'id': 'ORD-10254',
      'date': '15 Agt 2026',
      'items': 'Headphones, Casual Hoodie, Glow Serum',
      'itemCount': 3,
      'price': 142.0,
      'status': 'Selesai',
      'statusColor': Colors.green,
    },
    {
      'id': 'ORD-10210',
      'date': '30 Jul 2026',
      'items': 'Organic Salad',
      'itemCount': 1,
      'price': 18.0,
      'status': 'Dibatalkan',
      'statusColor': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _mockOrders.where((order) {
      if (_selectedFilter == 'Semua') return true;
      if (_selectedFilter == 'Berjalan') {
        return order['status'] == 'Dalam Pengiriman';
      }
      if (_selectedFilter == 'Selesai') {
        return order['status'] == 'Selesai';
      }
      return true;
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C53A5).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shopping_bag_outlined,
                        color: Color(0xFF4C53A5), size: 26),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Riwayat Pesanan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C53A5),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: ['Semua', 'Berjalan', 'Selesai'].map((filter) {
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  selectedColor: const Color(0xFF4C53A5),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF4C53A5),
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    }
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: filteredOrders.isEmpty
                ? const Center(
                    child: Text('Tidak ada pesanan ditemukan',
                        style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order['id'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF4C53A5),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (order['statusColor'] as Color)
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    order['status'],
                                    style: TextStyle(
                                      color: order['statusColor'],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tanggal: ${order['date']}',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600),
                            ),
                            const Divider(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.shopping_basket_outlined,
                                    size: 20, color: Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${order['items']} (${order['itemCount']} produk)',
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total: \$${(order['price'] as double).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4C53A5),
                                  ),
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF4C53A5),
                                    side: const BorderSide(
                                        color: Color(0xFF4C53A5)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Detail pesanan ${order['id']}'),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  child: const Text('Detail Pesanan'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _HelpSupportSheet extends StatefulWidget {
  const _HelpSupportSheet();

  @override
  State<_HelpSupportSheet> createState() => _HelpSupportSheetState();
}

class _HelpSupportSheetState extends State<_HelpSupportSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _contactFormKey = GlobalKey<FormState>();

  final List<Map<String, String>> _faqs = [
    {
      'question': 'Bagaimana cara melacak status pesanan saya?',
      'answer':
          'Anda dapat melihat status pengiriman di menu My Orders pada profil Anda. Jika pesanan sudah dikirim, Anda juga akan menerima nomor resi melalui email.',
    },
    {
      'question': 'Metode pembayaran apa saja yang diterima?',
      'answer':
          'Kami mendukung berbagai metode pembayaran termasuk Kartu Kredit/Debit, Transfer Bank (BCA, Mandiri, BNI, BRI), E-Wallet (GoPay, OVO, Dana, ShopeePay), serta Cash on Delivery (COD).',
    },
    {
      'question': 'Bagaimana prosedur pengembalian atau refund barang?',
      'answer':
          'Pengembalian barang dapat diajukan maksimal 14 hari kerja setelah pesanan diterima. Pastikan produk masih belum digunakan dan kemasan dalam kondisi asli.',
    },
    {
      'question': 'Berapa lama estimasi waktu pengiriman barang?',
      'answer':
          'Pengiriman reguler membutuhkan waktu 2-4 hari kerja untuk area Jawa dan 3-7 hari kerja untuk luar Jawa. Tersedia pilihan Pengiriman Ekspres (1 hari tiba).',
    },
    {
      'question': 'Bagaimana cara mengubah alamat pengiriman?',
      'answer':
          'Alamat pengiriman dapat diubah sebelum pesanan diproses oleh penjual. Silakan hubungi Customer Service segera jika butuh bantuan perubahan alamat.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitContactForm() {
    if (_contactFormKey.currentState!.validate()) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                    'Pesan Anda berhasil terkirim! Tim kami akan merespons via email.'),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C53A5).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.help_outline,
                        color: Color(0xFF4C53A5), size: 26),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Bantuan & Dukungan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C53A5),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF4C53A5),
            indicatorColor: const Color(0xFF4C53A5),
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Pertanyaan Umum (FAQ)'),
              Tab(text: 'Hubungi Kami'),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  itemCount: _faqs.length,
                  itemBuilder: (context, index) {
                    final faq = _faqs[index];
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        leading: const Icon(
                          Icons.question_answer_outlined,
                          color: Color(0xFF4C53A5),
                        ),
                        title: Text(
                          faq['question']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4C53A5),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Text(
                              faq['answer']!,
                              style: TextStyle(
                                  color: Colors.grey.shade700, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SingleChildScrollView(
                  child: Form(
                    key: _contactFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kirim Pesan ke Tim Support',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tim kami akan membalas pertanyaan Anda dalam 1x24 jam.',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _subjectController,
                          decoration: InputDecoration(
                            labelText: 'Subjek / Judul Masalah',
                            prefixIcon: const Icon(Icons.subject,
                                color: Color(0xFF4C53A5)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (val) => val == null || val.isEmpty
                              ? 'Masukkan subjek pesan'
                              : null,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _messageController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Detail Pesan / Pertanyaan',
                            alignLabelWithHint: true,
                            prefixIcon: const Icon(Icons.message_outlined,
                                color: Color(0xFF4C53A5)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (val) => val == null || val.isEmpty
                              ? 'Masukkan detail pesan'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4C53A5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _submitContactForm,
                            icon: const Icon(Icons.send, color: Colors.white),
                            label: const Text(
                              'Kirim Pesan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSettingsSheet extends StatefulWidget {
  const _NotificationSettingsSheet();

  @override
  State<_NotificationSettingsSheet> createState() =>
      _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState
    extends State<_NotificationSettingsSheet> {
  bool _orderUpdates = true;
  bool _promos = true;
  bool _recommendations = false;
  bool _emailNewsletter = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4C53A5).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_outlined,
                    color: Color(0xFF4C53A5), size: 28),
              ),
              const SizedBox(width: 12),
              const Text(
                'Pengaturan Notifikasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C53A5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SwitchListTile(
            activeThumbColor: const Color(0xFF4C53A5),
            title: const Text('Update Status Pesanan',
                style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle:
                const Text('Notifikasi langsung saat status pesanan berubah'),
            value: _orderUpdates,
            onChanged: (val) => setState(() => _orderUpdates = val),
          ),
          SwitchListTile(
            activeThumbColor: const Color(0xFF4C53A5),
            title: const Text('Promo & Diskon Eksklusif',
                style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle:
                const Text('Info kupon, flash sale, dan penawaran hemat'),
            value: _promos,
            onChanged: (val) => setState(() => _promos = val),
          ),
          SwitchListTile(
            activeThumbColor: const Color(0xFF4C53A5),
            title: const Text('Rekomendasi Produk',
                style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Saran produk sesuai minat belanja Anda'),
            value: _recommendations,
            onChanged: (val) => setState(() => _recommendations = val),
          ),
          SwitchListTile(
            activeThumbColor: const Color(0xFF4C53A5),
            title: const Text('Email Newsletter',
                style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle:
                const Text('Rangkuman mingguan dan tren terbaru via email'),
            value: _emailNewsletter,
            onChanged: (val) => setState(() => _emailNewsletter = val),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C53A5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Pengaturan notifikasi berhasil disimpan!'),
                      ],
                    ),
                    backgroundColor: Colors.green.shade700,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: const Text('Simpan Pengaturan',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}