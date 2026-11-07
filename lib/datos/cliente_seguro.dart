import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../dominio/excepciones.dart';

/// Único punto de salida a internet de toda la app.
/// Aquí viven las defensas: https obligatorio, timeout, límite de tamaño,
/// JSON validado y errores traducidos. Las 5 APIs pasan por aquí.
class ClienteSeguro {
  final http.Client _cliente;
  final Duration espera;
  final int maxBytes;

  ClienteSeguro(this._cliente,
      {this.espera = const Duration(seconds: 8), this.maxBytes = 1024 * 1024});

  static const _cabeceras = {
    'Accept': 'application/json',
    'User-Agent': 'DoloresHoy/1.0 (curso Flutter UTNG)',
  };

  Future<dynamic> obtenerJson(Uri uri) async {
    if (uri.scheme != 'https') throw const ConexionInseguraException();

    http.Response r;
    try {
      r = await _cliente.get(uri, headers: _cabeceras).timeout(espera);
    } on SocketException {
      throw const SinConexionException();
    } on TimeoutException {
      throw const SinConexionException();
    } on http.ClientException {
      throw const SinConexionException();
    }

    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw ErrorServidorException(r.statusCode);
    }
    if (r.bodyBytes.length > maxBytes) {
      throw const RespuestaDemasiadoGrandeException();
    }
    try {
      return jsonDecode(utf8.decode(r.bodyBytes));
    } catch (_) {
      throw const RespuestaInvalidaException();
    }
  }

  /// Versión de la URL segura para escribir en logs: oculta claves.
   /// Versión de la URL segura para escribir en logs: oculta claves.
  static String redactar(Uri uri) {
    const secretos = {'api_key', 'apikey', 'key', 'token', 'access_token'};
    final texto = uri.toString();
    final inicio = texto.indexOf('?');
    if (inicio < 0) return texto;

    final finConsulta = texto.indexOf('#', inicio);
    final consulta = texto.substring(
        inicio + 1, finConsulta < 0 ? texto.length : finConsulta);
    final resto = finConsulta < 0 ? '' : texto.substring(finConsulta);

    final partes = consulta.split('&').map((par) {
      final i = par.indexOf('=');
      if (i < 0) return par;
      final nombre = Uri.decodeQueryComponent(par.substring(0, i)).toLowerCase();
      return secretos.contains(nombre) ? '${par.substring(0, i)}=***' : par;
    }).join('&');

    return '${texto.substring(0, inicio)}?$partes$resto';
  }
}

/// Envuelve la conversión JSON→objeto: si el servidor cambia su formato,
/// el usuario ve un error claro y no un crash.
T convertir<T>(T Function() f) {
  try {
    return f();
  } catch (_) {
    throw const RespuestaInvalidaException();
  }
}
