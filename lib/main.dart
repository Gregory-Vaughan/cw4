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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PlanManagerScreen(),
    );
  }
}

class PlanManagerScreen extends StatefulWidget {
  const PlanManagerScreen({super.key});

  @override
  State<PlanManagerScreen> createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  final List<String> plans = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adoption & Travel Planner')),
      body: plans.isEmpty
          ? const Center(child: Text('No plans yet. Tap + to add a plan!'))
          : ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(plans[index]),
                  leading: const Icon(Icons.event_note),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPlan,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createPlan() {
    
    setState(() {
      plans.add('New Plan ${plans.length + 1}');
    });
  }
}
