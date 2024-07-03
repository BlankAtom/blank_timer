import 'dart:convert';

import 'package:flutter/material.dart';

class StepperExample extends StatefulWidget {
  @override
  _StepperExampleState createState() => _StepperExampleState();
}

class _StepperExampleState extends State<StepperExample> {
  int _currentStep = 0;
  String dropdownValue = 'Microsoft SQL Server';

  late DatabaseConverterConfiguration _converterConfiguration;

  // 创建Source TextEditingController实例
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _initialCatalogController = TextEditingController();

  // 创建Destination TextEditingController实例
  final TextEditingController _hostDesController = TextEditingController();
  final TextEditingController _portDesController = TextEditingController();
  final TextEditingController _usernameDesController = TextEditingController();
  final TextEditingController _passwordDesController = TextEditingController();
  final TextEditingController _initialCatalogDesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _converterConfiguration = DatabaseConverterConfiguration();

    // 监听输入框的内容变化
    _hostController.addListener(_updateInputSource);
    _portController.addListener(_updateInputSource);
    _usernameController.addListener(_updateInputSource);
    _passwordController.addListener(_updateInputSource);
    _initialCatalogController.addListener(_updateInputSource);
    _hostDesController.addListener(_updateInputSource);
    _portDesController.addListener(_updateInputSource);
    _usernameDesController.addListener(_updateInputSource);
    _passwordDesController.addListener(_updateInputSource);
    _initialCatalogDesController.addListener(_updateInputSource);
  }

  @override
  void dispose() {
    // 在widget销毁时，需要销毁TextEditingController实例
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _initialCatalogController.dispose();
    _hostDesController.dispose();
    _portDesController.dispose();
    _usernameDesController.dispose();
    _passwordDesController.dispose();
    _initialCatalogDesController.dispose();

    super.dispose();
  }

  void _updateInputSource() {
    _converterConfiguration.sourceConfiguration.host = _hostController.text;
    _converterConfiguration.sourceConfiguration.port = int.parse(_portController.text);
    _converterConfiguration.sourceConfiguration.username = _usernameController.text;
    _converterConfiguration.sourceConfiguration.password = _passwordController.text;
    _converterConfiguration.sourceConfiguration.initialCatalog = _initialCatalogController.text;
    _converterConfiguration.destinationConfiguration.host = _hostDesController.text;
    _converterConfiguration.destinationConfiguration.port = int.parse(_portDesController.text);
    _converterConfiguration.destinationConfiguration.username = _usernameDesController.text;
    _converterConfiguration.destinationConfiguration.password = _passwordDesController.text;
    _converterConfiguration.destinationConfiguration.initialCatalog = _initialCatalogDesController.text;
  }

  @override
  Widget build(BuildContext context) {
    var inputSourceWidget = getInputSourceWidget(1);
    var inputDestinationWidget = getInputSourceWidget(0);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Stepper Example'),
      // ),
      body: Stepper(
        elevation: 4,
        physics: ClampingScrollPhysics(),
        currentStep: _currentStep,
        type: StepperType.horizontal,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: _currentStep < 3 ? () => setState(() => _currentStep += 1) : null,
        onStepCancel: _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
        /*stepIconBuilder: (context, index) {
          return Icon(Icons.account_balance);
        },*/
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            children: <Widget>[
              _currentStep < 3
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: const Text('Continue'),
                      ),
                    )
                  : Container(), // if we are on the last step, we remove the continue button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Cancel'),
                ),
              ),
              _currentStep == 3
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle completion of the stepper
                          _finished();
                        },
                        child: const Text('Finish'),
                      ),
                    )
                  : Container(), // if we are on the last step, we add a finish button
            ],
          );
        },
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
            // label: Text('Step 3'),
            // stepStyle: StepStyle(
            //   boxShadow: BoxShadow(
            //     color: Colors.red,
            //     blurRadius: 10,
            //   ),
            // ),
            // subtitle: Text('Select tables to convert'),
            title: Text('Step 3'),
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
                              Checkbox(value: true, onChanged: (bool? value) {}),
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
          // Waiting
          Step(
            title: Text('Step 4'),
            label: Text('Step 4'),
            content: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Container(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  value: 0.3,
                  backgroundColor: Colors.grey,
                  strokeCap: StrokeCap.round,
                  strokeWidth: 10,
                ),
              ),
            ),
            isActive: _currentStep >= 3,
            state: StepState.editing,
          ),
        ],
      ),
    );
  }

  Widget getInputSourceWidget(int source) {
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
                    padding: const EdgeInsets.only(left: 8.0),
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
                      controller: source == 1 ? _hostController : _hostDesController,
                      decoration: InputDecoration(labelText: 'Host'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: TextFormField(
                      controller: source == 1 ? _portController : _portDesController,
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
                  controller: source == 1 ? _usernameController : _usernameDesController,
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
                  controller: source == 1 ? _passwordController : _passwordDesController,
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
                  controller: source == 1 ? _initialCatalogController : _initialCatalogDesController,
                  decoration: InputDecoration(labelText: 'Choose Initial Catalog'),
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

  void _finished() {
    debugPrint(jsonEncode(_converterConfiguration));
  }

  void _postForConvert() {
    // 发送请求
    /*http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/albums'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
      }),
    );*/
  }
}

abstract class DatabaseConfiguration {
  String host = '';
  int port = 0;
  String username = '';
  String password = '';
  String initialCatalog = '';
  bool trustServerCertificate = true;
}

class DatabaseSourceConfiguration extends DatabaseConfiguration {}

class DatabaseDestinationConfiguration extends DatabaseConfiguration {}

class DatabaseConverterConfiguration {
  late DatabaseSourceConfiguration sourceConfiguration;
  late DatabaseDestinationConfiguration destinationConfiguration;
  late List<String> tables;

  DatabaseConverterConfiguration() {
    sourceConfiguration = DatabaseSourceConfiguration();
    destinationConfiguration = DatabaseDestinationConfiguration();
    tables = [];
  }

  DatabaseConverterConfiguration.fromJson(Map<String, dynamic> json) {
    sourceConfiguration = DatabaseSourceConfiguration()
      ..host = json['sourceConfiguration']['host']
      ..port = json['sourceConfiguration']['port']
      ..username = json['sourceConfiguration']['username']
      ..password = json['sourceConfiguration']['password']
      ..initialCatalog = json['sourceConfiguration']['initialCatalog']
      ..trustServerCertificate = json['sourceConfiguration']['trustServerCertificate'];

    destinationConfiguration = DatabaseDestinationConfiguration()
      ..host = json['destinationConfiguration']['host']
      ..port = json['destinationConfiguration']['port']
      ..username = json['destinationConfiguration']['username']
      ..password = json['destinationConfiguration']['password']
      ..initialCatalog = json['destinationConfiguration']['initialCatalog']
      ..trustServerCertificate = json['destinationConfiguration']['trustServerCertificate'];

    tables = List<String>.from(json['tables']);
  }

  Map<String, dynamic> toJson() {
    return {
      'sourceConfiguration': {
        'host': sourceConfiguration.host,
        'port': sourceConfiguration.port,
        'username': sourceConfiguration.username,
        'password': sourceConfiguration.password,
        'initialCatalog': sourceConfiguration.initialCatalog,
        'trustServerCertificate': sourceConfiguration.trustServerCertificate,
      },
      'destinationConfiguration': {
        'host': destinationConfiguration.host,
        'port': destinationConfiguration.port,
        'username': destinationConfiguration.username,
        'password': destinationConfiguration.password,
        'initialCatalog': destinationConfiguration.initialCatalog,
        'trustServerCertificate': destinationConfiguration.trustServerCertificate,
      },
      'tables': tables,
    };
  }
}
