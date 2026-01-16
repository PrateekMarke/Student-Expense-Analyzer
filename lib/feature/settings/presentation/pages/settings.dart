import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_expense_analyzer/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:student_expense_analyzer/feature/auth/presentation/bloc/auth_event.dart';
import 'package:student_expense_analyzer/feature/auth/presentation/bloc/auth_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
 
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        body: Column(
          children: [
            _buildProfileHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _sectionLabel("Account"),
                  _buildSettingTile(
                    icon: Icons.person_outline,
                    title: "Profile Settings",
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    icon: Icons.lock_outline,
                    title: "Privacy & Security",
                    onTap: () {},
                  ),
                  _buildSwitchTile(
                    icon: Icons.notifications_none_outlined,
                    title: "Notifications",
                    value: true,
                    onChanged: (val) {},
                  ),
                  const SizedBox(height: 10),
                  _sectionLabel("Data & Sync"),
                  _buildSwitchTile(
                    icon: Icons.chat_bubble_outline,
                    title: "SMS Access",
                    value: true,
                    onChanged: (val) {},
                  ),
                  _buildSwitchTile(
                    icon: Icons.sync,
                    title: "Auto Sync",
                    value: true,
                    onChanged: (val) {},
                  ),
                  _buildSwitchTile(
                    icon: Icons.stay_current_portrait,
                    title: "Offline Mode",
                    value: false,
                    onChanged: (val) {},
                  ),
                  const SizedBox(height: 10),
                  _sectionLabel("Preferences"),
            
                  _buildSettingTile(
                    icon: Icons.logout,
                    title: "Log Out",
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () => _showLogoutDialog(context),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              parentContext.read<AuthBloc>().add(AuthLogoutRequested());
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }



  Widget _buildProfileHeader(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = "Guest User";
        String email = "Sign in to sync data";
        String initials = "GU";

        if (state is AuthSuccess) {
          name = "${state.user.firstName} ${state.user.lastName}";
          email = state.user.email;
          initials = "${state.user.firstName[0]}${state.user.lastName[0]}"
              .toUpperCase();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
          decoration: const BoxDecoration(color: Color(0xFF6200EE)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Settings",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.orange,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: Colors.white70),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF6200EE),
    Color textColor = Colors.black87,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      color: Colors.white,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      color: Colors.white,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.sync, color: Color(0xFF6200EE), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF6200EE),
        ),
      ),
    );
  }
}
