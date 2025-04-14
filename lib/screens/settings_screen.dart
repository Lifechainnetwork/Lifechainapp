import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../widgets/custom_card.dart';
import '../providers/language_provider.dart';
import '../providers/currency_provider.dart';
import 'profile_edit_screen.dart';
import 'kyc_verification_screen.dart';
import 'two_factor_auth_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 24),
            _buildGeneralSettings(),
            const SizedBox(height: 24),
            _buildSecuritySettings(),
            const SizedBox(height: 24),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withAlpha(51), // 0.2 opacity is approximately 51 alpha
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User123456',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'user123@example.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppTheme.primaryColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileEditScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KYCVerificationScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.verified_user),
                  label: const Text('Verify KYC'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TwoFactorAuthScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.security),
                  label: const Text('Security'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'General',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Consumer<LanguageProvider>(
                builder: (context, languageProvider, child) {
                  return ListTile(
                    leading: const Icon(Icons.language, color: AppTheme.primaryColor),
                    title: const Text('Language'),
                    subtitle: Text(languageProvider.currentLanguage),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showLanguageSelector(languageProvider);
                    },
                  );
                },
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              Consumer<CurrencyProvider>(
                builder: (context, currencyProvider, child) {
                  return ListTile(
                    leading: const Icon(Icons.attach_money, color: AppTheme.primaryColor),
                    title: const Text('Currency'),
                    subtitle: Text(currencyProvider.currentCurrency),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showCurrencySelector(currencyProvider);
                    },
                  );
                },
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              SwitchListTile(
                secondary: const Icon(Icons.notifications, color: AppTheme.primaryColor),
                title: const Text('Notifications'),
                subtitle: const Text('Enable push notifications'),
                value: _notificationsEnabled,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return SwitchListTile(
                    secondary: Icon(
                      themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: AppTheme.primaryColor,
                    ),
                    title: const Text('Dark Mode'),
                    subtitle: Text(themeProvider.isDarkMode ? 'Dark theme enabled' : 'Light theme enabled'),
                    value: themeProvider.isDarkMode,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Security',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.lock, color: AppTheme.primaryColor),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showChangePasswordDialog();
                },
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              SwitchListTile(
                secondary: const Icon(Icons.fingerprint, color: AppTheme.primaryColor),
                title: const Text('Biometric Authentication'),
                subtitle: const Text('Use fingerprint or face ID'),
                value: _biometricEnabled,
                activeColor: AppTheme.primaryColor,
                onChanged: (value) {
                  setState(() {
                    _biometricEnabled = value;
                  });
                },
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              ListTile(
                leading: const Icon(Icons.security, color: AppTheme.primaryColor),
                title: const Text('Two-Factor Authentication'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TwoFactorAuthScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.info, color: AppTheme.primaryColor),
                title: const Text('App Version'),
                subtitle: const Text('1.0.0'),
                onTap: () {},
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              ListTile(
                leading: const Icon(Icons.description, color: AppTheme.primaryColor),
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              ListTile(
                leading: const Icon(Icons.privacy_tip, color: AppTheme.primaryColor),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              ListTile(
                leading: const Icon(Icons.help, color: AppTheme.primaryColor),
                title: const Text('Help & Support'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLanguageSelector(LanguageProvider languageProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1, color: AppTheme.dividerColor),
            Expanded(
              child: ListView(
                children: languageProvider.availableLanguages.map((language) {
                  return _buildLanguageOption(language, languageProvider);
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(String language, LanguageProvider languageProvider) {
    return ListTile(
      title: Text(language),
      trailing: languageProvider.currentLanguage == language
          ? const Icon(Icons.check, color: AppTheme.primaryColor)
          : null,
      onTap: () {
        languageProvider.setLanguage(language);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Language changed to $language')),
        );
      },
    );
  }
  
  void _showCurrencySelector(CurrencyProvider currencyProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Select Currency',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1, color: AppTheme.dividerColor),
            Expanded(
              child: ListView(
                children: currencyProvider.availableCurrencies.map((currency) {
                  return _buildCurrencyOption(currency, currencyProvider);
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCurrencyOption(String currency, CurrencyProvider currencyProvider) {
    return ListTile(
      leading: Text(
        currencyProvider.currencySymbols[currency] ?? '',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      title: Text(currency),
      trailing: currencyProvider.currentCurrency == currency
          ? const Icon(Icons.check, color: AppTheme.primaryColor)
          : null,
      onTap: () {
        currencyProvider.setCurrency(currency);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Currency changed to $currency')),
        );
      },
    );
  }
  
  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('Change Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  filled: true,
                  fillColor: AppTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  filled: true,
                  fillColor: AppTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  filled: true,
                  fillColor: AppTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text(
              'Change',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // Password change logic would go here
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password changed successfully')),
                );
              }
            },
          ),
        ],
      ),
    );
  }


}
