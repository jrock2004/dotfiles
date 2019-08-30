let output = '';
if (Application('iTunes').running()) {
  const track = Application('iTunes').currentTrack,
    artist = track.artist(),
    title = track.name();

  output = (`${title} - ${artist}`).substr(0, 50);
} else if (Application('Spotify').running()) {
  const track = Application('Spotify').currentTrack,
    artist = track.artist(),
    title = track.name();

  output = (`${title} - ${artist}`).substr(0, 50);
}

output;
