import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kandostum2/app/modules/locations/controllers/location_controller.dart';
import 'package:kandostum2/app/shared/helpers/snackbar_helper.dart';
import 'package:kandostum2/app/shared/helpers/validator.dart';
import 'package:kandostum2/app/shared/masks.dart';
import 'package:kandostum2/app/shared/widgets/dialogs/back_dialog.dart';
import 'package:kandostum2/app/shared/widgets/forms/button_input_field.dart';
import 'package:kandostum2/app/shared/widgets/forms/custom_input_field.dart';
import 'package:kandostum2/app/shared/widgets/forms/list_tile_header.dart';
import 'package:kandostum2/app/shared/widgets/forms/submit_button.dart';
import 'package:provider/provider.dart';
import 'package:search_cep/search_cep.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';


class EditorLocationsPage extends StatefulWidget {
  @override
  _EditorLocationsPageState createState() => _EditorLocationsPageState();
}

class _EditorLocationsPageState extends State<EditorLocationsPage> {
  final _formKey = new GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _cepController = MaskedTextController(mask: Mask.cepMask);
  final _addressController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementoController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _ufController = TextEditingController();
  final _urlController = TextEditingController();
  final _phoneController = TextEditingController();
  LocationController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= Provider.of<LocationController>(context);
    _controller.clearLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ufController.dispose();
    _urlController.dispose();
    _phoneController.dispose();
    _cepController.dispose();
    _addressController.dispose();
    _numberController.dispose();
    _complementoController.dispose();
    _neighborhoodController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  _save() {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      _controller.save();
      Navigator.pop(context);
    }
  }

  _onSearchCep(text) async {
    final infoCepJSON = await ViaCepSearchCep.searchInfoByCep(cep: text);
    if (infoCepJSON.searchCepError == null) {
      _addressController.text = infoCepJSON.logradouro;
      _neighborhoodController.text = infoCepJSON.bairro;
      _stateController.text = infoCepJSON.uf;
      _cityController.text = infoCepJSON.localidade;
    } else {
      SnackBarHelper.showFailureMessage(
        context,
        title: 'Hata',
        message: infoCepJSON.searchCepError.errorMessage ?? '',
      );
    }
  }

  Future<bool> _requestPop() {
    return showDialog(
          context: context,
          builder: (context) {
            return BackDialog(
              onConfirm: () => Navigator.of(context).pop(false),
              onCancel: () => Navigator.of(context).pop(true),
              title: 'Konumlar',
              msg: 'Yerlerin Kayd??',
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Ba?????? Yeri Bildir'),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Observer(builder: (_) {
                    return CustomInputField(
                      busy: _controller.busy,
                      controller: _nameController,
                      label: 'Ba?????? Yeri Ad??',
                      onSaved: (value) {
                        _controller.location.name = value;
                      },
                      validator: Validator.isNotEmptyText,
                    );
                  }),
                  ListTileHeader('??leti??im', leftPadding: 0.0),
                  Observer(builder: (_) {
                    return CustomInputField(
                      busy: _controller.busy,
                      controller: _phoneController,
                      textInputType: TextInputType.number,
                      label: 'Telefon Numaras??',
                      onSaved: (value) {
                        _controller.location.phone = value;
                      },
                    );
                  }),
                  Observer(builder: (_) {
                    return CustomInputField(
                      busy: _controller.busy,
                      controller: _urlController,
                      label: 'Site',
                      onSaved: (value) {
                        _controller.location.url = value;
                      },
                    );
                  }),
                  ListTileHeader('Konum/B??lge', leftPadding: 0.0),
                  Observer(builder: (_) {
                    return ButtonInputField(
                      busy: _controller.busy,
                      controller: _cepController,
                      textInputType: TextInputType.number,
                      label: 'Posta Kodu',
                      onSaved: (value) {
                        _controller.location.cep = value;
                      },
                      onPressed: _onSearchCep,
                    );
                  }),
                  Observer(builder: (_) {
                    return CustomInputField(
                      busy: _controller.busy,
                      controller: _addressController,
                      label: 'Adres',
                      onSaved: (value) {
                        _controller.location.address = value;
                      },
                      validator: Validator.isNotEmptyText,
                    );
                  }),
                  Observer(builder: (_) {
                    return CustomInputField(
                      busy: _controller.busy,
                      controller: _numberController,
                      label: 'Numara',
                      onSaved: (value) {
                        _controller.location.number = value;
                      },
                      validator: Validator.isNotEmptyText,
                    );
                  }),
                  Observer(builder: (_) {
                    return CustomInputField(
                      busy: _controller.busy,
                      controller: _complementoController,
                      label: 'Cadde/Sokak',
                      onSaved: (value) {
                        _controller.location.complemento = value;
                      },
                      validator: Validator.isNotEmptyText,
                    );
                  }),
                  Observer(builder: (_) {
                    return CustomInputField(
                      busy: _controller.busy,
                      controller: _neighborhoodController,
                      label: '??l??e',
                      onSaved: (value) {
                        _controller.location.neighborhood = value;
                      },
                      validator: Validator.isNotEmptyText,
                    );
                  }),
                  Observer(builder: (_) {
                    return CustomInputField(
                      busy: _controller.busy,
                      controller: _cityController,
                      label: '??l',
                      onSaved: (value) {
                        _controller.location.city = value;
                      },
                      validator: Validator.isNotEmptyText,
                    );
                  }),
                  Observer(builder: (_) {
                    return CustomInputField(
                      busy: _controller.busy,
                      controller: _stateController,
                      label: 'B??lge',
                      onSaved: (value) {
                        _controller.location.state = value;
                      },
                      validator: Validator.isNotEmptyText,
                    );
                  }),
                  SizedBox(height: 20),
                  Observer(
                    builder: (_) {
                      return SubmitButton(
                        label: 'Kaydet ve ??let',
                        busy: _controller.busy,
                        firstColor: Theme.of(context).accentColor,
                        secondColor: Theme.of(context).primaryColor,
                        onTap: _save,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
