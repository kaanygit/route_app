import 'package:accesible_route/bloc/language/language_bloc.dart';
import 'package:accesible_route/bloc/places/places_bloc.dart';
import 'package:accesible_route/bloc/places/places_event.dart';
import 'package:accesible_route/bloc/places/places_state.dart';
import 'package:accesible_route/models/place_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'place_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Place> _allPlaces = [];
  List<Place> _filteredPlaces = [];
  late String _currentLanguage = "tr";

  @override
  void initState() {
    super.initState();
    context.read<PlacesBloc>().add(PlacesInformationGets());
    _searchController.addListener(_filterPlaces);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPlaces() {
    String query = _searchController.text.toLowerCase();
    List<Place> newFilteredPlaces = _allPlaces.where((place) {
      String title = _currentLanguage == "tr" ? place.titleTr : place.titleEng;
      return title.toLowerCase().contains(query);
    }).toList();

    setState(() {
      _filteredPlaces = newFilteredPlaces;
    });
  }

  Widget _buildItem(Place place) {
    String title = _currentLanguage == "tr" ? place.titleTr : place.titleEng;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceScreen(placeIndex: place.key),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                place.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 100,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _currentLanguage =
        BlocProvider.of<LanguageBloc>(context).state.locale.languageCode;
    return Scaffold(
      body: BlocBuilder<PlacesBloc, PlacesState>(
        builder: (context, state) {
          if (state is PlacesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlacesSuccess) {
            _allPlaces = state.places;

            if (_filteredPlaces.isEmpty && _searchController.text.isNotEmpty) {
              _filterPlaces();
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey.shade200,
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            _currentLanguage == "tr" ? 'Ara...' : 'Search...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.purple),
                        contentPadding: const EdgeInsets.all(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _searchController.text.isNotEmpty
                        ? _filteredPlaces.isEmpty
                            ? Center(
                                child: Text(
                                  _currentLanguage == "tr"
                                      ? 'Sonuç bulunamadı. Arama terimlerini kontrol edin.'
                                      : 'No results found. Please check your search terms.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : ListView.builder(
                                itemCount: _filteredPlaces.length,
                                itemBuilder: (context, index) {
                                  return _buildItem(_filteredPlaces[index]);
                                },
                              )
                        : Center(
                            child: Text(
                              _currentLanguage == "tr"
                                  ? 'Aramak istediğiniz bir yer yok mu? Hadi başlayalım!'
                                  : 'Don’t have a place to search? Let’s get started!',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                  ),
                ],
              ),
            );
          } else if (state is PlacesFailure) {
            return Center(child: Text(state.error));
          }
          return Container();
        },
      ),
    );
  }
}
