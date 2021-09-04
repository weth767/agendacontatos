import 'package:agendacontatos/model/contact.dart';
import 'package:agendacontatos/repository/contact_repository.dart';
import 'package:agendacontatos/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_page.dart';

enum OrderOptions {ASC, DESC}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactRepository contactRepository = ContactRepository();
  List<Contact> contacts = List.empty();

  @override
  void initState() {
    super.initState();
    contactRepository.getAll().then((value) {
        setState(() {
          contacts = value;
        });
      });
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text("Contatos"),
      backgroundColor: Colors.red,
      centerTitle: true,
      actions: [
        PopupMenuButton<OrderOptions> (
          itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
            const PopupMenuItem<OrderOptions>(
              child: Text("Ordenar crescente"),
              value: OrderOptions.ASC,
            ),
            const PopupMenuItem<OrderOptions>(
              child: Text("Ordenar decrescente"),
              value: OrderOptions.DESC,
            ),
          ],
          onSelected: _orderList,
        )
      ],
    );
  }

  Widget floatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _showContactPage(null),
      child: Icon(Icons.add),
      backgroundColor: Colors.red,
    );
  }

  Widget container(int index) {
    return Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: contacts[index].image == null ?
           AssetImage("assets/person.png") :
           Utils.recoveryContactImage(contacts[index].image!) 
        )
      ),
    );
  }

  Widget padding(int index) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contacts[index].name ?? "",
            style: TextStyle(fontSize: 22.0,
              fontWeight: FontWeight.bold),
          ),
          Text(contacts[index].email ?? "",
            style: TextStyle(fontSize: 18.0),
          ),
          Text(contacts[index].phone ?? "",
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  Widget card(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showOptions(context, index);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              container(index),
              padding(index)
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: contacts.length,
      itemBuilder: (BuildContext context, int index) {
        return card(context, index);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      floatingActionButton: floatingActionButton(),
      body: body(),
    );
  }

  void _getAll() {
    contactRepository.getAll().then((value) => {
      setState(() {
        contacts = value;
      })
    });
  }

  void _showContactPage(Contact? contact) async {
    dynamic record = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => 
        ContactPage(contact: contact,))
    );
    if (record != null) {
      if (contact != null) {
        await contactRepository.update(record);
      } else {
        await contactRepository.save(record);
      }
      _getAll();
    }
  }

  void _orderList(OrderOptions orderOptions) {
    setState(() {
      if (orderOptions == OrderOptions.ASC) {
        contacts.sort((a, b) {
          return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
        });
        return;
      }
      contacts.sort((a, b) {
        return b.name!.toLowerCase().compareTo(a.name!.toLowerCase());
      });
    });
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: () {
                        launch("tel:${contacts[index].phone}}");
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Ligar",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showContactPage(contacts[index]);
                      },
                      child: Text(
                        "Editar",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: () {
                        contactRepository.delete(contacts[index].id!);
                        setState(() {
                          contacts.removeAt(index);
                          Navigator.pop(context);
                        });
                      },
                      child: Text(
                        "Deletar",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      )
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }
}