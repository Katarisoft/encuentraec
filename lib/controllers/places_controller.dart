import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../models/place.dart';
import '../services/location_service.dart';

enum EstadoCarga { cargando, exito, error }

/// Fuente única de verdad de los lugares y de la posición del usuario —
/// Sesiones 4 y 5. La lista (`lugares`) y su estado de carga nacieron en la
/// Sesión 4 para `HomeScreen`; desde la Sesión 5 el controller también
/// guarda la posición real (`posicion`, con su propio estado) para que el
/// Mapa —y, en la Sesión 6, la consulta a la Overpass API— la lean sin
/// pedirla de nuevo al sistema operativo.
class PlacesController extends GetxController {
  final RxList<Place> lugares = <Place>[].obs;
  final Rx<EstadoCarga> estado = EstadoCarga.cargando.obs;
  final RxString mensajeError = ''.obs;
  final Rx<Position?> posicion = Rx<Position?>(null);
  final Rx<EstadoCarga> estadoPosicion = EstadoCarga.cargando.obs;
  final RxString mensajeErrorPosicion = ''.obs;

  /// Estado derivado (Sesión 4, Paso 5): se calcula a partir de `lugares`.
  int get total => lugares.length;

  /// Worker (Sesión 4, Paso 5): reacciona a cada cambio de `estado`.
  void _observarErrores() {
    ever(estado, (EstadoCarga e) {
      if (e == EstadoCarga.error) {
        Get.snackbar('Error', mensajeError.value);
      }
    });
  }

  bool _modoDebugError = false;
  bool _modoDebugVacio = false;

  @override
  void onInit() {
    _observarErrores();
    super.onInit();
    cargarLugares();
    cargarPosicion();
  }

  /// Simula uno de los 3 estados a propósito, solo para esta práctica —
  /// mismo recurso que `HomeScreen` traía desde la Sesión 3, ahora
  /// centralizado aquí para que cualquier pantalla pueda mostrarlos.
  void simular(String modo) {
    _modoDebugError = modo == 'error';
    _modoDebugVacio = modo == 'vacio';
    cargarLugares();
  }

  Future<void> cargarLugares() async {
    estado.value = EstadoCarga.cargando;
    try {
      final resultado = await fetchLugaresSimulado(
        forzarError: _modoDebugError,
        forzarVacio: _modoDebugVacio,
      );
      lugares.assignAll(resultado);
      ordenarPorCercania();
      estado.value = EstadoCarga.exito;
    } catch (e) {
      mensajeError.value = '$e';
      estado.value = EstadoCarga.error;
    }
  }

  /// Pide la posición real al sistema operativo una sola vez y la deja en
  /// [posicion]; si ya la tiene, no vuelve a pedirla salvo que se pida con
  /// [forzar] (por ejemplo, desde el botón "Reintentar" del Mapa).
  Future<void> cargarPosicion({bool forzar = false}) async {
    if (posicion.value != null && !forzar) {
      estadoPosicion.value = EstadoCarga.exito;

      // Por si los lugares se cargaron después de una posición previa.
      ordenarPorCercania();
      return;
    }

    estadoPosicion.value = EstadoCarga.cargando;

    try {
      posicion.value = await LocationService.obtenerPosicionActual();
      estadoPosicion.value = EstadoCarga.exito;

      // Ya hay posición: reordenar desde el más cercano.
      ordenarPorCercania();
    } on LocationException catch (e) {
      mensajeErrorPosicion.value = e.mensaje;
      estadoPosicion.value = EstadoCarga.error;
    } catch (e) {
      mensajeErrorPosicion.value = '$e';
      estadoPosicion.value = EstadoCarga.error;
    }
  }

  /// Agrega un lugar creado a mano (`AddPlaceScreen`) — en memoria
  /// únicamente hasta que la Sesión 7 lo persista con Hive. `lugares.add`
  /// (en vez de reconstruir toda la lista) ya notifica a cualquier `Obx`
  /// que esté escuchando, en Inicio y en el Mapa a la vez.
  void agregarLugar(Place lugar) {
    lugaresEjemplo.add(lugar);
    lugares.add(lugar);
  }

  /// Favoritos en memoria — Paso 6 (opcional). Viven solo mientras la app
  /// está abierta; la Sesión 7 los persiste con Hive, sin cambiar los
  /// nombres de abajo (`favoritos`, `esFavorito`, `alternarFavorito`).
  final RxList<Place> favoritos = <Place>[].obs;

  bool esFavorito(Place lugar) => favoritos.any((p) => p.id == lugar.id);

  /// Otro estado derivado: se calcula a partir de `favoritos`, no se guarda.
  int get totalFavoritos => favoritos.length;

  void alternarFavorito(Place lugar) {
    if (esFavorito(lugar)) {
      favoritos.removeWhere((p) => p.id == lugar.id);
    } else {
      favoritos.add(lugar);
    }
  }

  double? distanciaA(Place lugar) {
    final pos = posicion.value;
    return pos == null ? null : distanciaAPlaceEnMetros(pos, lugar);
  }

  void ordenarPorCercania() {
    // Sin posición aún, no hay distancia real que usar para ordenar.
    // Conservamos el orden en el que llegaron los lugares.
    if (posicion.value == null) {
      return;
    }

    // sort() modifica la lista, por eso trabajamos sobre una copia.
    final ordenados = lugares.toList();

    ordenados.sort((a, b) {
      final metrosA = distanciaA(a);
      final metrosB = distanciaA(b);

      // Ambos no tienen distancia calculable:
      // se consideran iguales y permanecen en su posición relativa.
      if (metrosA == null && metrosB == null) {
        return 0;
      }

      // El que no tiene distancia se mueve al final.
      if (metrosA == null) {
        return 1;
      }

      if (metrosB == null) {
        return -1;
      }

      // Menos metros significa que debe aparecer antes.
      return metrosA.compareTo(metrosB);
    });

    // Reemplaza la RxList y notifica a los Obx que muestran la lista.
    lugares.assignAll(ordenados);
  }
}
