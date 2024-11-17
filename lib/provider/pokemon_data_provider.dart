import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_riverpod/model/pokemon.dart';
import 'package:pokemon_riverpod/services/pokemon_services.dart';

final pokemonDataProvider = FutureProvider.family<Pokemon?, String>(
  (ref, url) async {
    HttpServices _httpServices = GetIt.instance.get<HttpServices>();
    Response res = await _httpServices.getData(url);
    if (res.data != null) {
      return Pokemon.fromJson(res.data);
    } else {
      return null;
    }
  },
);

final favoritePokemonProvider =
    StateNotifierProvider<FavoritePokemonProvider, List<String>>(
  (ref) {
    return FavoritePokemonProvider([]);
  },
);

class FavoritePokemonProvider extends StateNotifier<List<String>> {
  FavoritePokemonProvider(
    super._state,
  ) {
    _setup();
  }

  Future<void> _setup() async {}

  void addFavoritePokemon(String url) {
    state = [...state, url];
  }

  void removeFavoritePokemon(String url) {
    state = state.where((element) => element != url).toList();
  }
}
