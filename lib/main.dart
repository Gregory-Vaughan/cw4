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
          : ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return ListTile(
                  title: Text(plan.name),
                  subtitle: Text(plan.description),
                  trailing: Icon(
                    plan.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: plan.isCompleted ? Colors.green : Colors.grey,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createSamplePlan,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createSamplePlan() {
    setState(() {
      plans.add(Plan(
        name: 'Sample Plan ${plans.length + 1}',
        description: 'Description for plan ${plans.length + 1}',
        date: DateTime.now(),
      ));
    });
  }
}
