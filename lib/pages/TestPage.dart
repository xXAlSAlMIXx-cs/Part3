import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Country.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  Stream<List<Country>> getCountries() {
    return FirebaseFirestore.instance
        .collection('Contires')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Country.fromDoc(doc.data()))
            .toList());
  }

  Future<void> _addCountry(BuildContext context) async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Country'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Country Name'),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, {
                'name': nameController.text.trim(),
                'desc': descController.text.trim(),
              });
            },
            child: Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result['name']!.isNotEmpty && result['desc']!.isNotEmpty) {
      // Get the largest ID
      final snapshot = await FirebaseFirestore.instance.collection('Contires').get();
      int newId = 1;
      if (snapshot.docs.isNotEmpty) {
        final ids = snapshot.docs.map((doc) => (doc.data()['ID'] as int?) ?? 0).toList();
        newId = (ids.reduce((a, b) => a > b ? a : b)) + 1;
      }
      await FirebaseFirestore.instance.collection('Contires').add({
        'ID': newId,
        'Name': result['name'],
        'Discription': result['desc'],
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Country added successfully!')),
      );
    }
  }

  Future<void> _deleteCountry(String docId, BuildContext context) async {
    await FirebaseFirestore.instance.collection('Contires').doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Country deleted successfully!')),
    );
  }

  Future<void> _updateCountry(String docId, String currentName, String currentDesc, BuildContext context) async {
    final nameController = TextEditingController(text: currentName);
    final descController = TextEditingController(text: currentDesc);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Country'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Country Name'),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, {
                'name': nameController.text.trim(),
                'desc': descController.text.trim(),
              });
            },
            child: Text('Update'),
          ),
        ],
      ),
    );

    if (result != null && result['name']!.isNotEmpty && result['desc']!.isNotEmpty) {
      await FirebaseFirestore.instance.collection('Contires').doc(docId).update({
        'Name': result['name'],
        'Discription': result['desc'],
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Country updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by country name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Country>>(
              stream: getCountries(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: \\${snapshot.error}'));
                }
                final countries = snapshot.data;
                if (countries == null || countries.isEmpty) {
                  return const Center(child: Text('No countries found.'));
                }
                final filteredCountries = countries.where((country) =>
                  country.Name.toLowerCase().contains(_searchQuery.toLowerCase())
                ).toList();
                if (filteredCountries.isEmpty) {
                  return const Center(child: Text('No countries match your search.'));
                }
                return ListView.builder(
                  itemCount: filteredCountries.length,
                  itemBuilder: (context, index) {
                    final country = filteredCountries[index];
                    // Find the Firestore doc ID for this country
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('Contires').where('ID', isEqualTo: country.ID).snapshots(),
                      builder: (context, docSnapshot) {
                        String? docId;
                        if (docSnapshot.hasData && docSnapshot.data!.docs.isNotEmpty) {
                          docId = docSnapshot.data!.docs.first.id;
                        }
                        return ListTile(
                          leading: CircleAvatar(child: Text(country.Name[0])),
                          title: Text(country.Name),
                          subtitle: Text(country.Discription),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                tooltip: 'Edit',
                                onPressed: docId == null
                                    ? null
                                    : () async {
                                        await _updateCountry(docId!, country.Name, country.Discription, context);
                                      },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Delete',
                                onPressed: docId == null
                                    ? null
                                    : () async {
                                        await _deleteCountry(docId!, context);
                                      },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCountry(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        tooltip: 'Add Country',
      ),
    );
  }
}
