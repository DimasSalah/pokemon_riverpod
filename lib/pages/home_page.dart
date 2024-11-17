import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_riverpod/model/page_data.dart';
import 'package:pokemon_riverpod/model/pokemon.dart';
import 'package:pokemon_riverpod/pages/pokemon_list_tile.dart';

import '../controller/home_page_controller.dart';

final HomePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(
    HomePageData.initial(),
  );
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ScrollController scrollController = ScrollController();

  late HomePageController _controller;
  late HomePageData _data;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent * 1 &&
        !scrollController.position.outOfRange) {
      _controller.getPokemonData();
      // _controller.getPokemonData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller = ref.watch(HomePageControllerProvider.notifier);
    _data = ref.watch(HomePageControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.02,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _builAllPokemonList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _builAllPokemonList(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Pokemon List'),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.6,
            child: ListView.builder(
              controller: scrollController,
              itemCount: _data.data?.results?.length ?? 0,
              itemBuilder: (context, index) {
                PokemonListResult pokemon = _data.data!.results![index];
                return PokemonListTile(pokemonUrl: pokemon.url!);
              },
            ),
          )
        ],
      ),
    );
  }
}
