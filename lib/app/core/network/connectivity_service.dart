import 'dart:async';

import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _singletonInstance = ConnectivityService._internal();

  factory ConnectivityService() {
    return _singletonInstance;
  }

  ConnectivityService._internal();

  static var _isInternet = false;
  static late Function? _onInternetState;

  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  static late List<ConnectivityResult> _connectivityResult;

  static bool get isInternet => _isInternet;

  static Future<void> onStream({Function? onInternetState}) async {
    _onInternetState = onInternetState;
    if (_connectivitySubscription == null) {
      await _initConnectivity();
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    }
  }

  static Future<void> _initConnectivity() async {
    try {
      debugPrint("NetworkConnectivityService init");
      _connectivityResult = await _connectivity.checkConnectivity();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    debugPrint("connectivityResult: $connectivityResult");
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.vpn)) {
      _isInternet = true;
      _onInternetState?.call(true);
    } else {
      _isInternet = false;
      _onInternetState?.call(false);
    }
  }

  static Future<void> cancelConnectivitySubs() async {
    try {
      if (_connectivitySubscription != null) {
        _connectivitySubscription?.cancel();
      }
    } catch (e) {
      debugPrint("Error canceling subscription: ${e.toString()}");
    }
  }

  static Future<bool> isInternetConnected() async {
    _connectivityResult = await (_connectivity.checkConnectivity());
    return _onInternetStatus(_connectivityResult);
  }

  static bool _onInternetStatus(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.vpn)) {
      _isInternet = true;
      return _isInternet;
    } else {
      return false;
    }
  }
}

Object closeInternetAlertDialog({
  required BuildContext context,
  bool barrierDismissible = true,
  Widget icon = const Icon(Icons.network_check_outlined, size: 42, color: Colors.red),
  String? title,
  String btnName = "Close",
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        titlePadding: const EdgeInsets.only(top: 12, left: 12, right: 12),
        iconPadding: const EdgeInsets.only(top: 20),
        icon: icon,
        title: Center(
          child: Text(
            title ??
                "No internet connection. Make sure that Wi-Fi or mobile data is "
                    "turnedon, then try again",
            maxLines: 10,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(bottom: 17, top: 21, left: 41, right: 41),
        actions: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 73,
              height: 29,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,

                ///Use for gradient color,
                // gradient: const LinearGradient(
                //   colors: [
                //     Color(0xFFFF9760),
                //     Color(0xFFFC2C00),
                //   ],
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   stops: [0.0, 1.5],
                // ),
                borderRadius: BorderRadius.circular(8),

                ///Use for button box shadow
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.1),
                //     spreadRadius: 0,
                //     blurRadius: 1,
                //     offset:
                //         const Offset(0, 2), // changes position of shadow
                //   ),
                // ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(btnName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white)),
                  const SizedBox(width: 2),
                  const Icon(Icons.close, size: 12, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      );
    },
    barrierDismissible: barrierDismissible,
  );
}
