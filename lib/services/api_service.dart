import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../models/field_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.110.143:8081/api';
  static String get midtransMerchantBaseUrl => "$_baseUrl/payments/create";

  // static final String _baseUrl =
  //     dotenv.env['API_BASE_URL'] ?? 'http://192.168.110.95:8081/api';
  static const storage = FlutterSecureStorage();
  // static Future<void> fetchCsrfCookie() async {
  //   final url = Uri.parse('http://192.168.0.109:8081/sanctum/csrf-cookie');
  //   await http.get(url);
  // }

  // static String? getCsrfToken() {
  //   // For mobile platforms, CSRF token is not required
  //   return null;
  // }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    print('hello');
    // await fetchCsrfCookie();
    // final csrfToken = getCsrfToken();
    final headers = {'Content-Type': 'application/json'};
    // if (csrfToken != null) {
    //   headers['X-XSRF-TOKEN'] = csrfToken;
    // }
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    print(response);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String? authToken =
          responseData['token']; // Gunakan ?. untuk keamanan
      print(responseData);
      if (authToken != null) {
        // Tempatkan kode untuk menyimpan token di sini
        await storage.write(key: 'authToken', value: authToken);
      } else {
        throw Exception('Token otentikasi tidak ditemukan.');
      }

      return responseData;
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Login gagal');
    }
  }

  static Future<String?> getAuthToken() async {
    return await storage.read(key: 'authToken');
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String password,
    String passwordConfirmation,
  ) async {
    // await fetchCsrfCookie();
    // final csrfToken = getCsrfToken();
    final headers = {'Content-Type': 'application/json'};
    // if (csrfToken != null) {
    //   headers['X-XSRF-TOKEN'] = csrfToken;
    // }
    final url = Uri.parse('$_baseUrl/register');
    final Map<String, dynamic> requestBody = {
      // Deklarasi body
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };

    try {
      // Hanya satu kali pemanggilan http.post
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(
          requestBody,
        ), // Gunakan requestBody yang sudah didefinisikan
      );

      // Backend biasanya mengembalikan 201 Created atau 200 OK untuk pendaftaran berhasil
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Jika pendaftaran berhasil, kembalikan Map<String, dynamic> dari respons
        // Asumsi respons sukses juga berupa JSON (misal: {'message': 'User created', 'user': {...}})
        return jsonDecode(response.body);
      } else {
        // Jika ada error dari server (misal: validasi gagal, email sudah terdaftar)
        final errorData = jsonDecode(response.body); // Dekode body error
        String errorMessage = 'Pendaftaran gagal.';

        // Logika untuk mengekstrak pesan error yang lebih spesifik
        if (errorData is Map<String, dynamic>) {
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          } else if (errorData.containsKey('errors')) {
            // Jika backend mengembalikan error validasi field
            final errors = errorData['errors'] as Map<String, dynamic>;
            errorMessage = errors.values
                .expand((e) => (e as List).cast<String>())
                .join(', ');
          }
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Tangkap error jaringan atau error lainnya
      throw Exception('Gagal menghubungi server atau terjadi error: $e');
    }
  }

  void _openMidtransPaymentPage(String snapToken) async {
    final url = 'https://app.sandbox.midtrans.com/snap/v1/redirect/$snapToken';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Tidak bisa membuka URL pembayaran: $url';
    }
  }

  Future<List<dynamic>> getVenues() async {
    final response = await http.get(Uri.parse('$_baseUrl/venues'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load venues');
    }
  }

  // static Future<Map<String, dynamic>> getUserData(String authToken) async {
  //   final url = Uri.parse('$_baseUrl/user');
  //   final response = await http.get(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $authToken',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body)['data'];
  //   } else {
  //     throw Exception('Gagal mengambil data user.');
  //   }
  // }

  // static Future<Map<String, dynamic>> getUserProfile(String authToken) async {
  //   final response = await http.get(
  //     Uri.parse('$_baseUrl/profile'),
  //     headers: {'Authorization': 'Bearer $authToken'},
  //   );

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Failed to load user profile: ${response.statusCode}');
  //   }
  // }

  // /// Fetches user statistics from the API.
  // /// This requires an authenticated token.
  // static Future<Map<String, dynamic>> getUserStatistics(String token) async {
  //   final url = Uri.parse('$_baseUrl/user/statistics');
  //   final response = await http.get(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final decodedBody = jsonDecode(response.body);
  //     if (decodedBody is Map<String, dynamic>) {
  //       return decodedBody;
  //     } else {
  //       throw Exception('Invalid API response format for user statistics');
  //     }
  //   } else {
  //     throw Exception(
  //       'Failed to load user statistics: Status ${response.statusCode}',
  //     );
  //   }
  // }

  static Future<Map<String, dynamic>> fetchUserProfileAndStats(
    String authToken,
  ) async {
    final url = Uri.parse('$_baseUrl/user');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      // Decode respons JSON dan kembalikan seluruhnya
      return jsonDecode(response.body);
    } else {
      // Tangani error dengan pesan yang lebih informatif
      throw Exception(
        'Gagal mengambil data profil dan statistik. Status: ${response.statusCode}',
      );
    }
  }

  Future<void> createReservation(Map<String, dynamic> reservationData) async {
    final url = Uri.parse('$_baseUrl/reservations');
    final token = await ApiService.getAuthToken();
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(reservationData),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      print('Response error: ${response.body}');
      throw Exception('Gagal membuat reservasi: ${response.body}');
    }
  }

  Future<String?> createPayment(String token, String reservationId) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/payments/create"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"reservation_id": reservationId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['snap_token']; // return snapToken
    } else {
      print("Error: ${response.body}");
      return null;
    }
  }

  Future<void> updatePaymentStatus(
    String token,
    String reservationId,
    String status,
  ) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/payments/update-status"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"reservation_id": reservationId, "status": status}),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal update status pembayaran: ${response.body}");
    }
  }

  // Method getFields - Perbaikan untuk tipe data yang lebih spesifik
  Future<List<Field>> getFields() async {
    final uri = Uri.parse('$_baseUrl/fields');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final decodedBody = json.decode(response.body);

        if (decodedBody is Map<String, dynamic> &&
            decodedBody['data'] is List) {
          final List<dynamic> data = decodedBody['data'];
          final fields =
              data
                  .map((json) => Field.fromJson(json as Map<String, dynamic>))
                  .toList();

          // print(fields);
          return fields;
        } else {
          throw Exception('Invalid API response format for /fields');
        }
      } else {
        throw Exception(
          'Failed to load fields. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error calling API /fields: $e');
    }
  }

  // Method get(String endpoint) - Perbaikan untuk potensi dynamic/null
  Future<Map<String, dynamic>> get(String endpoint) async {
    // Mengembalikan Map<String, dynamic>
    final uri = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.get(uri);

      // 1. Periksa response.body.isNotEmpty sebelum json.decode
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final decodedBody = json.decode(response.body);

        // 2. Pastikan decodedBody adalah Map<String, dynamic>
        if (decodedBody is Map<String, dynamic>) {
          return decodedBody; // Mengembalikan Map<String, dynamic> yang sudah di-decode
        } else {
          throw Exception(
            'Invalid API response format for $endpoint: Expected a Map, got ${decodedBody.runtimeType}',
          );
        }
      } else {
        // 3. Tambahkan penanganan jika body kosong atau status code bukan 200
        throw Exception(
          'Failed to load data for $endpoint. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      // 4. Pastikan pesan error lebih informatif
      throw Exception('Error calling API $endpoint: $e');
    }
  }

  // Mengambil detail lapangan berdasarkan ID
  Future<Field> getFieldDetail(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/fields/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Field.fromJson(data);
    } else {
      throw Exception('Failed to load field detail');
    }
  }

  Future<List<dynamic>> getUserReservations(int userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/reservations?user_id=$userId'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  Future<List<dynamic>> getFieldReviews(int fieldId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/reviews?field_id=$fieldId'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<void> createReview(Map<String, dynamic> reviewData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/reviews'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reviewData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Berhasil
    } else {
      throw Exception('Failed to create review');
    }
  }

  Future<List<dynamic>> getSortedVenues() async {
    final venues = await getVenues();
    // Misalkan setiap venue memiliki atribut 'distance'
    venues.sort((a, b) {
      final distanceA = a['distance'] ?? 0.0;
      final distanceB = b['distance'] ?? 0.0;
      return distanceA.compareTo(distanceB);
    });
    return venues;
  }

  static Future<void> forgotPassword(String email) async {
    final url = Uri.parse('$_baseUrl/forgot-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal mengirim link reset password');
    }
  }

  static Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final url = Uri.parse('$_baseUrl/reset-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': token,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal mereset password');
    }
  }

  static Future<Map<String, dynamic>> getBookingSummary({
    required int fieldId,
    required DateTime date,
    required List<String> timeSlots,
  }) async {
    // 1. Dapatkan token otorisasi
    String? token = await getAuthToken();
    if (token == null) {
      throw Exception("Auth token not found");
    }

    final url = Uri.parse('$_baseUrl/summary');

    // 🔑 Siapkan BODY Request JSON
    final body = json.encode({
      'field_id': fieldId,
      'date': date.toIso8601String().substring(0, 10),
      'time_slots': timeSlots,
    });

    // 🔑 GANTI http.get MENJADI http.post
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        // Wajib: Tentukan content type sebagai JSON
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: body, // Kirim data di body
    );

    // 4. Tangani respons
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'] ?? data;
    } else {
      // Tangani error, misal jika token tidak valid atau server mengembalikan error lain
      throw Exception(
        'Gagal mengambil ringkasan pesanan. Status: ${response.statusCode}',
      );
    }
  }
}
