import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_drive_v1_0/presentation/screens/test/test_controller.dart';
import 'package:app_drive_v1_0/presentation/screens/test/ResilierImage.dart';

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
                      ResilientImage(
                        imageUrl: 'https://driving.ovh/images/questions/${result['img']}',
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
                                value: controller.selected[index],
                                onChanged: (val) => controller.setSelected(index, val),
                              )
                            ),
                          ],
                        ),
                      );
                    }),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>((
                                Set<MaterialState> states,
                              ) {
                                if (states.contains(MaterialState.pressed)) {
                                  return const Color.fromARGB(
                                    255,
                                    185,
                                    220,
                                    249,
                                  ); // Active (pressed) color
                                }
                                return Colors.blue; // Default background color
                              }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                        ),
                        onPressed: () async {
                          controller.handleValid(context);
                        },

                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            ' Se connecter',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () { controller.handleValid(context);
                    //   }
                    //    child: const Padding(
                    //       padding: EdgeInsets.all(10.0),
                    //       child: Text(
                    //         ' Se connecter',
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //     ),
                    // ),
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
