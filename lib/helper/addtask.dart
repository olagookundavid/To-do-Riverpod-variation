import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providerclass.dart';

final providerClassProvider = ChangeNotifierProvider<ProviderClass>((ref) {
  return ProviderClass();
});

class AddTask extends ConsumerWidget {
  final TextEditingController addTaskController;

  const AddTask({Key? key, required this.addTaskController}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: const Color(0xFF757575),
      child: Container(
        padding:
            const EdgeInsets.only(top: 40, left: 40, right: 40, bottom: 40),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              cursorColor: Colors.lightBlueAccent,
              cursorHeight: 25,
              decoration: const InputDecoration(
                hintText: "Add New Task",
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.5),
                ),
              ),
              controller: addTaskController,
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                height: 50,
                width: double.infinity,
              ),
              onTap: () async {
                await ref
                    .read(providerClassProvider.notifier)
                    .addTask(addTaskController.text);
                ref.read(providerClassProvider.notifier).refreshNotes();
                addTaskController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('A new Task as been added!'),
                  ),
                );
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
