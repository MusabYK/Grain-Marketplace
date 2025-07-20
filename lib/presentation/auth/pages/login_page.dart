import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/app_validators.dart';
import '../providers/auth_provider.dart';
import '../../farmer/pages/farmer_dashboard_screen.dart'; // Import for navigation
import '../../buyer/pages/buyer_dashboard_screen.dart'; // Import for navigation

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Add a listener to navigate after successful login
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _listener = () {
      _navigateToDashboard(authProvider);
    };
    authProvider.addListener(_listener);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    Provider.of<AuthProvider>(
      context,
      listen: false,
    ).removeListener(_listener); // Remove listener
    super.dispose();
  }

  // New method to handle navigation based on auth status
  void _navigateToDashboard(AuthProvider authProvider) {
    if (authProvider.status == AuthStatus.authenticated) {
      if (authProvider.currentUser?.userType == 'farmer') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const FarmerDashboardScreen(),
          ),
          (Route<dynamic> route) => false, // Remove all routes below
        );
      } else if (authProvider.currentUser?.userType == 'buyer') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BuyerDashboardScreen()),
          (Route<dynamic> route) => false, // Remove all routes below
        );
      }
    } else if (authProvider.status == AuthStatus.unauthenticated &&
        authProvider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(authProvider.errorMessage!)));
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // No need for await here, as navigation is handled by listener
      // The listener will react to the status change and navigate
      authProvider.signIn(_emailController.text, _passwordController.text);
      // The listener takes care of navigation and error display
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen[700],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Sign in to continue your grain trading journey.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.validateEmail,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                  validator: AppValidators.validatePassword,
                ),
                const SizedBox(height: 30),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return ElevatedButton(
                      onPressed:
                          authProvider.status == AuthStatus.authenticating
                          ? null
                          : _login,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.lightGreen,
                        foregroundColor: Colors.white,
                        elevation: 5,
                      ),
                      child: authProvider.status == AuthStatus.authenticating
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.lightGreen[700],
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../core/widgets/custom_text_field.dart';
// import '../../../core/utils/app_validators.dart';
// import '../providers/auth_provider.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   void _login() async {
//     if (_formKey.currentState!.validate()) {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.signIn(
//         _emailController.text,
//         _passwordController.text,
//       );
//
//       if (authProvider.status == AuthStatus.unauthenticated &&
//           authProvider.errorMessage != null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(authProvider.errorMessage!)));
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: Colors.black,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Welcome Back!',
//                   style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.lightGreen[700],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   'Sign in to continue your grain trading journey.',
//                   style: Theme.of(context).textTheme.titleMedium,
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 40),
//                 CustomTextField(
//                   controller: _emailController,
//                   labelText: 'Email',
//                   keyboardType: TextInputType.emailAddress,
//                   validator: AppValidators.validateEmail,
//                 ),
//                 const SizedBox(height: 20),
//                 CustomTextField(
//                   controller: _passwordController,
//                   labelText: 'Password',
//                   obscureText: true,
//                   validator: AppValidators.validatePassword,
//                 ),
//                 const SizedBox(height: 30),
//                 Consumer<AuthProvider>(
//                   builder: (context, authProvider, child) {
//                     return ElevatedButton(
//                       onPressed:
//                           authProvider.status == AuthStatus.authenticating
//                           ? null
//                           : _login,
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: const Size(double.infinity, 55),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         backgroundColor: Colors.lightGreen,
//                         foregroundColor: Colors.white,
//                         elevation: 5,
//                       ),
//                       child: authProvider.status == AuthStatus.authenticating
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text(
//                               'Login',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () {
//                     // TODO: Implement forgot password
//                   },
//                   child: Text(
//                     'Forgot Password?',
//                     style: TextStyle(
//                       color: Colors.lightGreen[700],
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
