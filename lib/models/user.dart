import 'subscription.dart';

class User {
  final String username;
  final String email;
  final String phone;
  final String password;
  final List<Subscription> subscriptionHistory;
  final PremiumPlan? activePlan;

  User({
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    this.subscriptionHistory = const [],
    this.activePlan,
  });

  /// Stable id for keying; email is unique per user.
  String get id => email;

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
        'subscriptionHistory':
            subscriptionHistory.map((e) => e.toJson()).toList(),
        if (activePlan != null) 'activePlan': activePlan!.index,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    final historyRaw = json['subscriptionHistory'];
    List<Subscription> history = [];
    if (historyRaw is List) {
      history = historyRaw
          .map((e) => Subscription.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    final activePlanRaw = json['activePlan'];
    PremiumPlan? active =
        activePlanRaw != null && activePlanRaw is int && activePlanRaw >= 0 && activePlanRaw < PremiumPlan.values.length
            ? PremiumPlan.values[activePlanRaw]
            : null;
    return User(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      subscriptionHistory: history,
      activePlan: active,
    );
  }

  /// Copy with new subscription history and/or active plan (for updatePack).
  User copyWith({
    String? username,
    String? email,
    String? phone,
    String? password,
    List<Subscription>? subscriptionHistory,
    PremiumPlan? activePlan,
  }) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      subscriptionHistory: subscriptionHistory ?? this.subscriptionHistory,
      activePlan: activePlan ?? this.activePlan,
    );
  }
}
