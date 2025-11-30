import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 安全存储服务，用于加密存储 Notion API Token
/// 
/// 使用 flutter_secure_storage 在平台密钥库中安全存储敏感数据
class SecureTokenStorage {
  static const _storage = FlutterSecureStorage(
    // iOS 选项：使用访问控制，需要设备解锁后才能访问
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    // macOS 选项：使用钥匙串访问控制
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _tokenKey = 'notion_api_token';

  /// 保存 Token 到安全存储
  Future<void> saveToken(String token) async {
    if (token.isEmpty) {
      await deleteToken();
      return;
    }
    await _storage.write(key: _tokenKey, value: token);
  }

  /// 从安全存储读取 Token
  /// 如果不存在则返回 null
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// 删除 Token（登出时使用）
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// 检查 Token 是否存在
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

/// 全局单例实例
final secureTokenStorage = SecureTokenStorage();


