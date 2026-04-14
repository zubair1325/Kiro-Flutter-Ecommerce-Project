//Template link: https://fluttertemplates.dev/widgets/must_haves/settings_page/

import 'package:ecommerce/presentation/controller/auth_controller.dart';
import 'package:ecommerce/presentation/controller/auth_wrapper.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/change_password_screen.dart';
import 'package:ecommerce/presentation/ui/screens/home/home_screen.dart';
import 'package:ecommerce/presentation/ui/screens/menu/about_us_page.dart';
import 'package:ecommerce/presentation/ui/screens/menu/admin/admin_home_screen.dart';
import 'package:ecommerce/presentation/ui/screens/menu/edit_profile_page.dart';
import 'package:ecommerce/presentation/ui/screens/menu/profile_page.dart';
import 'package:ecommerce/presentation/ui/screens/menu/seller/seller_dashboard_screen.dart';
import 'package:ecommerce/presentation/ui/screens/menu/terms_conditions.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class LoginState extends StatefulWidget {
  const LoginState({super.key});

  @override
  State<LoginState> createState() => _LoginStateState();
}

class _LoginStateState extends State<LoginState> {
  bool _isDark = false;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.offAll(HomeScreen()),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text("Settings"),
        ),
        body: FutureBuilder<List<Map<String, dynamic>?>>(
          future: Future.wait([
            AuthController.sellerInformation,
            AuthController.userInformation,
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            }

            final results = snapshot.data;
            final sellerData = results?[0];
            final userData = results?[1];

            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: ListView(
                  children: [
                    _SingleSection(
                      title: "General",
                      children: [
                        _CustomListTile(
                          title: "Dark Mode",
                          icon: Icons.dark_mode_outlined,
                          trailing: Switch(
                            value: _isDark,
                            onChanged: (value) {
                              setState(() {
                                _isDark = value;
                              });
                            },
                          ),
                        ),
                        const _CustomListTile(
                          title: "Notifications",
                          icon: Icons.notifications_none_rounded,
                        ),
                        _CustomListTile(
                          title: "My Orders",
                          icon: CupertinoIcons.cart,
                        ),
                        const _CustomListTile(
                          title: "Security Status",
                          icon: CupertinoIcons.lock_shield,
                        ),
                      ],
                    ),
                    const Divider(),
                    _SingleSection(
                      title: "Advance",
                      children: [
                        _CustomListTile(
                          title: "Profile",
                          icon: Icons.person_outline_rounded,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => ProfilePage(),
                            ),
                          ),
                        ),
                        _CustomListTile(
                          title: "Change Password",
                          icon: Icons.password_sharp,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => ChangePasswordScreen(),
                            ),
                          ),
                        ),

                        // Check if the data exists AND if the specific field is null
                        (sellerData == null ||
                                sellerData['user_auth_id'] == null)
                            ? _CustomListTile(
                                title: "Kiro Seller",
                                icon: Icons.shop,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) =>
                                        EditProfilePage(isKiroSeller: true),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        (sellerData == null ||
                                sellerData['user_auth_id'] == null)
                            ? const SizedBox.shrink()
                            : _CustomListTile(
                                title: "Seller",
                                icon: Icons.shop,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) =>
                                        SellerDashboardScreen(),
                                  ),
                                ),
                              ),

                        (userData != null && userData['is_admin'])
                            ? _CustomListTile(
                                title: "Admin",
                                icon: Icons.shop,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) => AdminHomeScreen(),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    const Divider(),
                    _SingleSection(
                      children: [
                        _CustomListTile(
                          title: "Help & Feedback",
                          icon: Icons.help_outline_rounded,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => TermsConditions(),
                            ),
                          ),
                        ),
                        _CustomListTile(
                          title: "About",
                          icon: Icons.info_outline_rounded,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => AboutUsPage(),
                            ),
                          ),
                        ),
                        _CustomListTile(
                          title: "Sign out",
                          icon: Icons.exit_to_app_rounded,
                          onTap: () async {
                            await AuthController.singOut();
                            Get.offAll(AuthWrapper());
                          },
                        ),
                        _CustomListTile(
                          title: "Delete Account",
                          icon: Icons.delete_forever,
                          onTap: () async {
                           // print(sellerData!['user_auth_id']);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _CustomListTile({
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(children: children),
      ],
    );
  }
}
