import 'package:safedropadminpanel/views/integrations/integrations_state.dart';
import 'package:flareline_uikit/core/mvvm/bloc/bloc_base_viewmodel.dart';
import 'package:flutter/material.dart';

class IntegrationsViewModel extends BlocBaseViewModel<IntegrationsState> {
  IntegrationsViewModel(BuildContext context)
    : super(context, IntegrationsState());
}
