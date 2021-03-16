import 'package:firstdesktop/controller/record_service.dart';
import 'package:firstdesktop/model/record_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  // ignore: avoid_init_to_null
  String? _selectedDistrict = null;
  // ignore: avoid_init_to_null
  String? _selectedTaluk = null;
  // ignore: avoid_init_to_null
  String? _selectedTK = null;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    // var provider;
    //provider.fetchforweb(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Json Parsing Demo'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Consumer<MyHomePageProvider>(
            builder: (context, provider, child) {
              if (provider.data == null) {
                provider.fetchforweb(context);
                return Center(child: CircularProgressIndicator());
              }
              var districtList = provider.district.records;
              var talukList = provider.taluk.records
                  .where((element) => element.district == _selectedDistrict);

              return Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: districtDropdown(context, districtList),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: talukDropdown(context, talukList),
                    ),
                  ),
                  searchBtn(context, _scaffoldKey),
                  resultTable(provider)
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  SingleChildScrollView resultTable(MyHomePageProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: [DataTableColumn1(), DataTableColumn2()],
          rows: _selectedTK == null
              ? provider.data!.records
                  .map((data) => DataTableRow(data))
                  .toList()
              : provider.data!.records
                  .where(
                      (rs) => rs.teshilTaluk!.contains(_selectedTK.toString()))
                  .map((data) => DataTableRow(data))
                  .toList(),
        ),
      ),
    );
  }

  Padding searchBtn(
      BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton.icon(
        onPressed: () {
          if (_selectedDistrict == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Please Choose District.'),
                duration: Duration(seconds: 3),
              ),
            );
          } else if (_selectedTaluk == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please Choose Taluk'),
                duration: Duration(seconds: 3),
              ),
            );
          } else {
            searchOnPress();
          }
        },
        label: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Search',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
        ),
        icon: Icon(Icons.search, size: 25),
      ),
    );
  }

  SizedBox talukDropdown(BuildContext context, Iterable<Records> talukList) {
    return SizedBox(
      height: 60,
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.business_rounded),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          iconSize: 30,
          isDense: true,
          iconDisabledColor: Theme.of(context).accentColor,
          hint: Text("Select Taluk"),
          dropdownColor: Colors.white,
          iconEnabledColor: Theme.of(context).primaryColor,
          underline: Container(
            color: Colors.orange[50],
          ),
          value: _selectedTaluk,
          items: talukList.map((value) {
            return DropdownMenuItem<String>(
              value: value.teshilTaluk,
              child: Text(value.teshilTaluk!),
            );
          }).toList(),
          onChanged: (value) {
            talukOnChange(value);
          },
        ),
      ),
    );
  }

  SizedBox districtDropdown(BuildContext context, List<Records> districtList) {
    return SizedBox(
      height: 60,
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.business_rounded),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          iconSize: 30,
          isDense: true,
          iconDisabledColor: Theme.of(context).accentColor,
          hint: Text("Select District"),
          dropdownColor: Colors.white,
          iconEnabledColor: Theme.of(context).primaryColor,
          underline: Container(
            color: Colors.orange[50],
          ),
          value: _selectedDistrict,
          items: districtList.map((value) {
            return DropdownMenuItem<String>(
              value: value.district,
              child: Text(value.district!),
            );
          }).toList(),
          onChanged: (value) {
            districtOnChange(value);
          },
        ),
      ),
    );
  }

  void talukOnChange(String? value) {
    return setState(
      () {
        _selectedTaluk = value;
      },
    );
  }

  void searchOnPress() {
    return setState(() {
      _selectedTK = _selectedTaluk;
    });
  }

  void districtOnChange(String? value) {
    return setState(
      () {
        _selectedTaluk = null;
        _selectedDistrict = value;
      },
    );
  }

  // ignore: non_constant_identifier_names
  DataColumn DataTableColumn1() {
    return DataColumn(label: Text('District'), tooltip: 'represents District');
  }

  // ignore: non_constant_identifier_names
  DataColumn DataTableColumn2() {
    return DataColumn(label: Text('Taluk'), tooltip: 'represents Taluk');
  }

  // ignore: non_constant_identifier_names
  DataRow DataTableRow(Records data) {
    return DataRow(cells: [
      DataCell(Text(data.district!)),
      DataCell(Text(data.teshilTaluk!))
    ]);
  }
}
