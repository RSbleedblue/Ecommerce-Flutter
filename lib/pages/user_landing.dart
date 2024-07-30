import 'package:CredexEcom/pages/cart_page.dart';
import 'package:CredexEcom/pages/home_page.dart';
import 'package:CredexEcom/pages/profile_page.dart';
import 'package:CredexEcom/pages/search_page.dart';
import 'package:CredexEcom/utils/cart_icon.dart';
import 'package:CredexEcom/utils/language_change.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserLanding extends StatefulWidget {
  const UserLanding({super.key});

  @override
  _UserLandingState createState() => _UserLandingState();
}

class _UserLandingState extends State<UserLanding> {
  String? _email;
  String? _profileImageUrl;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email');
      _profileImageUrl = prefs.getString('image');
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    final languageProvider = Provider.of<LanguageChange>(context);
    final locale = languageProvider.appLocale ?? Locale('en');

    switch (_selectedIndex) {
      case 0:
        return AppBar(
          backgroundColor: const Color.fromARGB(255, 91, 0, 0),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                const Icon(Icons.explore, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.explore,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          actions: [
            _buildLanguageDropdown(context),
          ],
        );
      case 1:
        return AppBar(
          backgroundColor: const Color.fromARGB(255, 91, 0, 0),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.search,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          actions: [
            _buildLanguageDropdown(context),
          ],
        );
      case 2:
        return AppBar(
          backgroundColor: const Color.fromARGB(255, 91, 0, 0),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                const Icon(Icons.shopping_bag, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.cart,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          actions: [
            _buildLanguageDropdown(context),
          ],
        );
      case 3:
        return AppBar(
          backgroundColor: const Color.fromARGB(255, 91, 0, 0),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                const Icon(Icons.account_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.profile,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          actions: [
            _buildLanguageDropdown(context),
          ],
        );
      default:
        return AppBar();
    }
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageChange>(context, listen: false);

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language, color: Colors.white),
      onSelected: (locale) {
        languageProvider.changeLanguage(locale);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
        const PopupMenuItem(
          value: Locale('es'),
          child: Text('Español'),
        ),
        const PopupMenuItem(
          value: Locale('ja'),
          child: Text('日本語'),
        ),
        const PopupMenuItem(
          value: Locale('fr'),
          child: Text('Français'),
        ),
        const PopupMenuItem(
          value: Locale('de'),
          child: Text('Deutsch'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: Drawer(
        shadowColor: Colors.white,
        width: 180,
        child: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: const Text(" "),
                accountEmail: Text(_email ?? 'No email found'),
                currentAccountPicture: _profileImageUrl != null
                    ? CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: _profileImageUrl!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(
                              color: Color(0xFF5B0000),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          "U",
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 91, 0, 0),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home,
                    color: Color.fromARGB(255, 91, 0, 0)),
                title: Text(localizations.home,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 39, 39, 39), fontSize: 14)),
                onTap: () {
                  Navigator.of(context).pop();
                  _onItemTapped(0);
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag,
                    color: Color.fromARGB(255, 91, 0, 0)),
                title: Text(localizations.cart,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 39, 39, 39), fontSize: 14)),
                onTap: () {
                  Navigator.of(context).pop();
                  _onItemTapped(2);
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle,
                    color: Color.fromARGB(255, 91, 0, 0)),
                title: Text(localizations.profile,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 39, 39, 39), fontSize: 14)),
                onTap: () {
                  Navigator.of(context).pop();
                  _onItemTapped(3);
                },
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout,
                    color: Color.fromARGB(255, 39, 39, 39)),
                title: Text(localizations.logOut,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 39, 39, 39), fontSize: 14)),
                onTap: () {
                  Navigator.of(context).pop();
                  _logout();
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 91, 0, 0),
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: localizations.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: localizations.search,
          ),
          BottomNavigationBarItem(
            icon: CartIcon(),
            label: localizations.cart,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle),
            label: localizations.profile,
          ),
        ],
      ),
    );
  }
}
