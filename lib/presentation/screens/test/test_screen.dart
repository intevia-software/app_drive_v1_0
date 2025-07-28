import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_drive_v1_0/presentation/screens/test/test_controller.dart';


class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late TestController controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = TestController();
    controller.fetchQuestions(context).then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ChangeNotifierProvider<TestController>.value(
      value: controller,
      child: Consumer<TestController>(
        builder: (context, controller, _) {
          if (controller.count >= controller.nbq || controller.count >= controller.res.length) {
            return Scaffold(
              appBar: AppBar(title: Text('Test terminé')),
              body: Center(child: Text('Test terminé')),
            );
          }

          final result = controller.res[controller.count];

          return Scaffold(
            appBar: AppBar(title: Text('Question n°: ${controller.count + 1}')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (result['img'] != null && result['img'].toString().isNotEmpty)
                      Image.network(
                        'https://driving.ovh/images/questions/${result['img']}',
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                      ),
                    SizedBox(height: 20),
                    Container(
                      color: Colors.grey[700],
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              result['question'] ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                '${controller.counter}/${controller.seconde}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ...List.generate(3, (index) {
                      final responseList = result['response'];
                      final responseText = (responseList != null && responseList.length > index)
                          ? responseList[index]
                          : '';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[700],
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  responseText,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: Checkbox(
                                value: index == 0
                                    ? controller.first
                                    : index == 1
                                        ? controller.second
                                        : controller.third,
                                onChanged: (val) {
                                  if (index == 0) {
                                    controller.setFirst(val);
                                  } else if (index == 1) {
                                    controller.setSecond(val);
                                  } else {
                                    controller.setThird(val);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    ElevatedButton(
                      onPressed: controller.handleValid,
                      child: Text('Envoyer'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
