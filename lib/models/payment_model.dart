class Payment {
  final String id;
  final String reservationId;
  final String userId;
  final double amount;
  final String paymentMethod; // bank_transfer, credit_card, e_wallet
  final String status; // pending, processing, completed, failed, refunded
  final String? transactionId;
  final DateTime paymentDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? paymentProofUrl;
  final String? notes;

  Payment({
    required this.id,
    required this.reservationId,
    required this.userId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    this.transactionId,
    required this.paymentDate,
    required this.createdAt,
    required this.updatedAt,
    this.paymentProofUrl,
    this.notes,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      reservationId: json['reservation_id'],
      userId: json['user_id'],
      amount: json['amount'].toDouble(),
      paymentMethod: json['payment_method'],
      status: json['status'],
      transactionId: json['transaction_id'],
      paymentDate: DateTime.parse(json['payment_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      paymentProofUrl: json['payment_proof_url'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reservation_id': reservationId,
      'user_id': userId,
      'amount': amount,
      'payment_method': paymentMethod,
      'status': status,
      'transaction_id': transactionId,
      'payment_date': paymentDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'payment_proof_url': paymentProofUrl,
      'notes': notes,
    };
  }

  String get formattedAmount {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'processing':
        return 'Sedang Diproses';
      case 'completed':
        return 'Berhasil';
      case 'failed':
        return 'Gagal';
      case 'refunded':
        return 'Dikembalikan';
      default:
        return status;
    }
  }

  String get paymentMethodText {
    switch (paymentMethod) {
      case 'bank_transfer':
        return 'Transfer Bank';
      case 'credit_card':
        return 'Kartu Kredit';
      case 'e_wallet':
        return 'E-Wallet';
      default:
        return paymentMethod;
    }
  }

  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';
}
