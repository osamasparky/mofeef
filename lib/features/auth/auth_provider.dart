import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? userName;
  final String? userEmail;
  final String? errorMessage;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.userName,
    this.userEmail,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? userName,
    String? userEmail,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 800)); // Smooth UX

    // Save token and authenticate
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: 'auth_token', value: 'mock_token_modeef_123');

    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      userName: 'مسافر مُضيف',
      userEmail: email,
    );
    return true;
  }

  Future<void> logout() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: 'auth_token');
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
