const symbol = '♫';
let output = '';

if (Application('Music').running()) {
  const track = Application('Music').currentTrack,
    artist = track.artist(),
    title = track.name();

  output = `${symbol} ${title} - ${artist}`.substr(0, 50);
} else if (Application('Spotify').running()) {
  const track = Application('Spotify').currentTrack,
    artist = track.artist(),
    title = track.name();

  output = `${symbol} ${title} - ${artist}`.substr(0, 50);
}

output;
