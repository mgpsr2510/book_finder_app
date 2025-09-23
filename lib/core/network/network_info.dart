abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // For simplicity, we'll assume network is always available
    // In a real app, you'd check actual network connectivity
    return true;
  }
}

