import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_riverpod/model/page_data.dart';
import 'package:pokemon_riverpod/model/pokemon.dart';
import 'package:pokemon_riverpod/services/pokemon_services.dart';

class HomePageController extends StateNotifier<HomePageData> {
  final GetIt _getIt = GetIt.instance;
  late HttpServices _httpServices;

  HomePageController(
    super._state,
  ) {
    _httpServices = _getIt.get<HttpServices>();
    getPokemonData();
  }

  Future<void> getPokemonData() async {
    if (state.data == null) {
      Response? response = await _httpServices
          .getData('https://pokeapi.co/api/v2/pokemon?limit=20&offset=0');
      if (response.data != null) {
        PokemonListData pokemonListData =
            PokemonListData.fromJson(response.data);
        state = state.copyWith(data: pokemonListData);
      }
    } else {
      if (state.data!.next != null) {
        Response? response = await _httpServices.getData(state.data!.next!);
        if (response.data != null) {
          PokemonListData pokemonListData =
              PokemonListData.fromJson(response.data);
          state = state.copyWith(
              data: pokemonListData.copyWith(results: [
            ...state.data!.results!,
            ...pokemonListData.results!
          ]));
        }
      }
    }
  }
}
