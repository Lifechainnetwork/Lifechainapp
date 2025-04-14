class ReferralData {
  final int directReferrals;
  final int indirectReferrals;
  final String referralCode;

  ReferralData({
    required this.directReferrals,
    required this.indirectReferrals,
    required this.referralCode,
  });

  static ReferralData demoData() {
    return ReferralData(
      directReferrals: 1,
      indirectReferrals: 0,
      referralCode: 'Hermes4789',
    );
  }
}
