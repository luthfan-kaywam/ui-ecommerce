import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  Widget _buildProfileSection(BuildContext context) {
    final auth = context.auth;
    final name = auth.userName.isNotEmpty ? auth.userName : 'Abu Setiawan';
    final email = auth.userEmail.isNotEmpty ? auth.userEmail : 'abusetiawan@example.com';

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
                // Clear state & navigate cleanly to login
                context.cart.clearCart();
                context.auth.logout();

                Navigator.pop(dialogContext); // Close dialog

                // Wipe entire navigation stack and push /login
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: const Text('Ya, Logout', style: TextStyle(color: Colors.white)),
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile details coming soon')),
            );
          },
        ),
        _buildSettingItem(
          context: context,
          icon: Icons.shopping_bag_outlined,
          title: 'My Orders',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order history coming soon')),
            );
          },
        ),
        _buildSettingItem(
          context: context,
          icon: Icons.lock_outline,
          title: 'Change Password',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Change Password coming soon')),
            );
          },
        ),
        _buildSettingItem(
          context: context,
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notification settings coming soon')),
            );
          },
        ),
        _buildSettingItem(
          context: context,
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help & Support coming soon')),
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
        title: const Text('My Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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