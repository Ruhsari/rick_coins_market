class BtnCartoonModel {
  String url;
  String image;
  BtnCartoonModel({required this.url, required this.image});

  static List<BtnCartoonModel> getListCartoonModels() {
    List<BtnCartoonModel> mainListCartoon = [];

    mainListCartoon = [
      BtnCartoonModel(
        url: 'https://www.youtube.com/@NickelodeonCyrillic',
        image: 'assets/images/nickelodeon_logo.png',
      ),
      BtnCartoonModel(
        url: 'https://www.boomerangtv.co.uk/videos',
        image: 'assets/images/boomerang_logo.jpg',
      ),
      BtnCartoonModel(
        url: 'https://www.cartoonnetwork.co.uk/videos',
        image: 'assets/images/cartoon_network_logo.png',
      ),
      BtnCartoonModel(
        url: 'https://www.youtube.com/watch?v=JgTbF05edtM',
        image: 'assets/images/wild_brain_logo.png',
      ),
      BtnCartoonModel(
        url: 'https://www.adultswim.com/videos/rick-and-morty',
        image: 'assets/images/adult_swim_logo.jpg',
      ),
      BtnCartoonModel(
        url: 'https://www.youtube.com/@disneyanimation',
        image: 'assets/images/disney_logo.png',
      ),
      BtnCartoonModel(
        url: 'https://www.youtube.com/@netflixfamily',
        image: 'assets/images/netflix_anim_logo.jpg',
      ),
      BtnCartoonModel(
        url: 'https://rickandmorty.com/',
        image: 'assets/images/rick_and_morty_logo.jpg',
      ),
    ];

    return mainListCartoon;
  }
}