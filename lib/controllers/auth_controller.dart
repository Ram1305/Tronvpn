import 'package:get/get.dart';

import '../helpers/my_dialogs.dart';
import '../helpers/pref.dart';
import '../models/subscription.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  /// Reactive current user so UI (e.g. Profile) updates when pack changes.
  final Rx<User?> currentUser = (Pref.currentUser).obs;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = Pref.currentUser;
  }

  /// Sends mock OTP to email. In production replace with API.
  Future<bool> sendOtp(String email) async {
    if (email.trim().isEmpty) {
      MyDialogs.error(msg: 'Enter email');
      return false;
    }
    Pref.lastOtpSentAt = DateTime.now();
    MyDialogs.success(msg: 'OTP sent to $email');
    return true;
  }

  /// Verifies OTP against mock code.
  bool verifyOtp(String code) {
    final ok = code.trim() == Pref.mockOtp;
    if (!ok) MyDialogs.error(msg: 'Invalid OTP');
    return ok;
  }

  /// Sign up new user and optionally add subscription for selected plan.
  Future<bool> signUp({
    required String username,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required bool otpVerified,
    PremiumPlan? selectedPlan,
  }) async {
    if (username.trim().isEmpty) {
      MyDialogs.error(msg: 'Enter username');
      return false;
    }
    if (email.trim().isEmpty) {
      MyDialogs.error(msg: 'Enter email');
      return false;
    }
    if (!otpVerified) {
      MyDialogs.error(msg: 'Verify email OTP first');
      return false;
    }
    if (phone.trim().isEmpty) {
      MyDialogs.error(msg: 'Enter mobile number');
      return false;
    }
    if (password.isEmpty) {
      MyDialogs.error(msg: 'Enter password');
      return false;
    }
    if (password != confirmPassword) {
      MyDialogs.error(msg: 'Passwords do not match');
      return false;
    }
    final existing = Pref.users.where((u) => u.email.toLowerCase() == email.trim().toLowerCase());
    if (existing.isNotEmpty) {
      MyDialogs.error(msg: 'Email already registered');
      return false;
    }
    final initialSubscription = selectedPlan != null
        ? [Subscription(plan: selectedPlan, date: DateTime.now())]
        : <Subscription>[];
    final user = User(
      username: username.trim(),
      email: email.trim().toLowerCase(),
      phone: phone.trim(),
      password: password,
      subscriptionHistory: initialSubscription,
      activePlan: selectedPlan,
    );
    final users = Pref.users;
    users.add(user);
    Pref.users = users;
    Pref.currentUser = user;
    currentUser.value = user;
    MyDialogs.success(msg: 'Account created');
    return true;
  }

  /// Login by email and password.
  Future<bool> login(String email, String password) async {
    if (email.trim().isEmpty) {
      MyDialogs.error(msg: 'Enter email');
      return false;
    }
    if (password.isEmpty) {
      MyDialogs.error(msg: 'Enter password');
      return false;
    }
    User? user;
    try {
      user = Pref.users.firstWhere(
        (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
      );
    } catch (_) {
      user = null;
    }
    if (user == null || user.password != password) {
      MyDialogs.error(msg: 'Invalid email or password');
      return false;
    }
    Pref.currentUser = user;
    currentUser.value = user;
    MyDialogs.success(msg: 'Logged in');
    return true;
  }

  /// Update current user's pack (add subscription and set active plan). Returns false if not logged in.
  Future<bool> updatePack(PremiumPlan plan) async {
    final u = Pref.currentUser;
    if (u == null) return false;
    final updatedHistory = List<Subscription>.from(u.subscriptionHistory)
      ..add(Subscription(plan: plan, date: DateTime.now()));
    final updatedUser = u.copyWith(
      subscriptionHistory: updatedHistory,
      activePlan: plan,
    );
    final users = Pref.users;
    final idx = users.indexWhere((e) => e.email == u.email);
    if (idx == -1) return false;
    users[idx] = updatedUser;
    Pref.users = users;
    Pref.currentUser = updatedUser;
    currentUser.value = updatedUser;
    final label = Subscription(plan: plan, date: DateTime.now()).planLabel;
    MyDialogs.success(msg: 'Plan updated to $label');
    return true;
  }

  /// Reset password after OTP verification.
  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (email.trim().isEmpty) {
      MyDialogs.error(msg: 'Enter email');
      return false;
    }
    if (!verifyOtp(otp)) return false;
    if (newPassword.isEmpty) {
      MyDialogs.error(msg: 'Enter new password');
      return false;
    }
    if (newPassword != confirmPassword) {
      MyDialogs.error(msg: 'Passwords do not match');
      return false;
    }
    final users = Pref.users;
    final idx = users.indexWhere((u) => u.email.toLowerCase() == email.trim().toLowerCase());
    if (idx == -1) {
      MyDialogs.error(msg: 'No account with this email');
      return false;
    }
    final u = users[idx];
    users[idx] = u.copyWith(password: newPassword);
    Pref.users = users;
    if (Pref.currentUser?.email.toLowerCase() == u.email.toLowerCase()) {
      Pref.currentUser = users[idx];
      currentUser.value = users[idx];
    }
    MyDialogs.success(msg: 'Password changed');
    return true;
  }

  void logout() {
    Pref.currentUser = null;
    currentUser.value = null;
  }
}
