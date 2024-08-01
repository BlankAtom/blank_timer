class AppState {
  // Add your state variables here

  // Singleton instance
  static final AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal();

  // Add your state methods here
}