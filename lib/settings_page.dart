import 'package:flutter/material.dart';
import 'login.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailAlerts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Slate 900
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B), // Slate 800
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF334155).withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color(0xFF3B82F6), // Blue ring
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: const Color(0xFF334155),
                          backgroundImage: const NetworkImage(
                            '',
                          ),
                          // Fallback icon if image fails
                          onBackgroundImageError: (_, _) {},
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2563EB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mohamed Ali',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: 2023001234',
                        style: TextStyle(
                          color: const Color(0xFF94A3B8), // Slate 400
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Computer Science Dept.',
                        style: TextStyle(
                          color: Color(0xFF3B82F6), // Blue 500
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ACCOUNT Section
            _buildSectionHeader('ACCOUNT'),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF334155).withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  _buildListTile(
                    title: 'Change Password',
                    icon: Icons.lock_outline_rounded,
                    iconBgColor: const Color(0xFF1E3A8A), // Dark blue bg
                    iconColor: const Color(0xFF60A5FA), // Blue icon
                  ),
                  _buildDivider(),
                  _buildListTile(
                    title: 'Update Email',
                    icon: Icons.email_outlined,
                    iconBgColor: const Color(0xFF1E3A8A),
                    iconColor: const Color(0xFF60A5FA),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    title: 'My Complaints History',
                    icon: Icons.history_rounded,
                    iconBgColor: const Color(0xFF1E3A8A),
                    iconColor: const Color(0xFF60A5FA),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // PREFERENCES Section
            _buildSectionHeader('PREFERENCES'),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF334155).withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  _buildSwitchTile(
                    title: 'Push Notifications',
                    subtitle: 'Receive updates on your complaints',
                    icon: Icons.notifications_active_outlined,
                    iconBgColor: const Color(0xFF312E81), // Dark indigo
                    iconColor: const Color(0xFFA78BFA), // Light purple
                    value: _pushNotifications,
                    onChanged: (v) => setState(() => _pushNotifications = v),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: 'Email Alerts',
                    icon: Icons.alternate_email_rounded,
                    iconBgColor: const Color(0xFF312E81),
                    iconColor: const Color(0xFFA78BFA),
                    value: _emailAlerts,
                    onChanged: (v) => setState(() => _emailAlerts = v),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    title: 'Privacy Settings',
                    icon: Icons.security_outlined,
                    iconBgColor: const Color(0xFF064E3B), // Dark green
                    iconColor: const Color(0xFF34D399), // Emerald
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SUPPORT & INFO Section
            _buildSectionHeader('SUPPORT & INFO'),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF334155).withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  _buildListTile(
                    title: 'About Us',
                    icon: Icons.info_outline_rounded,
                    iconBgColor: const Color(0xFF431407), // Dark orange/brown
                    iconColor: const Color(0xFFFB923C), // Orange
                  ),
                  _buildDivider(),
                  _buildListTile(
                    title: 'Terms & Conditions',
                    icon: Icons.gavel_outlined,
                    iconBgColor: const Color(0xFF431407),
                    iconColor: const Color(0xFFFB923C),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    title: 'Help & Support',
                    icon: Icons.help_outline_rounded,
                    iconBgColor: const Color(0xFF431407),
                    iconColor: const Color(0xFFFB923C),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Log Out Button
            GestureDetector(
              onTap: () {
                // Navigate to Login and clear stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false,
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF334155).withValues(alpha: 0.5),
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFEF4444), // Red 500
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Color(0xFFEF4444),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Footer
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Version 1.0.2',
                    style: TextStyle(color: Color(0xFF475569), fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF94A3B8), // Slate 400
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF64748B),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF2563EB),
            inactiveThumbColor: const Color(0xFF94A3B8),
            inactiveTrackColor: const Color(0xFF334155),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFF334155),
      indent: 56, // Align with text start
    );
  }
}
