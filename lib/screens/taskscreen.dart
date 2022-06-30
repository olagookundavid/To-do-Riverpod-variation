import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_example/providers/providerclass.dart';
import '../helper/addtask.dart';
import '../constants.dart';

final providerClassProvider = ChangeNotifierProvider<ProviderClass>((ref) {
  return ProviderClass();
});

var todoProvider = StateProvider((ref) {
  final todo = ref.watch(providerClassProvider).todo;
  return todo;
});

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  late final TextEditingController _notesController;

  void refreshTodo() {
    ref.read(providerClassProvider.notifier).refreshNotes();
  }

  @override
  void initState() {
    _notesController = TextEditingController();
    super.initState();
    refreshTodo();
    // Provider.of<ProviderClass>(context, listen: false).refreshNotes();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoProvider);
    final todocount = todos.length;

    List todosList = ref.watch(providerClassProvider).todo;

    //returns todo list
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(35, 60, 60, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  child: Icon(
                    Icons.list,
                    size: 30,
                    color: Colors.lightBlueAccent,
                  ),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'ToDo',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      // ' ${Provider.of<ProviderClass>(context).todocount} Tasks',
                      todocount.toString(),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        // await Provider.of<ProviderClass>(context, listen: false)
                        // .deleteAllTasks();
                        ref
                            .read(providerClassProvider.notifier)
                            .deleteAllTasks();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All Tasks have been deleted!'),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete_forever_rounded,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
                decoration: kcontainerdeco,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  itemCount: todocount,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        //
                        todos[index]['title'],
                        style: TextStyle(
                          decoration: !(todos[index]['checked'] == 0)
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: Checkbox(
                        activeColor: Colors.lightBlueAccent,
                        value: !(todos[index]['checked'] == 0),
                        onChanged: (value) {
                          ref
                              .read(providerClassProvider.notifier)
                              .changeIsChecked(
                                todos[index]['id'],
                                todos[index]['title'],
                                todos[index]['checked'],
                              );
                        },
                      ),
                      onLongPress: () {
                        ref
                            .read(providerClassProvider.notifier)
                            .deleteTask(todos[index]['id']);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Successfully deleted the Task!'),
                        ));
                      },
                    );
                  },
                )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddTask(addTaskController: _notesController),
          );
        },
      ),
    );
  }
}
