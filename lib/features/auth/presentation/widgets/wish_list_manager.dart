class WishlistManager {
  static final WishlistManager _instance = WishlistManager._internal();
  factory WishlistManager() => _instance;
  WishlistManager._internal();

  final List<String> _wishlistItems = [];

  List<String> get wishlistItems => _wishlistItems;

  void addItem(String item) {
    if (item.isNotEmpty && !_wishlistItems.contains(item)) {
      _wishlistItems.add(item);
    }
  }

  void removeItem(String item) {
    _wishlistItems.remove(item);
  }
}