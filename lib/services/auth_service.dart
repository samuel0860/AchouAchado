import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../data/remote/supabase_client.dart';
import '../models/user_model.dart';
import 'theme_service.dart' show getStorageFile;

export '../models/user_model.dart';

enum AuthStatus { idle, loading, authenticated, unauthenticated }

/// Autenticação do app.
///
/// Quando o Supabase está configurado (`--dart-define=SUPABASE_URL/ANON_KEY`,
/// ver achou_achado_api/supabase/README.md), login/cadastro/logout usam o
/// Supabase Auth de verdade — o registro cria a linha em `auth.users` e o
/// trigger `handle_new_user` cria o `profiles` (e `affiliates`/`affiliate_pages`
/// se for afiliado). Sem o Supabase configurado, cai no modo local antigo
/// (arquivo JSON no dispositivo), só para não quebrar o app.
class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  AuthStatus _status = AuthStatus.idle;
  UserModel? _currentUser;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _status == AuthStatus.authenticated;
  bool get isAffiliate => _currentUser?.isAffiliateUser ?? false;

  bool get _useSupabase => AppSupabase.isConfigured;

  // ─── Auth methods ─────────────────────────────────────────────────────────

  Future<void> init() async {
    if (_useSupabase) return _initSupabase();
    return _initLocal();
  }

  Future<bool> login(String email, String password) {
    if (_useSupabase) return _loginSupabase(email, password);
    return _loginLocal(email, password);
  }

  Future<bool> register(String name, String email, String password,
      {UserType userType = UserType.cliente}) {
    if (_useSupabase) return _registerSupabase(name, email, password, userType);
    return _registerLocal(name, email, password, userType);
  }

  Future<bool> forgotPassword(String email) {
    if (_useSupabase) return _forgotPasswordSupabase(email);
    return _forgotPasswordLocal(email);
  }

  Future<bool> resetPassword(String email, String newPassword) {
    if (_useSupabase) return _resetPasswordSupabase(newPassword);
    return _resetPasswordLocal(email, newPassword);
  }

  Future<void> updateProfile({
    String? name,
    String? bio,
    String? avatarColor,
  }) {
    if (_useSupabase) {
      return _updateProfileSupabase(name: name, bio: bio, avatarColor: avatarColor);
    }
    return _updateProfileLocal(name: name, bio: bio, avatarColor: avatarColor);
  }

  Future<void> logout() async {
    if (_useSupabase) {
      await AppSupabase.client.auth.signOut();
    } else {
      final data = await _load();
      data['isLoggedIn'] = false;
      data.remove('currentUser');
      await _save(data);
    }
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  // ─── Supabase ─────────────────────────────────────────────────────────────

  Future<void> _initSupabase() async {
    _status = AuthStatus.loading;
    notifyListeners();

    final user = AppSupabase.client.auth.currentUser;
    if (user != null) {
      await _loadProfileFromSupabase(user.id, user.email ?? '');
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> _loadProfileFromSupabase(String id, String email) async {
    try {
      final row = await AppSupabase.client
          .from('profiles')
          .select()
          .eq('id', id)
          .single();
      _currentUser = UserModel(
        id: id,
        name: row['name']?.toString() ?? '',
        email: email,
        isEmailVerified: true,
        isAffiliate: row['is_affiliate'] == true,
        userType: row['user_type'] == 'afiliado'
            ? UserType.afiliado
            : UserType.cliente,
        createdAt: DateTime.tryParse(row['created_at']?.toString() ?? '') ??
            DateTime.now(),
        bio: row['bio']?.toString(),
        avatarColor: row['avatar_color']?.toString() ?? '#7C3AED',
      );
      _status = AuthStatus.authenticated;
    } catch (e) {
      _errorMessage = 'Não foi possível carregar o perfil: $e';
      _status = AuthStatus.unauthenticated;
    }
  }

  Future<bool> _loginSupabase(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await AppSupabase.client.auth
          .signInWithPassword(email: email, password: password);
      final user = res.user;
      if (user == null) {
        _errorMessage = 'Credenciais inválidas.';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }
      await _loadProfileFromSupabase(user.id, user.email ?? email);
      notifyListeners();
      return _status == AuthStatus.authenticated;
    } on sb.AuthException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> _registerSupabase(
      String name, String email, String password, UserType userType) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await AppSupabase.client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'user_type': userType.name},
      );

      final user = res.user;
      if (user == null) {
        _errorMessage = 'Não foi possível criar a conta.';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }

      if (res.session == null) {
        // Projeto exige confirmação de e-mail antes do primeiro login.
        _errorMessage =
            'Cadastro criado! Confirme seu e-mail antes de entrar (verifique a caixa de entrada).';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }

      await _loadProfileFromSupabase(user.id, user.email ?? email);
      notifyListeners();
      return _status == AuthStatus.authenticated;
    } on sb.AuthException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> _forgotPasswordSupabase(String email) async {
    try {
      await AppSupabase.client.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      _errorMessage = 'Não foi possível enviar o e-mail de recuperação: $e';
      return false;
    }
  }

  Future<bool> _resetPasswordSupabase(String newPassword) async {
    try {
      await AppSupabase.client.auth
          .updateUser(sb.UserAttributes(password: newPassword));
      return true;
    } catch (e) {
      _errorMessage = 'Não foi possível redefinir a senha: $e';
      return false;
    }
  }

  Future<void> _updateProfileSupabase({
    String? name,
    String? bio,
    String? avatarColor,
  }) async {
    final id = _currentUser?.id;
    if (id == null) return;

    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (bio != null) updates['bio'] = bio;
    if (avatarColor != null) updates['avatar_color'] = avatarColor;

    if (updates.isNotEmpty) {
      await AppSupabase.client.from('profiles').update(updates).eq('id', id);
    }

    _currentUser = _currentUser?.copyWith(
      name: name,
      bio: bio,
      avatarColor: avatarColor,
    );
    notifyListeners();
  }

  // ─── Modo local (fallback sem Supabase configurado) ────────────────────────

  Future<File> _getFile() => getStorageFile('achados_auth.json');

  Future<Map<String, dynamic>> _load() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        return Map<String, dynamic>.from(
            jsonDecode(content) as Map<String, dynamic>);
      }
    } catch (_) {}
    return {};
  }

  Future<void> _save(Map<String, dynamic> data) async {
    try {
      final file = await _getFile();
      await file.writeAsString(jsonEncode(data));
    } catch (_) {}
  }

  Future<void> _initLocal() async {
    _status = AuthStatus.loading;
    notifyListeners();

    var data = await _load();

    // ── Seed test accounts ──────────────────────────────────────────────────
    final users = Map<String, dynamic>.from(
        (data['users'] as Map<String, dynamic>?) ?? {});

    users['teste@AchouAchado.com'] = {
      'password': '123456',
      'profile': UserModel(
        id: 'test-cliente-001',
        name: 'Usuário Teste',
        email: 'teste@AchouAchado.com',
        isEmailVerified: true,
        isAffiliate: false,
        userType: UserType.cliente,
        createdAt: DateTime(2024, 1, 1),
        bio: 'Amo encontrar as melhores ofertas!',
        avatarColor: '#10B981',
      ).toJson(),
    };

    users['afiliado@AchouAchado.com'] = {
      'password': '123456',
      'profile': UserModel(
        id: 'test-afiliado-001',
        name: 'Afiliado Teste',
        email: 'afiliado@AchouAchado.com',
        isEmailVerified: true,
        isAffiliate: true,
        userType: UserType.afiliado,
        createdAt: DateTime(2024, 1, 1),
        bio: 'Especialista em encontrar os melhores preços do Brasil.',
        avatarColor: '#D4AF37',
      ).toJson(),
    };

    data['users'] = users;
    await _save(data);
    // ─────────────────────────────────────────────────────────────────────────

    final isLoggedIn = data['isLoggedIn'] == true;
    final userJson = data['currentUser'];

    if (isLoggedIn && userJson != null) {
      try {
        _currentUser = UserModel.fromJson(userJson as Map<String, dynamic>);
        _status = AuthStatus.authenticated;
      } catch (_) {
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  Future<bool> _loginLocal(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    final data = await _load();
    final users = Map<String, dynamic>.from(
        (data['users'] as Map<String, dynamic>?) ?? {});

    if (!users.containsKey(email)) {
      _errorMessage = 'E-mail não cadastrado. Faça o cadastro primeiro.';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }

    final entry = users[email] as Map<String, dynamic>;
    if (entry['password'] != password) {
      _errorMessage = 'Senha incorreta. Tente novamente.';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }

    _currentUser = UserModel.fromJson(entry['profile'] as Map<String, dynamic>);
    data['isLoggedIn'] = true;
    data['currentUser'] = _currentUser!.toJson();
    await _save(data);

    _status = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }

  Future<bool> _registerLocal(
      String name, String email, String password, UserType userType) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    final data = await _load();
    final users = Map<String, dynamic>.from(
        (data['users'] as Map<String, dynamic>?) ?? {});

    if (users.containsKey(email)) {
      _errorMessage = 'Este e-mail já está cadastrado.';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }

    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    _currentUser = UserModel(
      id: userId,
      name: name,
      email: email,
      isEmailVerified: false,
      isAffiliate: userType == UserType.afiliado,
      userType: userType,
      createdAt: DateTime.now(),
      avatarColor: '#7C3AED',
    );

    users[email] = {
      'password': password,
      'profile': _currentUser!.toJson(),
    };
    data['users'] = users;
    data['isLoggedIn'] = true;
    data['currentUser'] = _currentUser!.toJson();
    await _save(data);

    _status = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }

  Future<bool> _forgotPasswordLocal(String email) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final data = await _load();
    final users = (data['users'] as Map<String, dynamic>?) ?? {};
    return users.containsKey(email);
  }

  Future<bool> _resetPasswordLocal(String email, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final data = await _load();
    final users = Map<String, dynamic>.from(
        (data['users'] as Map<String, dynamic>?) ?? {});
    if (users.containsKey(email)) {
      final entry =
          Map<String, dynamic>.from(users[email] as Map<String, dynamic>);
      entry['password'] = newPassword;
      users[email] = entry;
      data['users'] = users;
      await _save(data);
    }
    return true;
  }

  Future<void> _updateProfileLocal({
    String? name,
    String? bio,
    String? avatarColor,
  }) async {
    final email = _currentUser?.email ?? '';
    final data = await _load();
    final users = Map<String, dynamic>.from(
        (data['users'] as Map<String, dynamic>?) ?? {});

    if (users.containsKey(email)) {
      final entry =
          Map<String, dynamic>.from(users[email] as Map<String, dynamic>);
      final profile =
          Map<String, dynamic>.from(entry['profile'] as Map<String, dynamic>);
      if (name != null) profile['name'] = name;
      if (bio != null) profile['bio'] = bio;
      if (avatarColor != null) profile['avatarColor'] = avatarColor;
      entry['profile'] = profile;
      users[email] = entry;
      data['users'] = users;
    }

    _currentUser = _currentUser?.copyWith(
      name: name,
      bio: bio,
      avatarColor: avatarColor,
    );
    data['currentUser'] = _currentUser!.toJson();
    await _save(data);
    notifyListeners();
  }
}
