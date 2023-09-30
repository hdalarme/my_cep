import 'package:flutter/material.dart';
import 'package:my_cep/model/myceps_model.dart';
import 'package:my_cep/model/viacep_model.dart';
import 'package:my_cep/repositories/cep_back4app_repository.dart';
import 'package:my_cep/repositories/via_cep_repository.dart';

class CEPPage extends StatefulWidget {
  const CEPPage({super.key});

  @override
  State<CEPPage> createState() => _CEPPageState();
}

class _CEPPageState extends State<CEPPage> {
  CEPBack4AppRepository cepBack4AppRepository = CEPBack4AppRepository();
  ViaCepRepository viaCEPRepository = ViaCepRepository();
  var _mycep = MyCEPsModel([]);
  var viacep = ViaCEPModel();
  var cepController = TextEditingController(text: "");
  var carregando = false;

  @override
  void initState() {
    super.initState();
    obterCEP();
  }

  void obterCEP() async {
    setState(() {
      carregando = true;
    });
    _mycep = await cepBack4AppRepository.obterCEPs();
    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /*appBar: AppBar(
            title: const Text("Consulta de CEP"),
          ),*/

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              const Text(
                "Consulta de CEP",
                style: TextStyle(fontSize: 22),
              ),
              TextField(
                controller: cepController,
                keyboardType: TextInputType.number,
                //maxLength: 8,
                onChanged: (String value) async {
                  var cep = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (cep.length == 8) {
                    setState(() {
                      carregando = true;
                    });
                    _mycep = (await cepBack4AppRepository.consultarCEP(cep));
                    if (_mycep.myCeps.isEmpty) {
                      viacep = (await viaCEPRepository.consultarCEP(cep));
                      if (viacep.cep != null) {
                        String saveCep = viacep.cep!;
                        String saveLogradouro = viacep.logradouro!;
                        String saveComplemento = viacep.complemento!;
                        String saveBairro = viacep.bairro!;
                        String saveLocalidade = viacep.localidade!;
                        String saveUf = viacep.uf!;
                        String saveIbge = viacep.ibge!;
                        String saveGia = viacep.gia!;
                        String saveDdd = viacep.ddd!;
                        String saveSiafi = viacep.siafi!;

                        await cepBack4AppRepository.criar(MyCEPModel.criar(
                            saveCep,
                            saveLogradouro,
                            saveComplemento,
                            saveBairro,
                            saveLocalidade,
                            saveUf,
                            saveIbge,
                            saveGia,
                            saveDdd,
                            saveSiafi));


                        setState(() {});
                      }
                    }
                        obterCEP();
                  }
                  setState(() {
                    carregando = false;
                  });
                },
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                viacep.logradouro ?? "",
                style: const TextStyle(fontSize: 22),
              ),
              Text(
                "${viacep.localidade ?? ""} - ${viacep.uf ?? ""}",
                style: const TextStyle(fontSize: 22),
              ),
              if (carregando) const CircularProgressIndicator(),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "CEP Cadastrados",
                style: TextStyle(fontSize: 22),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _mycep.myCeps.length,
                  itemBuilder: (BuildContext bc, int index) {
                    var myCep = _mycep.myCeps[index];
                    return Dismissible(
                        onDismissed: (DismissDirection dismissDirection) async {
                          await cepBack4AppRepository.remover(myCep.objectId);
                          obterCEP();
                        },
                        key: Key(myCep.cep),
                        child: ListTile(
                          title: Text(myCep.cep),
                          subtitle: Text(
                              "${myCep.logradouro}, ${myCep.localidade} - ${myCep.uf}"),
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
        /*floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {},
        ),*/
        /*body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                carregando
                ? const CircularProgressIndicator()
                : Expanded(
                  child: ListView.builder(
                    itemCount: _mycep.results.length,
                    itemBuilder: (BuildContext bc, int index) {
                      var cep = _mycep.results[index];
                      return Dismissible(
                        onDismissed: (DismissDirection dismissDirection) async {
                          //await cepBack4AppRepository.remove(cep.objectId);
                          obterCEP();
                        },
                        //key: Key(cep!.objectId), 
                        key: Key(cep.objectId!),
                        child: const ListTile(
                          title: Text("cep.cep"),
                        )
                      );
                    }
                  ),
                ),
              ],
            ),
          ),*/
      ),
    );
  }
}
