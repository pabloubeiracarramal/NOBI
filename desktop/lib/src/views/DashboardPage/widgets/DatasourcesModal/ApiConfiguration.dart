import 'dart:developer';

import 'package:desktop/src/models/ApiModel.dart';
import 'package:desktop/src/models/DashboardModel.dart';
import 'package:desktop/src/models/EndpointModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiConfiguration extends ConsumerStatefulWidget {
  final Dashboard dashboard;
  final Function(Dashboard) onUpdateTemporaryState;

  const ApiConfiguration({
    Key? key,
    required this.dashboard,
    required this.onUpdateTemporaryState,
  }) : super(key: key);

  @override
  ConsumerState<ApiConfiguration> createState() => _ApiConfigurationState();
}

class _ApiConfigurationState extends ConsumerState<ApiConfiguration> {
  late List<bool> _isOpen;
  late List<TextEditingController> _nameControllers;
  late List<TextEditingController> _urlControllers;
  late List<List<TextEditingController>> _endpointControllers;
  late List<List<String>> _methodControllers;

  @override
  void initState() {
    super.initState();
    _isOpen = List<bool>.generate(
        widget.dashboard.apis.length, (index) => false,
        growable: true);
    _nameControllers = widget.dashboard.apis
        .map((api) => TextEditingController(text: api.name))
        .toList();
    _urlControllers = widget.dashboard.apis
        .map((api) => TextEditingController(text: api.baseUrl))
        .toList();
    _endpointControllers = widget.dashboard.apis.map((api) {
      return api.endpoints
          .map((endpoint) => TextEditingController(text: endpoint.url))
          .toList();
    }).toList();
    _methodControllers = widget.dashboard.apis.map((api) {
      return api.endpoints.map((endpoint) => endpoint.method).toList();
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var controller in _urlControllers) {
      controller.dispose();
    }
    for (var list in _endpointControllers) {
      for (var controller in list) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _handlePanelExpansion(int panelIndex, bool isExpanded) {
    log(_isOpen.length.toString());
    log(_isOpen[0].toString());
    setState(() {
      _isOpen[panelIndex] = isExpanded;
    });
    log(_isOpen[0].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'APIs',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    widget.dashboard.apis.add(
                      Api(
                        id: 0,
                        name: 'New Api',
                        baseUrl: 'Base URL',
                        token: '',
                        endpoints: [],
                      ),
                    );
                    _isOpen.add(false);
                    _nameControllers
                        .add(TextEditingController(text: 'New Api'));
                    _urlControllers
                        .add(TextEditingController(text: 'Base URL'));
                    _endpointControllers.add([]);
                    _methodControllers.add([]);
                  });
                  widget.onUpdateTemporaryState(widget.dashboard);
                },
              ),
            ],
          ),
          Flexible(
            child: SingleChildScrollView(
              child: ExpansionPanelList(
                expansionCallback: _handlePanelExpansion,
                children: widget.dashboard.apis
                    .asMap()
                    .entries
                    .map((entry) => _createPanel(entry.value, entry.key))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ExpansionPanel _createPanel(Api api, int index) {
    return ExpansionPanel(
      backgroundColor:
          const Color.fromARGB(255, 243, 255, 254).withOpacity(0.85),
      headerBuilder: (context, isExpanded) {
        return ListTile(
          title: TextField(
            controller: _nameControllers[index],
            decoration: const InputDecoration(
              hintText: 'API Name',
              border: InputBorder.none,
            ),
            style: const TextStyle(fontWeight: FontWeight.bold),
            onChanged: (value) {
              widget.dashboard.apis[index].name = value;
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                widget.dashboard.apis.removeAt(index);
                _isOpen.removeAt(index);
                _nameControllers.removeAt(index);
                _urlControllers.removeAt(index);
                _endpointControllers.removeAt(index);
                _methodControllers.removeAt(index);
              });
              widget.onUpdateTemporaryState(widget.dashboard);
            },
          ),
        );
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'API URL',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: TextField(
                    controller: _urlControllers[index],
                    decoration: const InputDecoration(
                      isDense: true,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.all(8),
                      hintText: 'API URL',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      widget.dashboard.apis[index].baseUrl = value;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Endpoints',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          widget.dashboard.apis[index].endpoints.add(
                            Endpoint(
                              endpointId: 0,
                              url: '',
                              method: 'GET',
                              waitTime: 100000,
                              mode: 'latest',
                            ),
                          );
                          _endpointControllers[index]
                              .add(TextEditingController());
                          _methodControllers[index].add('GET');
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  children:
                      List.generate(_endpointControllers[index].length, (i) {
                    return ListTile(
                      leading: DropdownButton<String>(
                        value: _methodControllers[index][i],
                        onChanged: (String? newValue) {
                          setState(() {
                            _methodControllers[index][i] = newValue!;
                            widget.dashboard.apis[index].endpoints[i].method =
                                newValue;
                          });
                        },
                        items: <String>['GET', 'POST', 'PUT', 'DELETE']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _endpointControllers[index][i],
                              decoration: const InputDecoration(
                                hintText: 'Endpoint URL',
                                isDense: true,
                                isCollapsed: true,
                                contentPadding: EdgeInsets.all(8),
                              ),
                              onChanged: (value) {
                                widget.dashboard.apis[index].endpoints[i].url =
                                    value;
                              },
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            widget.dashboard.apis[index].endpoints.removeAt(i);
                            _endpointControllers[index].removeAt(i);
                            _methodControllers[index].removeAt(i);
                          });
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            indent: 0,
            height: 1,
          ),
        ],
      ),
      isExpanded: _isOpen[index],
    );
  }
}
