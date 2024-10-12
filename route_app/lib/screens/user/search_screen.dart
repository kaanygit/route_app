import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_app/bloc/places/places_bloc.dart';
import 'package:route_app/bloc/places/places_event.dart';
import 'package:route_app/bloc/places/places_state.dart';
import 'package:route_app/constants/style.dart';
import 'package:route_app/models/place_model.dart';
import 'place_screen.dart'; // PlaceScreen dosyanızı buraya dahil edin.

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Place> _allPlaces = [];
  List<Place> _filteredPlaces = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

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
    List<Place> newFilteredPlaces = _allPlaces
        .where((place) => place.title.toLowerCase().contains(query))
        .toList();

    if (newFilteredPlaces.length != _filteredPlaces.length) {
      for (int i = _filteredPlaces.length - 1; i >= 0; i--) {
        if (!newFilteredPlaces.contains(_filteredPlaces[i])) {
          _listKey.currentState?.removeItem(
            i,
            (context, animation) => _buildItem(_filteredPlaces[i], animation),
            duration: Duration(milliseconds: 300),
          );
        }
      }

      for (int i = 0; i < newFilteredPlaces.length; i++) {
        if (i >= _filteredPlaces.length ||
            newFilteredPlaces[i] != _filteredPlaces[i]) {
          _listKey.currentState
              ?.insertItem(i, duration: Duration(milliseconds: 300));
        }
      }
    }

    setState(() {
      _filteredPlaces = newFilteredPlaces;
    });
  }

  Widget _buildItem(Place place, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: GestureDetector(
        onTap: () {
          // Tıklandığında PlaceScreen'e geçiş yap
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceScreen(
                  placeIndex:
                      place.key), // Burada place.key değerini kullanıyoruz
            ),
          );
        },
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 8),
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
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    place.title,
                    style: TextStyle(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlacesBloc, PlacesState>(
        builder: (context, state) {
          if (state is PlacesLoading) {
            return Center(child: CircularProgressIndicator());
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
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey.shade200,
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Ara...',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.purple),
                        contentPadding: EdgeInsets.all(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _searchController.text.isNotEmpty
                        ? _filteredPlaces.isEmpty
                            ? Center(
                                child: Text(
                                'Henüz bir sonuç bulunmuyor. Arama yapmaya başlayın!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ))
                            : AnimatedList(
                                key: _listKey,
                                initialItemCount: _filteredPlaces.length,
                                itemBuilder: (context, index, animation) {
                                  return _buildItem(
                                      _filteredPlaces[index], animation);
                                },
                              )
                        : Center(
                            child: Text(
                            'Aramak istediğiniz bir yer yok mu? Hadi başlayalım!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                  ),
                ],
              ),
            );
          } else if (state is PlacesFailure) {
            return Center(child: Text(state.error));
          }
          return Container(); // Durum kontrolü için boş bir konteyner
        },
      ),
    );
  }
}
