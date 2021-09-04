import 'package:agendacontatos/model/contact.dart';
import 'package:agendacontatos/repository/contact_repository.dart';
import 'package:agendacontatos/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;
  ContactPage({Key? key, this.contact}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _contact = Contact();
  bool _hasChanges = false;
  final _nameFocus = FocusNode();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final repository = ContactRepository();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _contact = Contact.fromMap(widget.contact!.toMap());
      _nameController.text = _contact.name!;
      _emailController.text = _contact.email!;
      _phoneController.text = _contact.phone!;
    } 
  }

  Future<bool> _requestPop() {
    if (_hasChanges) {
      showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text("Descartar alterações?"),
            content: Text("Se sair as alterações serão perdidas."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(buildcontext);
                },
                child: Text("Cancelar")
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(buildcontext);
                  Navigator.pop(buildcontext);
                },
                child: Text("Sim")
              )
            ],
          );
        }
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      backgroundColor: Colors.red,
      title: Text(_contact.name ?? "Novo contato"),
      centerTitle: true,
      
    );
  }

  Widget container() {
    return Container(
      width: 140.0,
      height: 140.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: _contact.image == null ?
           AssetImage("assets/person.png") :
           Utils.recoveryContactImage(_contact.image!) 
        )
      ),
    );
  }

  Widget image() {
    return GestureDetector(
      child: container(),
      onTap: () {
        new ImagePicker().pickImage(source: ImageSource.camera).then((file) {
          if (file != null) {
            setState(() {
              _contact.image = file.path;
            });
          }
        });
      },
    );
  }

  Widget textField(TextEditingController? controller,
    String label, FocusNode? focus,
    ValueChanged<String>? onChanged,
    TextInputType? textInputType) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      focusNode: focus,
      onChanged: onChanged,
      keyboardType: textInputType,
    );
  }

  Widget body() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          image(),
          textField(_nameController, "Nome", _nameFocus, (name) {
            _hasChanges = true;
            setState(() {
              _contact.name = name;
            });
          }, null),
          textField(_emailController, "E-mail", null, (email) {
            _hasChanges = true;
            _contact.email = email;
          }, TextInputType.emailAddress),
           textField(_phoneController, "Phone", null, (phone) {
            _hasChanges = true;
            _contact.phone = phone;
          }, TextInputType.phone),
        ],
      ),
    );
  }

  Widget floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (_contact.name != null && _contact.name!.isNotEmpty) {
          Navigator.pop(context, _contact);
          return;
        }
        FocusScope.of(context).requestFocus(_nameFocus);
      },
      child: Icon(Icons.save),
      backgroundColor: Colors.red,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: appBar(),
        body: body(),
        floatingActionButton: floatingActionButton(context),
      ),
    );
  }
}