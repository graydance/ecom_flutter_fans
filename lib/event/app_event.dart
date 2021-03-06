import 'dart:convert';

import 'package:fans/storage/auth_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/js.dart' as js;

class AppEvent {
  final List<AnalyticsProvider> providers;

  AppEvent(this.providers);

  static AppEvent get shared => AppEvent([
        FirebaseAnalyticsProvider(),
        FacebookWebAnalyticsProvider(),
      ]);

  Future<void> report(
      {@required AnalyticsEvent event,
      Map<AnalyticsEventParameter, dynamic> parameters}) async {
    final eventIsEnable = await AuthStorage.getBool('EventIsEnable');
    debugPrint(
        '>>> AppEvent report: ${event.name} $parameters | eventIsEnable: $eventIsEnable');
    if (eventIsEnable != null && eventIsEnable == false) {
      return Future.value();
    }

    return Future.wait(providers.map(
        (provider) => provider.report(event: event, parameters: parameters)));
  }

  FirebaseAnalyticsObserver get firebaseAnalyticsObserver {
    FirebaseAnalyticsProvider firebaseAnalyticsProvider =
        providers.firstWhere((element) => element is FirebaseAnalyticsProvider);
    if (firebaseAnalyticsProvider == null) {
      throw Exception('FirebaseAnalyticsProvider not found');
    }

    return FirebaseAnalyticsObserver(
        analytics: firebaseAnalyticsProvider.analytics);
  }
}

enum AnalyticsEvent {
  splash,
  shoplink_view,
  grid_display_c,
  grid_click_c,
  product_view_c,
  add_to_cart,
  buy_now,
  check_out,
  continue_to_payment,
  pay,
  pay_success,
  pay_failed,
}

enum AnalyticsEventParameter {
  id,
  type,
}

extension AnalyticsEventExtension on AnalyticsEvent {
  String get name => EnumToString.convertToString(this);
}

extension AnalyticsEventParameterExtension on AnalyticsEventParameter {
  String get name => EnumToString.convertToString(this);
}

abstract class AnalyticsProvider {
  Future<void> report(
      {@required AnalyticsEvent event,
      Map<AnalyticsEventParameter, dynamic> parameters});
}

class FirebaseAnalyticsProvider extends AnalyticsProvider {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Future<void> report(
      {AnalyticsEvent event,
      Map<AnalyticsEventParameter, dynamic> parameters}) {
    Map<String, dynamic> maps = {};
    if (parameters != null) {
      for (var key in parameters.keys) {
        maps.addAll({key.name: parameters[key]});
      }
    }
    return analytics.logEvent(name: event.name, parameters: maps);
  }
}

class FacebookWebAnalyticsProvider extends AnalyticsProvider {
  @override
  Future<void> report(
      {AnalyticsEvent event,
      Map<AnalyticsEventParameter, dynamic> parameters}) {
    if (!kIsWeb) return Future.value();

    Map<String, dynamic> maps = {};
    if (parameters != null) {
      for (var key in parameters.keys) {
        maps.addAll({key.name: parameters[key]});
      }
    }
    js.context.callMethod('fb_logEvent', [event.name, json.encode(maps)]);

    return Future.value();
  }
}
