import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  const TwoFactorAuthScreen({super.key});

  @override
  State<TwoFactorAuthScreen> createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  bool _twoFactorEnabled = false;
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  
  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-Factor Authentication'),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 24),
            if (!_twoFactorEnabled)
              _buildEnableSection()
            else
              _buildManageSection(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusCard() {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _twoFactorEnabled 
                ? Colors.green.withAlpha(51) // 0.2 opacity is approximately 51 alpha
                : Colors.grey.withAlpha(51), // 0.2 opacity is approximately 51 alpha
              shape: BoxShape.circle,
            ),
            child: Icon(
              _twoFactorEnabled ? Icons.verified_user : Icons.security,
              color: _twoFactorEnabled ? Colors.green : Colors.grey,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '2FA Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _twoFactorEnabled ? 'Enabled' : 'Disabled',
                  style: TextStyle(
                    fontSize: 14,
                    color: _twoFactorEnabled ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _twoFactorEnabled
                      ? 'Your account is protected with 2FA'
                      : 'Enable 2FA for enhanced security',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _twoFactorEnabled,
            activeColor: AppTheme.primaryColor,
            onChanged: (value) {
              if (value) {
                // Show enable confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppTheme.cardColor,
                    title: const Text('Enable 2FA'),
                    content: const Text(
                      'Two-factor authentication adds an extra layer of security to your account. Are you sure you want to enable it?'
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
                          'Enable',
                          style: TextStyle(color: AppTheme.primaryColor),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // Continue with 2FA setup
                        },
                      ),
                    ],
                  ),
                );
              } else {
                // Show disable confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppTheme.cardColor,
                    title: const Text('Disable 2FA'),
                    content: const Text(
                      'Disabling two-factor authentication will make your account less secure. Are you sure you want to continue?'
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
                          'Disable',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          setState(() {
                            _twoFactorEnabled = false;
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Two-factor authentication disabled')),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildEnableSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enable Two-Factor Authentication',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '1. Download an authenticator app',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We recommend Google Authenticator or Authy',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '2. Scan this QR code with the app',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.qr_code,
                      size: 150,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '3. Enter the 6-digit code from the app',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              _buildOTPFields(),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Verify and Enable',
                onPressed: () {
                  // Verify and enable 2FA
                  String otp = _otpControllers.map((controller) => controller.text).join();
                  
                  if (otp.length != 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid 6-digit code')),
                    );
                    return;
                  }
                  
                  // For demo purposes, any 6-digit code is accepted
                  setState(() {
                    _twoFactorEnabled = true;
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Two-factor authentication enabled successfully')),
                  );
                },
                width: double.infinity,
                height: 50,
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildManageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Manage Two-Factor Authentication',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recovery Codes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Save these codes in a secure place. You can use them to access your account if you lose your authenticator device.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.dividerColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    _buildRecoveryCode('ABCD-EFGH-1234'),
                    const SizedBox(height: 8),
                    _buildRecoveryCode('IJKL-MNOP-5678'),
                    const SizedBox(height: 8),
                    _buildRecoveryCode('QRST-UVWX-9012'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Copy Codes',
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(
                          text: 'ABCD-EFGH-1234\nIJKL-MNOP-5678\nQRST-UVWX-9012',
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Recovery codes copied to clipboard')),
                        );
                      },
                      height: 45,
                      color: AppTheme.cardColor,
                      textColor: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: 'Download',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Download functionality will be implemented')),
                        );
                      },
                      height: 45,
                      color: AppTheme.cardColor,
                      textColor: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Change Authenticator App',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'If you want to use a different authenticator app, you\'ll need to reconfigure 2FA.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Reset 2FA',
                onPressed: () {
                  // Show reset confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppTheme.cardColor,
                      title: const Text('Reset 2FA'),
                      content: const Text(
                        'This will disable your current 2FA setup. You\'ll need to set it up again. Continue?'
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
                            'Reset',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            setState(() {
                              _twoFactorEnabled = false;
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Two-factor authentication reset')),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
                width: double.infinity,
                height: 45,
                color: Colors.red.shade800,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildRecoveryCode(String code) {
    return Row(
      children: [
        Text(
          code,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(
            Icons.copy,
            size: 18,
            color: AppTheme.primaryColor,
          ),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: code));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Recovery code copied to clipboard')),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildOTPFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fieldWidth = (constraints.maxWidth - 50) / 6;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            6,
            (index) => SizedBox(
              width: fieldWidth,
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: AppTheme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    _focusNodes[index + 1].requestFocus();
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
