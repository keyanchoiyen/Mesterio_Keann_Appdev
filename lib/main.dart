import 'package:flutter/material.dart';

import 'database/database_helper.dart';
import 'models/item.dart';
import 'screens/add_item_screen.dart';
import 'screens/home_screen.dart';
import 'screens/item_details_screen.dart';
import 'screens/my_reports_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CampusLostFoundApp());
}

class CampusLostFoundApp extends StatelessWidget {
  const CampusLostFoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Lost & Found',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool showSplash = true;
  bool isLoading = true;
  int currentIndex = 0;
  List<Item> items = [];
  String? loadError;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final savedItems = await DatabaseHelper.instance.getAllItems();
      if (!mounted) return;
      setState(() {
        items = savedItems;
        isLoading = false;
        loadError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        loadError = error.toString();
      });
    }
  }

  void _showMessage(String message, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? AppTheme.primaryOrange : Colors.red.shade700,
      ),
    );
  }

  void openDetails(Item item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ItemDetailsScreen(
          item: item,
          onEdit: (selected) {
            Navigator.of(context).pop();
            openAddEdit(selected);
          },
          onDelete: (selected) => _deleteItem(selected),
          onStatusChanged: (selected) => _updateStatus(selected),
        ),
      ),
    );
  }

  Future<void> _deleteItem(Item item) async {
    if (item.id == null) return;
    try {
      await DatabaseHelper.instance.deleteItem(item.id!);
      await _loadItems();
      if (mounted) {
        _showMessage('${item.itemName} deleted successfully.');
      }
    } catch (error) {
      if (mounted) _showMessage('Could not delete the item.', success: false);
    }
  }

  Future<void> _updateStatus(Item item) async {
    if (item.id == null) return;
    try {
      await DatabaseHelper.instance.updateItem(item);
      await _loadItems();
      if (mounted) _showMessage('Status updated to ${item.status}.');
    } catch (error) {
      if (mounted) _showMessage('Could not update the status.', success: false);
    }
  }

  void openAdd([String type = 'Lost']) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddItemScreen(
          initialType: type,
          onSave: (item) => _saveNewItem(item),
        ),
      ),
    );
  }

  void openAddEdit(Item item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddItemScreen(
          item: item,
          onSave: (updated) => _saveExistingItem(updated),
        ),
      ),
    );
  }

  Future<void> _saveNewItem(Item item) async {
    try {
      await DatabaseHelper.instance.insertItem(item);
      await _loadItems();
      if (!mounted) return;
      setState(() => currentIndex = 0);
      _showMessage('${item.itemName} saved successfully.');
    } catch (error) {
      if (mounted) {
        _showMessage(
          'Could not save the item. Please try again.',
          success: false,
        );
      }
      rethrow;
    }
  }

  Future<void> _saveExistingItem(Item item) async {
    try {
      await DatabaseHelper.instance.updateItem(item);
      await _loadItems();
      if (!mounted) return;
      _showMessage('${item.itemName} updated successfully.');
    } catch (error) {
      if (mounted) {
        _showMessage(
          'Could not update the item. Please try again.',
          success: false,
        );
      }
      rethrow;
    }
  }

  Future<void> _deleteFromReports(Item item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete report?'),
        content: Text('Delete ${item.itemName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) await _deleteItem(item);
  }

  @override
  Widget build(BuildContext context) {
    if (showSplash) {
      return SplashScreen(onFinished: () => setState(() => showSplash = false));
    }

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (loadError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                const Text('Could not load saved reports.'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _loadItems,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final screens = <Widget>[
      HomeScreen(items: items, onOpenItem: openDetails, onAddItem: openAdd),
      SearchScreen(items: items, onOpenItem: openDetails),
      const SizedBox.shrink(),
      MyReportsScreen(
        items: items,
        onOpenItem: openDetails,
        onAddItem: () => openAdd(),
        onEdit: openAddEdit,
        onDelete: _deleteFromReports,
      ),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          if (index == 2) {
            openAdd();
          } else {
            setState(() => currentIndex = index);
          }
        },
        backgroundColor: AppTheme.white,
        indicatorColor: AppTheme.lightYellow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(Icons.add_circle_rounded),
            label: 'Add Item',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded),
            label: 'My Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
