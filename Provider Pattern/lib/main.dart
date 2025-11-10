import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CounterModel with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
    debugPrint('Counter incremented to $_count');
  }

  void decrement() {
    if (_count > 0) {
      _count--;
      notifyListeners();
      debugPrint('Counter decremented to $_count');
    }
  }
}

class ColorModel with ChangeNotifier {
  Color _color = Colors.blue;

  Color get color => _color;

  void toggleColor() {
    if (_color == Colors.blue) {
      _color = Colors.red;
    } else if (_color == Colors.red) {
      _color = Colors.yellow;
    } else {
      _color = Colors.blue;
    }
    notifyListeners();
    debugPrint('Color changed to $_color');
  }

  String get colorName {
    if (_color == Colors.blue) return 'Blue';
    if (_color == Colors.red) return 'Red';
    return 'Yellow';
  }
}

class SummaryModel {
  final CounterModel counter;
  final ColorModel color;

  SummaryModel({required this.counter, required this.color});

  String get summaryText {
    return 'Giá trị Counter: ${counter.count} | Màu hiện tại: ${color.colorName}';
  }
}


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterModel()),
        ChangeNotifierProvider(create: (_) => ColorModel()),
        ProxyProvider2<CounterModel, ColorModel, SummaryModel>(
          create: (context) {
            final counter = Provider.of<CounterModel>(context, listen: false);
            final color = Provider.of<ColorModel>(context, listen: false);
            return SummaryModel(counter: counter, color: color);
          },
          update: (context, counter, color, previous) {
            return SummaryModel(counter: counter, color: color);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Provider Demo',
        theme: ThemeData(useMaterial3: true),
        home: const HomeView(),
      ),
    );
  }
}



class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color currentColor = Provider.of<ColorModel>(context).color;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider State Management'),
        backgroundColor: currentColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Giá trị Counter:',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              Consumer<CounterModel>(
                builder: (context, counter, child) {
                  return Text(
                    '${counter.count}',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: currentColor,
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),

            
              Consumer<SummaryModel>(
                builder: (context, summary, child) {
                  return Card(
                    color: Colors.grey.shade100,
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 40),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        summary.summaryText,
                        style: const TextStyle(
                            fontSize: 16, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<CounterModel>(context, listen: false)
                          .decrement();
                    },
                    icon: const Icon(Icons.remove_circle, size: 28),
                    label: const Text('Giảm', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<CounterModel>(context, listen: false)
                          .increment();
                    },
                    icon: const Icon(Icons.add_circle, size: 28),
                    label: const Text('Tăng', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Consumer<ColorModel>(
                builder: (context, colorModel, child) {
                  return ElevatedButton.icon(
                    onPressed: colorModel.toggleColor,
                    icon: Icon(Icons.color_lens,
                        size: 28, color: colorModel.color),
                    label: const Text('Đổi Màu AppBar',
                        style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
