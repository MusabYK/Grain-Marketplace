import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'register_page.dart';
import '../../farmer/pages/farmer_dashboard_screen.dart';
import '../../buyer/pages/buyer_dashboard_screen.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0.2), // Start slightly below
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Handle authenticated state: navigate to dashboard
        if (authProvider.status == AuthStatus.authenticated) {
          if (authProvider.currentUser?.userType == 'farmer') {
            return const FarmerDashboardScreen();
          } else if (authProvider.currentUser?.userType == 'buyer') {
            return const BuyerDashboardScreen();
          }
        }

        // Show a loading indicator while uninitialized or authenticating/registering
        if (authProvider.status == AuthStatus.uninitialized ||
            authProvider.status == AuthStatus.authenticating ||
            authProvider.status == AuthStatus.registering) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Otherwise, show the beautiful landing page
        return Scaffold(
          body: Stack(
            children: [
              // Background Image with Gradient Overlay
              Positioned.fill(
                child: Image.asset(
                  'assets/images/grain_field_bg.jpg', // Make sure you have this image in your assets!
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.9),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Content with Fade and Slide Animations
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 48.0,
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.end, // Align content to the bottom
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Dynamic and engaging welcome text
                        Text(
                          'Harvesting Opportunities, Growing Futures',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 36, // Larger font size for impact
                                height: 1.2,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Connect with farmers, traders, and buyers for seamless grain trading.',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 18,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 60), // More space before buttons
                        // Login Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(
                              double.infinity,
                              55,
                            ), // Taller button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                30,
                              ), // More rounded corners
                            ),
                            backgroundColor:
                                Colors.lightGreen[700], // Deeper green
                            foregroundColor: Colors.white,
                            elevation: 8, // Add subtle shadow
                            textStyle: const TextStyle(
                              fontSize: 20, // Larger text
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Login'),
                        ),
                        const SizedBox(height: 20),

                        // Register Button
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: BorderSide(
                              color: Colors.white.withOpacity(
                                0.8,
                              ), // White border
                              width: 2,
                            ),
                            foregroundColor: Colors.white, // White text
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Register'),
                        ),
                        const SizedBox(height: 150), // Padding from bottom
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'login_page.dart';
// import 'register_page.dart';
// import '../../farmer/pages/farmer_dashboard_screen.dart';
// import '../../buyer/pages/buyer_dashboard_screen.dart';
// import '../providers/auth_provider.dart';
//
// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});
//
//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }
//
// class _AuthScreenState extends State<AuthScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, authProvider, child) {
//         if (authProvider.status == AuthStatus.authenticated) {
//           if (authProvider.currentUser?.userType == 'farmer') {
//             return const FarmerDashboardScreen();
//           } else if (authProvider.currentUser?.userType == 'buyer') {
//             return const BuyerDashboardScreen();
//           }
//         }
//         // Show a loading indicator while uninitialized
//         if (authProvider.status == AuthStatus.uninitialized ||
//             authProvider.status == AuthStatus.authenticating ||
//             authProvider.status == AuthStatus.registering) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//         // Otherwise, show the auth choice
//         return Scaffold(
//           body: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Welcome to GrainMarketplace!',
//                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 30),
//                   Image.asset(
//                     'assets/images/grain_logo.jpg', // Add a logo image
//                     height: 200,
//                   ),
//                   const SizedBox(height: 40),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => const LoginPage(),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       backgroundColor: Theme.of(context).primaryColor,
//                       foregroundColor: Colors.white,
//                     ),
//                     child: const Text('Login', style: TextStyle(fontSize: 18)),
//                   ),
//                   const SizedBox(height: 20),
//                   OutlinedButton(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => const RegisterPage(),
//                         ),
//                       );
//                     },
//                     style: OutlinedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       side: BorderSide(
//                         color: Theme.of(context).primaryColor,
//                         width: 2,
//                       ),
//                       foregroundColor: Theme.of(context).primaryColor,
//                     ),
//                     child: const Text(
//                       'Register',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
