import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/i18n/i18n.dart';
import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<String>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.translations.emailLabel,
            icon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColorLight,
            ),
            errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: presenter.validateEmail,
        );
      },
    );
  }
}
