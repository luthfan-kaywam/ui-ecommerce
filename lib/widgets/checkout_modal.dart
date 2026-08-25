import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';

class CheckoutModal extends StatefulWidget {
  const CheckoutModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CheckoutModal(),
    );
  }

  @override
  State<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<CheckoutModal>
    with SingleTickerProviderStateMixin {
  String _selectedPaymentMethod = 'GoPay / E-Wallet';
  bool _isProcessing = false;
  bool _isSuccess = false;
  String _transactionId = '';
  double _paidTotal = 0.0;

  late AnimationController _checkController;
  late Animation<double> _checkScaleAnimation;

  final List<Map<String, dynamic>> _paymentOptions = [
    {'name': 'GoPay / E-Wallet', 'icon': Icons.account_balance_wallet},
    {'name': 'Credit Card', 'icon': Icons.credit_card},
    {'name': 'Cash on Delivery', 'icon': Icons.local_shipping},
  ];

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _checkScaleAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  void _startPaymentProcess(BuildContext context) async {
    final cart = context.cart;
    if (cart.items.isEmpty) return;

    setState(() {
      _isProcessing = true;
      _paidTotal = cart.grandTotal;
      _transactionId =
          'TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    });

    // Simulate Network Request / Payment Verification
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
      _isSuccess = true;
    });

    _checkController.forward(from: 0.0);
  }

  void _finishAndClose(BuildContext context) {
    context.cart.clearCart();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.cart;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _isSuccess
            ? _buildSuccessView(context)
            : _buildCheckoutFormView(context, cart),
      ),
    );
  }

  Widget _buildCheckoutFormView(BuildContext context, dynamic cart) {
    return SingleChildScrollView(
      key: const ValueKey('checkout_form'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Drag Handle
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Header Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Checkout',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C53A5),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: _isProcessing ? null : () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),

          // Shipping Address Section
          const Text(
            'Alamat Pengiriman',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4C53A5),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF4C53A5)),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Abu Setiawan (+62 812-3456-7890)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Jl. Dev Studio No. 88, Jakarta Selatan, 12345',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Payment Method Selector
          const Text(
            'Metode Pembayaran',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4C53A5),
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: _paymentOptions.map((opt) {
              final isSelected = _selectedPaymentMethod == opt['name'];
              return InkWell(
                onTap: _isProcessing
                    ? null
                    : () {
                        setState(() {
                          _selectedPaymentMethod = opt['name'];
                        });
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF4C53A5).withValues(alpha: 0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4C53A5)
                          : Colors.grey.shade300,
                      width: isSelected ? 1.8 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(opt['icon'] as IconData,
                          color: const Color(0xFF4C53A5)),
                      const SizedBox(width: 12),
                      Text(
                        opt['name'] as String,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: const Color(0xFF4C53A5),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF4C53A5)
                                : Colors.grey.shade400,
                            width: isSelected ? 6 : 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 15),

          // Price Breakdown Section
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FC),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                _buildSummaryRow(
                  'Subtotal',
                  '\$${cart.subtotal.toStringAsFixed(2)}',
                ),
                if (cart.discountAmount > 0)
                  _buildSummaryRow(
                    'Diskon Kupon (${cart.couponCode})',
                    '-\$${cart.discountAmount.toStringAsFixed(2)}',
                    isDiscount: true,
                  ),
                _buildSummaryRow(
                  'Ongkos Kirim',
                  '\$${cart.deliveryFee.toStringAsFixed(2)}',
                ),
                _buildSummaryRow(
                  'Pajak (5%)',
                  '\$${cart.tax.toStringAsFixed(2)}',
                ),
                const Divider(height: 20),
                _buildSummaryRow(
                  'Total Pembayaran',
                  '\$${cart.grandTotal.toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Animated Confirm & Pay Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: (cart.items.isEmpty || _isProcessing)
                  ? null
                  : () => _startPaymentProcess(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C53A5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                shadowColor: const Color(0xFF4C53A5).withValues(alpha: 0.4),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _isProcessing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Memproses Pembayaran...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Konfirmasi & Bayar (\$${cart.grandTotal.toStringAsFixed(2)})',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('payment_success'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),

          // Top Drag Handle
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Scale animated success icon badge
          ScaleTransition(
            scale: _checkScaleAnimation,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green.shade200, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.15),
                    blurRadius: 15,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 70,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Pembayaran Berhasil!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4C53A5),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Pesanan Anda sedang diproses dan akan segera dikirim.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 20),

          // Order Receipt Details Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildReceiptRow('ID Transaksi', _transactionId),
                _buildReceiptRow('Metode Pembayaran', _selectedPaymentMethod),
                _buildReceiptRow('Status', 'BERHASIL', isStatus: true),
                const Divider(height: 20),
                _buildReceiptRow(
                  'Total Dibayar',
                  '\$${_paidTotal.toStringAsFixed(2)}',
                  isBold: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Return Home Action Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => _finishAndClose(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C53A5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                shadowColor: const Color(0xFF4C53A5).withValues(alpha: 0.4),
              ),
              child: const Text(
                'Selesai & Kembali ke Beranda',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount,
      {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFF4C53A5) : Colors.black87,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isDiscount
                  ? Colors.green
                  : (isTotal ? const Color(0xFF4C53A5) : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value,
      {bool isBold = false, bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight: (isBold || isStatus)
                  ? FontWeight.bold
                  : FontWeight.w500,
              color: isStatus
                  ? Colors.green
                  : (isBold ? const Color(0xFF4C53A5) : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
