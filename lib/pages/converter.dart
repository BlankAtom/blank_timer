import 'package:flutter/material.dart';

class StepperExample extends StatefulWidget {
  @override
  _StepperExampleState createState() => _StepperExampleState();
}

class _StepperExampleState extends State<StepperExample> {
  int _currentStep = 0;
  String dropdownValue = 'Microsoft SQL Server';

  @override
  Widget build(BuildContext context) {
    var inputSourceWidget = getInputSourceWidget();
    var inputDestinationWidget = getInputSourceWidget();
    return Scaffold(
      appBar: AppBar(
        title: Text('Stepper Example'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue:
            _currentStep < 2 ? () => setState(() => _currentStep += 1) : null,
        onStepCancel:
            _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
        steps: <Step>[
          Step(
            title: Text('Step 1'),
            content: inputSourceWidget,
            isActive: _currentStep >= 0,
            state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: Text('Step 2'),
            content: inputDestinationWidget,
            isActive: _currentStep >= 1,
            state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: Text('Step 3: Select tables to convert'),
            content: Container(
              alignment: Alignment.topLeft,
              child: Container(
                width: 400,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Row(
                            children: [
                              Checkbox(
                                  value: true, onChanged: (bool? value) {}),
                              Text('Migrate all'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            isActive: _currentStep >= 2,
            state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
          ),
        ],
      ),
    );
  }

  Widget getInputSourceWidget() {
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            width: 400,
            child: Text(
              'Enter source data configuration:',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 下拉选择数据库类型
          Container(
            padding: EdgeInsets.all(8),
            width: 400,
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              isExpanded: true,
              iconSize: 18,
              elevation: 8,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>[
                'Microsoft SQL Server',
                'MySQL',
                'Oracle',
                'PostgreSQL',
                'SQLite',
                'MariaDB',
                'DM',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(value),
                  ),
                );
              }).toList(),
            ),
          ),

          Container(
            padding: EdgeInsets.all(8),
            width: 400,
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Host',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Port'),
                    ),
                  ),
                )
              ],
            ),
          ),

          Container(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Username'),
                ),
              ),
            ),
          ),
          Container(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                ),
              ),
            ),
          ),

          Container(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Choose Initial Catalog'),
                ),
              ),
            ),
          ),

          Container(
            width: 400,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Checkbox(
                    value: true,
                    onChanged: (bool? value) {},
                  ),
                ),
                Text('Trust server certificate')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
