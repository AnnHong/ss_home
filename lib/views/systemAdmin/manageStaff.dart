import 'package:flutter/material.dart';
import 'package:ss_home/controller/staffController.dart';
import 'package:ss_home/models/staff.dart';

class ManageStaffPage extends StatefulWidget {
  const ManageStaffPage({super.key});

  @override
  State<ManageStaffPage> createState() => _ManageStaffPageState();
}

class _ManageStaffPageState extends State<ManageStaffPage> {
  final staffController controller = staffController();
  void _showStaffForm({StaffModel? staff}) {
    final nameController = TextEditingController(text: staff?.staffName ?? '');
    final icController = TextEditingController(text: staff?.staffIC ?? '');
    final phoneController = TextEditingController(
      text: staff?.staffPhoneNum ?? '',
    );
    final passwordController = TextEditingController(
      text: staff?.staffPassword ?? '',
    );

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(staff == null ? 'Add Staff' : 'Edit Staff'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: icController,
                    decoration: const InputDecoration(labelText: 'IC'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.trim().isNotEmpty &&
                      icController.text.trim().isNotEmpty &&
                      phoneController.text.trim().isNotEmpty &&
                      passwordController.text.trim().isNotEmpty) {
                    // Show an error message if any field is empty

                    final newStaff = StaffModel(
                      staffId: staff?.staffId ?? '',
                      staffName: nameController.text.trim(),
                      staffIC: icController.text.trim(),
                      staffPhoneNum: phoneController.text.trim(),
                      staffPassword: passwordController.text.trim(),
                    );

                    if (staff == null) {
                      await controller.addStaff(newStaff);
                    } else {
                      await controller.updateStaff(newStaff);
                    }

                    if (context.mounted) Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                              'Please enter something in all fields.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                    );
                  }
                },
                child: Text(staff == null ? 'Add' : 'Update'),
              ),
            ],
          ),
    );
  }

  void _confirmDelete(BuildContext context, StaffModel staff) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete Staff'),
            content: Text(
              'Are you sure you want to delete "${staff.staffName}"? ',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await controller.deleteStaff(staff.staffId);
        if (context.mounted) {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text('Success'),
                  content: const Text('Staff deleted successfully.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text('Error'),
                  content: Text('Failed to delete staff: $e'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Staff Info')),
      body: StreamBuilder<List<StaffModel>>(
        stream: controller.getStaff(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          final staffList = snapshot.data ?? [];

          return ListView.builder(
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              final staff = staffList[index];
              return ListTile(
                title: Text(staff.staffName),
                subtitle: Text(
                  'IC: ${staff.staffIC} \nPhone: ${staff.staffPhoneNum}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showStaffForm(staff: staff),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, staff),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStaffForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
