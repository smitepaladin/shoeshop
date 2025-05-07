import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:team4shoeshop/vm/database_handler.dart';
import 'package:team4shoeshop/model/employee.dart';

class LocationSearch extends StatefulWidget {
  const LocationSearch({super.key});

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  late final MapController _mapController;
  late final DatabaseHandler handler;

  LatLng? currentLocation;
  List<Employee> employees = [];
  Employee? selectedEmployee;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    handler = DatabaseHandler();
    _loadInitialLocation();
    _loadEmployees();
  }

  Future<void> _loadInitialLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

Future<void> _loadEmployees() async {
  final db = await handler.initializeDB();
  final result = await db.query('employee');

  final allEmployees = result.map((e) => Employee.fromMap(e)).toList();

  // 본사 사원/팀장/임원 제외
final filtered = allEmployees.where((e) =>
    !(e.eid == 'emp001' || e.eid == 'emp002' || e.eid == 'emp003')).toList();

  setState(() {
    employees = filtered;
  });
}

  void _onEmployeeSelected(Employee? employee) {
    if (employee == null) return;

    setState(() {
      selectedEmployee = employee;
      _mapController.move(
        LatLng(employee.elatdata, employee.elongdata),
        _mapController.camera.zoom,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("지점 위치 검색")),
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: currentLocation!,
                      initialZoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: currentLocation!,
                            width: 40,
                            height: 40,
                            child: Icon(Icons.person_pin_circle,
                                color: Colors.blue, size: 40),
                          ),
                          if (selectedEmployee != null)
                            Marker(
                              point: LatLng(selectedEmployee!.elatdata,
                                  selectedEmployee!.elongdata),
                              width: 40,
                              height: 40,
                              child: Icon(Icons.location_on,
                                  color: Colors.red, size: 40),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButton<Employee>(
                    isExpanded: true,
                    hint: Text("지점을 선택하세요"),
                    value: selectedEmployee,
                    items: employees.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text("${e.ename} (${e.eid})"),
                      );
                    }).toList(),
                    onChanged: _onEmployeeSelected,
                  ),
                ),
              ],
            ),
    );
  }
}
