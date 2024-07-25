import 'package:desktop/src/models/ApiModel.dart';
import 'package:desktop/src/models/EndpointModel.dart';
import 'package:desktop/src/models/KpiModel.dart';
import 'package:desktop/src/models/ResponseModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailContentNotifier extends StateNotifier<Kpi?> {
  DetailContentNotifier() : super(null);

  void updateKpi(Kpi kpi) {
    state = kpi;
  }

  void setKpi(Kpi kpi) {
    state = kpi;
  }

  void removeKpi() {
    state = null;
  }

  void setKpiTitle(String title) {
    if (state != null) {
      state = state!.copyWith(title: title);
    }
    print(state);
  }

  void setKpiApi(Api api) {
    if (state != null) {
      state = state!.copyWith(resetEndpointId: true);
    }
    print(state);
  }

  void setKpiEndpoint(Endpoint endpoint) {
    if (state != null) {
      state = state!.copyWith(endpointId: endpoint.endpointId);
    }
    print(state);
  }

  void setKpiEntry(String entry) {
    if (state != null) {
      state = state!.copyWith(entry: entry);
    }
    print(state);
  }

  void setKpiResponses(List<Response> responses) {
    if (state != null) {
      state = state!.copyWith(responses: responses);
    }
    print(state);
  }
}
