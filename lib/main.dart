import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:CariArena/routes/app_routes.dart';
import 'package:CariArena/providers/auth_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: 'CariArena',
            theme: ThemeData(primarySwatch: Colors.blue),
            initialRoute: AppRoutes.initial,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
