import 'package:flutter/material.dart';

void main() => runApp(const MovieExplorerApp());

class MovieExplorerApp extends StatefulWidget {
  const MovieExplorerApp({super.key});
  @override
  State<MovieExplorerApp> createState() => _MovieExplorerAppState();
}

class _MovieExplorerAppState extends State<MovieExplorerApp> {
  ThemeMode mode = ThemeMode.dark;
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MovieExplorer',
        themeMode: mode,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE50914)),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE50914),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF101014),
        ),
        home: ExplorerHome(
          isDark: mode == ThemeMode.dark,
          onTheme: () => setState(() =>
              mode = mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark),
        ),
      );
}

class Movie {
  final int id;
  final String title, genre, language, synopsis, age;
  final int year, minutes;
  final double rating;
  final IconData icon;
  final List<Color> colors;
  const Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.language,
    required this.synopsis,
    required this.age,
    required this.year,
    required this.minutes,
    required this.rating,
    required this.icon,
    required this.colors,
  });
}

const movieData = <Movie>[
  Movie(id: 1, title: 'The Last Horizon', genre: 'Sci-Fi', language: 'English',
    synopsis: 'A deep-space crew follows a mysterious signal beyond the edge of a known galaxy and discovers a secret that could change humanity.',
    age: 'U/A 13+', year: 2025, minutes: 142, rating: 8.7, icon: Icons.rocket_launch,
    colors: [Color(0xFF101B46), Color(0xFF3878A8)]),
  Movie(id: 2, title: 'Midnight Chase', genre: 'Action', language: 'English',
    synopsis: 'A former getaway driver has one night to protect a witness while a dangerous crew closes in across the city.',
    age: 'U/A 16+', year: 2024, minutes: 128, rating: 8.2, icon: Icons.directions_car,
    colors: [Color(0xFF4A1118), Color(0xFFDE5A32)]),
  Movie(id: 3, title: 'Monsoon Letters', genre: 'Romance', language: 'Telugu',
    synopsis: 'Two strangers begin exchanging letters during a rainy season and slowly uncover a connection from their past.',
    age: 'U', year: 2025, minutes: 116, rating: 7.9, icon: Icons.mail,
    colors: [Color(0xFF24544D), Color(0xFF8EBB91)]),
  Movie(id: 4, title: 'The Hidden Code', genre: 'Thriller', language: 'Hindi',
    synopsis: 'A young analyst finds a pattern in encrypted files and becomes the target of a secret organisation.',
    age: 'U/A 13+', year: 2023, minutes: 134, rating: 8.5, icon: Icons.memory,
    colors: [Color(0xFF25213E), Color(0xFF7661A8)]),
  Movie(id: 5, title: 'Laughing Matters', genre: 'Comedy', language: 'Hindi',
    synopsis: 'A family holiday goes hilariously wrong when every member arrives with a different surprise plan.',
    age: 'U/A 7+', year: 2024, minutes: 108, rating: 7.6, icon: Icons.theater_comedy,
    colors: [Color(0xFF8A4C13), Color(0xFFE6B34D)]),
  Movie(id: 6, title: 'Wild Kingdom', genre: 'Adventure', language: 'English',
    synopsis: 'A group of explorers journeys into an uncharted rainforest in search of a legendary lost valley.',
    age: 'U/A 7+', year: 2022, minutes: 126, rating: 8.1, icon: Icons.landscape,
    colors: [Color(0xFF174C36), Color(0xFF7EBB67)]),
  Movie(id: 7, title: 'Echoes of War', genre: 'Drama', language: 'Tamil',
    synopsis: 'Years after a conflict, a family reunites to understand the choices that shaped their lives.',
    age: 'U/A 16+', year: 2023, minutes: 151, rating: 8.4, icon: Icons.shield,
    colors: [Color(0xFF3E3530), Color(0xFFAA8060)]),
  Movie(id: 8, title: 'Deep Blue', genre: 'Sci-Fi', language: 'English',
    synopsis: 'Scientists investigating an ocean trench encounter an intelligent form of life beneath the waves.',
    age: 'U/A 13+', year: 2024, minutes: 119, rating: 7.8, icon: Icons.water,
    colors: [Color(0xFF063B56), Color(0xFF21A3B5)]),
];

const genres = ['All', 'Action', 'Adventure', 'Comedy', 'Drama', 'Romance', 'Sci-Fi', 'Thriller'];

class ExplorerHome extends StatefulWidget {
  final bool isDark;
  final VoidCallback onTheme;
  const ExplorerHome({super.key, required this.isDark, required this.onTheme});
  @override
  State<ExplorerHome> createState() => _ExplorerHomeState();
}

class _ExplorerHomeState extends State<ExplorerHome> {
  int tab = 0;
  String query = '', genre = 'All', sort = 'Recommended';
  final Set<int> watchlist = {};

  List<Movie> get filtered {
    final list = movieData.where((m) {
      final q = query.toLowerCase();
      final textMatch = m.title.toLowerCase().contains(q) ||
          m.genre.toLowerCase().contains(q) ||
          m.language.toLowerCase().contains(q);
      return textMatch && (genre == 'All' || m.genre == genre);
    }).toList();
    if (sort == 'Top Rated') list.sort((a, b) => b.rating.compareTo(a.rating));
    if (sort == 'Newest') list.sort((a, b) => b.year.compareTo(a.year));
    if (sort == 'A–Z') list.sort((a, b) => a.title.compareTo(b.title));
    return list;
  }

  void toggleSave(Movie m) => setState(() {
        watchlist.contains(m.id) ? watchlist.remove(m.id) : watchlist.add(m.id);
      });

  void openMovie(Movie m) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => MovieDetailsPage(
        movie: m,
        saved: watchlist.contains(m.id),
        onSave: () => toggleSave(m),
      ),
    )).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;
    final pages = [explorePage(), watchlistPage(), profilePage()];
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
          Icon(Icons.movie_filter, color: Color(0xFFE50914)),
          SizedBox(width: 9),
          Text('MovieExplorer', style: TextStyle(fontWeight: FontWeight.w800)),
        ]),
        actions: [
          IconButton(
            tooltip: widget.isDark ? 'Light theme' : 'Dark theme',
            onPressed: widget.onTheme,
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(children: [
        if (wide)
          NavigationRail(
            selectedIndex: tab,
            onDestinationSelected: (v) => setState(() => tab = v),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: Text('Explore')),
              NavigationRailDestination(icon: Icon(Icons.bookmark_border), selectedIcon: Icon(Icons.bookmark), label: Text('Watchlist')),
              NavigationRailDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('Profile')),
            ],
          ),
        Expanded(child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: KeyedSubtree(key: ValueKey(tab), child: pages[tab]),
        )),
      ]),
      bottomNavigationBar: wide ? null : NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.bookmark_border), label: 'Watchlist'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget explorePage() => LayoutBuilder(builder: (context, box) {
        final pad = box.maxWidth < 600 ? 16.0 : 28.0;
        final items = filtered;
        return ListView(
          padding: EdgeInsets.fromLTRB(pad, 18, pad, 28),
          children: [
            featuredBanner(),
            const SizedBox(height: 24),
            Text('Discover movies', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Find your next favourite story.', style: TextStyle(color: Theme.of(context).hintColor)),
            const SizedBox(height: 16),
            TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: InputDecoration(
                hintText: 'Search title, genre or language',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isEmpty ? null : IconButton(onPressed: () => setState(() => query = ''), icon: const Icon(Icons.close)),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(height: 42, child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => ChoiceChip(
                label: Text(genres[i]),
                selected: genre == genres[i],
                onSelected: (_) => setState(() => genre = genres[i]),
              ),
            )),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: Text('${items.length} movies found', style: const TextStyle(fontWeight: FontWeight.bold))),
              DropdownButton<String>(
                value: sort,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'Recommended', child: Text('Recommended')),
                  DropdownMenuItem(value: 'Top Rated', child: Text('Top Rated')),
                  DropdownMenuItem(value: 'Newest', child: Text('Newest')),
                  DropdownMenuItem(value: 'A–Z', child: Text('A–Z')),
                ],
                onChanged: (v) => setState(() => sort = v ?? 'Recommended'),
              ),
            ]),
            const SizedBox(height: 10),
            if (items.isEmpty)
              const EmptyState(icon: Icons.movie_outlined, title: 'No movies found', message: 'Try another search or genre.')
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: box.maxWidth >= 1050 ? 4 : box.maxWidth >= 650 ? 3 : 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: box.maxWidth < 400 ? .62 : .70,
                ),
                itemBuilder: (_, i) => MovieCard(
                  movie: items[i],
                  saved: watchlist.contains(items[i].id),
                  onTap: () => openMovie(items[i]),
                  onSave: () => toggleSave(items[i]),
                ),
              ),
          ],
        );
      });

  Widget featuredBanner() {
    final m = movieData.first;
    return Container(
      height: 205,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(colors: m.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Stack(children: [
        Positioned(right: -8, bottom: -24, child: Icon(m.icon, size: 190, color: Colors.white.withValues(alpha: .14))),
        Padding(
          padding: const EdgeInsets.all(22),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .18), borderRadius: BorderRadius.circular(20)),
              child: const Text("EDITOR'S PICK", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ),
            const SizedBox(height: 12),
            const Text('Stories worth\\nstaying in for.', style: TextStyle(color: Colors.white, fontSize: 27, height: 1.05, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            FilledButton.tonal(onPressed: () => openMovie(m), child: const Text('Explore featured movie')),
          ]),
        ),
      ]),
    );
  }

  Widget watchlistPage() {
    final saved = movieData.where((m) => watchlist.contains(m.id)).toList();
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('My Watchlist', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 5),
        Text('Movies you want to watch later.', style: TextStyle(color: Theme.of(context).hintColor)),
        const SizedBox(height: 18),
        Expanded(child: saved.isEmpty
            ? const EmptyState(icon: Icons.bookmark_border, title: 'Your watchlist is empty', message: 'Save a movie from Explore to see it here.')
            : GridView.builder(
                itemCount: saved.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 230, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: .70),
                itemBuilder: (_, i) => MovieCard(movie: saved[i], saved: true, onTap: () => openMovie(saved[i]), onSave: () => toggleSave(saved[i])),
              )),
      ]),
    );
  }

  Widget profilePage() => ListView(padding: const EdgeInsets.all(24), children: [
        Text('Profile & Settings', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 22),
        Card(child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 32)),
            const SizedBox(width: 15),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Movie Explorer User', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(height: 4), Text('Discover • Save • Explore'),
            ])),
            Chip(label: Text('${watchlist.length} saved')),
          ]),
        )),
        Card(child: SwitchListTile(
          secondary: const Icon(Icons.dark_mode_outlined),
          title: const Text('Dark theme'),
          subtitle: const Text('Change application appearance'),
          value: widget.isDark,
          onChanged: (_) => widget.onTheme(),
        )),
        const Card(child: ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('About MovieExplorer'),
          subtitle: Text('A Flutter movie discovery app built with Dart and Material Design.'),
        )),
        Card(child: ListTile(leading: const Icon(Icons.movie_outlined), title: const Text('Movies in catalogue'), trailing: Text('${movieData.length}'))),
      ]);
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool saved;
  final VoidCallback onTap, onSave;
  const MovieCard({super.key, required this.movie, required this.saved, required this.onTap, required this.onSave});

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Hero(tag: 'movie-${movie.id}', child: MovieArtwork(movie: movie))),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 7, 8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(width: 30, height: 30),
                    onPressed: onSave,
                    icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border, color: saved ? const Color(0xFFE50914) : null, size: 20),
                  ),
                ]),
                Text('${movie.year} • ${movie.genre}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Theme.of(context).hintColor, fontSize: 11)),
                const SizedBox(height: 5),
                Row(children: [
                  const Icon(Icons.star, color: Colors.amber, size: 15),
                  const SizedBox(width: 3),
                  Text(movie.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const Spacer(),
                  Text('${movie.minutes} min', style: TextStyle(color: Theme.of(context).hintColor, fontSize: 10)),
                ]),
              ]),
            ),
          ]),
        ),
      );
}

class MovieArtwork extends StatelessWidget {
  final Movie movie;
  const MovieArtwork({super.key, required this.movie});
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: LinearGradient(colors: movie.colors, begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Stack(children: [
          Positioned(top: 12, left: 12, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.black.withValues(alpha: .35), borderRadius: BorderRadius.circular(20)),
            child: Text(movie.age, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
          )),
          Center(child: Icon(movie.icon, size: 76, color: Colors.white.withValues(alpha: .88))),
          Positioned(bottom: 10, left: 10, right: 10, child: Text(
            movie.title.toUpperCase(), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 13, letterSpacing: 1.1, fontWeight: FontWeight.w900, shadows: [Shadow(blurRadius: 8, color: Colors.black54)]),
          )),
        ]),
      );
}

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;
  final bool saved;
  final VoidCallback onSave;
  const MovieDetailsPage({super.key, required this.movie, required this.saved, required this.onSave});
  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late bool saved;
  @override
  void initState() { super.initState(); saved = widget.saved; }
  void toggle() { widget.onSave(); setState(() => saved = !saved); }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Movie details'),
          actions: [IconButton(onPressed: toggle, tooltip: 'Toggle watchlist', icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border))],
        ),
        body: LayoutBuilder(builder: (context, box) {
          final wide = box.maxWidth > 700;
          final poster = SizedBox(
            width: wide ? 280 : double.infinity,
            height: wide ? 390 : 300,
            child: He
