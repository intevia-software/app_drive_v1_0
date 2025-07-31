import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_drive_v1_0/presentation/screens/test/test_controller.dart';
import 'package:app_drive_v1_0/presentation/screens/test/ResilierImage.dart';
import 'package:app_drive_v1_0/core/services/globals.dart' as globals;

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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12), // set your desired radius
                        child: ResilientImage(
                          imageUrl: '${globals.domaine}/images/questions/${result['img']}',
                        ),
                      ),
                    SizedBox(height: 20),
                    Container(
                      
                      padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
                       decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(6), // arrondit les coins
                        ),
                      
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              result['question'] ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue, // ou toute autre couleur de fond
                                    borderRadius: BorderRadius.circular(4),
                                  ),
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
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[200], // ou une autre couleur si souhaité
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    responseText,
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Transform.scale(
                              scale: 1.3,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Colors.blue,
                                  checkboxTheme: CheckboxThemeData(
                                    shape: CircleBorder(),
                                    side: BorderSide(color: Colors.blue, width: 1),
                                    fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                                      if (states.contains(MaterialState.selected)) {
                                        return Colors.blue;
                                      }
                                      return Colors.transparent;
                                    }),
                                    checkColor: MaterialStateProperty.all(Colors.transparent),
                                  ),
                                ),
                                child: Checkbox(
                                  value: controller.selected[index],
                                  onChanged: (val) => controller.setSelected(index, val),
                                ),
                              ),
                            )
                              ],
                            ),
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
                            ' Valider',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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
