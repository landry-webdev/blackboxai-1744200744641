import 'package:flutter/material.dart';
import '../services/payment_service.dart';

class DashboardScreen extends StatefulWidget {
  final String name;
  final double balance;

  const DashboardScreen({super.key, required this.name, required this.balance});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PaymentService _paymentService = PaymentService();
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Implement logout
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Your Balance', style: TextStyle(fontSize: 18)),
                    Text('\$${widget.balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Send Money', style: TextStyle(fontSize: 18)),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Recipient Phone'),
              keyboardType: TextInputType.phone,
            ),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _sendMoney,
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMoney() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final phone = _phoneController.text;

    if (amount <= 0 || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid amount and phone')),
      );
      return;
    }

    try {
      await _paymentService.sendMoney(phone, amount);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful')),
      );
      // Refresh balance
      setState(() {
        widget.balance -= amount;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${e.toString()}')),
      );
    }
  }
}
