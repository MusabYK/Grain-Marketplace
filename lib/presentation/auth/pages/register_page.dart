import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/app_validators.dart';
import '../providers/auth_provider.dart';
import '../../farmer/pages/farmer_dashboard_screen.dart'; // Import for navigation
import '../../buyer/pages/buyer_dashboard_screen.dart'; // Import for navigation

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _selectedUserType; // 'farmer' or 'buyer'

  // Add a listener to navigate after successful registration
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
    _confirmPasswordController.dispose();
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

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedUserType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select if you are a Farmer or a Buyer.'),
          ),
        );
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // No need for await here, as navigation is handled by listener
      // The listener will react to the status change and navigate
      authProvider.register(
        _emailController.text,
        _passwordController.text,
        _selectedUserType!,
      );
      // The listener takes care of navigation and error display
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
                  'Join GrainMarketplace',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Create your account to start trading grains efficiently.',
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
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return AppValidators.validatePassword(value);
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedUserType,
                  decoration: InputDecoration(
                    labelText: 'I am a...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  items: const [
                    DropdownMenuItem(value: 'farmer', child: Text('Farmer')),
                    DropdownMenuItem(value: 'buyer', child: Text('Buyer')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedUserType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your role';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return ElevatedButton(
                      onPressed: authProvider.status == AuthStatus.registering
                          ? null
                          : _register,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.lightGreen,
                        foregroundColor: Colors.white,
                        elevation: 5,
                      ),
                      child: authProvider.status == AuthStatus.registering
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
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
// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});
//
//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }
//
// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   String? _selectedUserType; // 'farmer' or 'buyer'
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   void _register() async {
//     if (_formKey.currentState!.validate()) {
//       if (_selectedUserType == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please select if you are a Farmer or a Buyer.'),
//           ),
//         );
//         return;
//       }
//
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.register(
//         _emailController.text,
//         _passwordController.text,
//         _selectedUserType!,
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
//         title: const Text('Register'),
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
//                   'Join GrainMarketplace',
//                   style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.lightGreen[700],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   'Create your account to start trading grains efficiently.',
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
//                 const SizedBox(height: 20),
//                 CustomTextField(
//                   controller: _confirmPasswordController,
//                   labelText: 'Confirm Password',
//                   obscureText: true,
//                   validator: (value) {
//                     if (value != _passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return AppValidators.validatePassword(value);
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 DropdownButtonFormField<String>(
//                   value: _selectedUserType,
//                   decoration: InputDecoration(
//                     labelText: 'I am a...',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey[100],
//                   ),
//                   items: const [
//                     DropdownMenuItem(value: 'farmer', child: Text('Farmer')),
//                     DropdownMenuItem(value: 'buyer', child: Text('Buyer')),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedUserType = value;
//                     });
//                   },
//                   validator: (value) {
//                     if (value == null) {
//                       return 'Please select your role';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 30),
//                 Consumer<AuthProvider>(
//                   builder: (context, authProvider, child) {
//                     return ElevatedButton(
//                       onPressed: authProvider.status == AuthStatus.registering
//                           ? null
//                           : _register,
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: const Size(double.infinity, 55),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         backgroundColor: Colors.lightGreen,
//                         foregroundColor: Colors.white,
//                         elevation: 5,
//                       ),
//                       child: authProvider.status == AuthStatus.registering
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text(
//                               'Register',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
