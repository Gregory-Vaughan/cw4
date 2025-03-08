import 'package:flutter/material.dart';

void main() {
  runApp(const AdoptionTravelPlannerApp());
}

class AdoptionTravelPlannerApp extends StatelessWidget {
  const AdoptionTravelPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adoption & Travel Planner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PlanManagerScreen(),
    );
  }
}


class Plan {
  String name;
  String description;
  DateTime date;
  bool isCompleted;

  Plan({
    required this.name,
    required this.description,
    required this.date,
    this.isCompleted = false,
  });
}

class PlanManagerScreen extends StatefulWidget {
  const PlanManagerScreen({super.key});

  @override
  State<PlanManagerScreen> createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  final List<Plan> plans = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adoption & Travel Planner')),
      body: plans.isEmpty
          ? const Center(child: Text('No plans yet. Tap + to add a plan!'))
          : ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final Plan movedPlan = plans.removeAt(oldIndex);
                  plans.insert(newIndex, movedPlan);
                });
              },
              children: List.generate(plans.length, (index) {
                final plan = plans[index];

                return Dismissible(
                  key: Key(plan.name),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.check, color: Colors.white, size: 30),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.undo, color: Colors.white, size: 30),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      if (direction == DismissDirection.startToEnd) {
                        plans[index].isCompleted = true;
                      } else {
                        plans[index].isCompleted = false;
                      }
                    });
                  },
                  child: GestureDetector(
                    onDoubleTap: () => _deletePlan(index),
                    key: ValueKey(plan), 
                    child: Container(
                      decoration: BoxDecoration(
                        color: plan.isCompleted ? Colors.green.shade100 : Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text(
                          plan.name,
                          style: TextStyle(
                            decoration: plan.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(plan.description),
                        trailing: const Icon(Icons.drag_handle), 
                        onLongPress: () => _editPlan(index),
                      ),
                    ),
                  ),
                );
              }),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePlanDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Show Create Plan Dialog
  void _showCreatePlanDialog() {
    String name = '';
    String description = '';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Plan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Plan Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    selectedDate = pickedDate;
                  }
                },
                child: const Text('Pick a Date'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && description.isNotEmpty) {
                  setState(() {
                    plans.add(Plan(name: name, description: description, date: selectedDate));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  
  void _editPlan(int index) {
    String updatedName = plans[index].name;
    String updatedDescription = plans[index].description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Plan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: updatedName),
                decoration: const InputDecoration(labelText: 'Plan Name'),
                onChanged: (value) => updatedName = value,
              ),
              TextField(
                controller: TextEditingController(text: updatedDescription),
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => updatedDescription = value,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  plans[index].name = updatedName;
                  plans[index].description = updatedDescription;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  
  void _deletePlan(int index) {
    setState(() {
      plans.removeAt(index);
    });
  }
}
