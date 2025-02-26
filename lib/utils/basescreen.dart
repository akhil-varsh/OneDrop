import 'package:donordash/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:donordash/services/auth_service.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final List<BottomNavItem>? bottomNavItems;
  final int? selectedIndex;
  final Function(int)? onNavItemTap;
  final List<DrawerItem>? drawerItems;
  final Widget? floatingActionButton;
  final AuthService authService;
  final bool showBackButton;

  const BaseScreen({
    Key? key,
    required this.title,
    required this.body,
    this.bottomNavItems,
    this.selectedIndex,
    this.onNavItemTap,
    this.drawerItems,
    this.floatingActionButton,
    required this.authService,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF5F6D),
              Color(0xFFFFC371),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    if (showBackButton)
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    if (drawerItems != null && !showBackButton)
                      IconButton(
                        icon: Icon(Icons.menu, color: Colors.white, size: 28),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: drawerItems != null ? TextAlign.left : TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.white, size: 28),
                      onPressed: () => _showLogoutDialog(context),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: body,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Custom Drawer
      drawer: drawerItems != null ? CustomDrawer(items: drawerItems!) : null,

      // Floating Action Button
      floatingActionButton: floatingActionButton,

      // Bottom Navigation Bar
      bottomNavigationBar: bottomNavItems != null ? Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            items: bottomNavItems!.map((item) => item.navItem).toList(),
            currentIndex: selectedIndex ?? 0,
            onTap: onNavItemTap,
            elevation: 0,
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFFFF5F6D),
            unselectedItemColor: Colors.grey.shade400,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ) : null,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext); // Close dialog
                await authService.signOut(); // Perform logout
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                ); // Redirect to login screen
              },
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final List<DrawerItem> items;

  const CustomDrawer({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF5F6D),
              Color(0xFFFFC371),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.volunteer_activism, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Text(
                      'OneDrop ❤️',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade50,
                        ),
                        child: ListTile(
                          leading: Icon(items[index].icon, color: Color(0xFFFF5F6D)),
                          title: Text(
                            items[index].title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF444444),
                            ),
                          ),
                          onTap: items[index].onTap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavItem {
  final BottomNavigationBarItem navItem;
  final Function() onTap;

  BottomNavItem({required this.navItem, required this.onTap});
}

class DrawerItem {
  final IconData icon;
  final String title;
  final Function() onTap;

  DrawerItem({required this.icon, required this.title, required this.onTap});
}
