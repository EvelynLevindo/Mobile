import 'package:biblioteca_app_json/controller/user_controller.dart';
import 'package:biblioteca_app_json/model/user_model.dart';
import 'package:biblioteca_app_json/view/user_form_page.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  // Atributos 
  List<UsuarioModel> _users =[];
  // Permiti o filtro de usuários
  final _userSearch = TextEditingController(); // Campo para digitar o nome do usuário
  List<UsuarioModel> _filterUsers = [];
  bool _isLoading = true;
  String _error = "";
  final _userController = UsuarioController();

  // Métodos
  @override
  void initState() { // Sempre que preciso carregar informações antes da construção da página, usa o método initState
    // TODO: implement initState
    super.initState();
  }

  void _load() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _users = await _userController.fetchAll();
      _filterUsers = _users;
    } catch (e) {
      // Tratar o erro
      _error = e.toString();
    }
    setState(() {
      _isLoading = false;
    });
  }
  
  // Método para filtragem da lista de usuários
  void _usersFilter(){
    final query = _userSearch.text.toLowerCase();
    setState(() {
      // Fazendo um filtro por partes do nome ou parte do email
      _filterUsers = _users.where((user){
        return user.nome.toLowerCase().contains(query) || user.email.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Método de navegação para a página do cadastro de usuário
  void _openForm ({UsuarioModel? user}) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => UserFormPage (user: user)));
    // Quando eu voltar para a página de listagem de usuário, recarregue a lista de usuários
    _load();
  }

  void _delete(UsuarioModel user) async {
    final confirm = await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Confimar Exclusão"),
        content: Text("Deseja realmente excluir o usuário ${user.nome}"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Excluir"))
        ],
      ));

      if(confirm) {
        try {
          await _userController.delete(user.id!);
        } catch (e) {
          // Criar uma mensagem de erro
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Não precisa de appBar, ele já está no home
      body: _isLoading
      ? Center(child: CircularProgressIndicator(),)
      : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _userSearch,
              decoration: InputDecoration(
                labelText: "Pesquisar Usuário",
                border: OutlineInputBorder()
              ),
              onChanged: (value) => _usersFilter(),
            ),
            SizedBox(height: 16,),
            Expanded(child: ListView.builder(
              itemCount: _filterUsers.length,
              itemBuilder: (context, index){
                final user = _filterUsers[index];
                return Card(
                  child: ListTile(
                    title: Text(user.nome),
                    subtitle: Text(user.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () => _openForm(user: user), icon: Icon(Icons.edit)),
                        IconButton(onPressed: () => _delete(user), icon: Icon(Icons.delete, color: Colors.red,))
                      ],
                    ),
                  ),
                );
              }))
          ],
        ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () => _openForm(), child: Icon(Icons.add),),
    );
  }
}