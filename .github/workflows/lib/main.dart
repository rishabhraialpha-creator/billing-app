import 'package:flutter/material.dart';

void main() {
  runApp(const BillingApp());
}

class BillingApp extends StatelessWidget {
  const BillingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Take Billing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedBrand = 'ICE TAKE';
  final List<Map<String, dynamic>> invoices = [];

  void _openCreateBill() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateBillScreen(
          brand: selectedBrand,
          onBillSaved: (bill) {
            setState(() {
              invoices.insert(0, bill);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billing - $selectedBrand'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text('Select Brand: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedBrand,
                  items: ['ICE TAKE', 'TAKE FROZEN']
                      .map((brand) => DropdownMenuItem(
                            value: brand,
                            child: Text(brand),
                          ))
                      .toList,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedBrand = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Ready for generating bills instantly.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.receipt_long),
              label: const Text('Create New Bill', style: TextStyle(fontSize: 16)),
              onPressed: _openCreateBill,
            ),
            const SizedBox(height: 30),
            const Text(
              'Recent Invoices',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: invoices.isEmpty
                  ? const Center(child: Text('No invoices created yet.'))
                  : ListView.builder(
                      itemCount: invoices.length,
                      itemBuilder: (context, index) {
                        final inv = invoices[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(inv['brand'][0]),
                          ),
                          title: Text('${inv['partyName']} (${inv['brand']})'),
                          subtitle: Text('Date: ${inv['date']}'),
                          trailing: Text(
                            '₹${inv['totalAmount']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateBillScreen extends StatefulWidget {
  final String brand;
  final Function(Map<String, dynamic>) onBillSaved;

  const CreateBillScreen({super.key, required this.brand, required this.onBillSaved});

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  final _partyController = TextEditingController();
  final _amountController = TextEditingController();

  void _saveBill() {
    if (_partyController.text.isEmpty || _amountController.text.isEmpty) return;

    final newBill = {
      'brand': widget.brand,
      'partyName': _partyController.text,
      'date': DateTime.now().toString().substring(0, 10),
      'totalAmount': _amountController.text,
    };

    widget.onBillSaved(newBill);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Bill - ${widget.brand}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _partyController,
              decoration: const InputDecoration(labelText: 'Party / Customer Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Total Amount (₹)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: _saveBill,
              child: const Text('Save & Generate Bill', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
