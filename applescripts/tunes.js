const symbol = '♫';
const maxLen = 40;
let output = '';
const musicDomains = ['music.youtube.com', 'youtube.com'];

const music = Application('Music');

function cleanYtMusicTitle(title) {
  if (!title) return '';
  return (
    title
      // strip trailing "YouTube Music" with common separators
      .replace(/\s*[-–•]\s*YouTube Music\s*$/i, '')
      .trim()
  );
}

function scanChromium(appName) {
  try {
    const app = Application(appName);
    if (!app.running()) return null;

    let best = null;
    app.windows().forEach((win) => {
      win.tabs().forEach((tab) => {
        const url = typeof tab.url === 'function' ? tab.url() : tab.url;
        if (!url || !musicDomains.some((domain) => url.includes(domain))) return;

        const rawTitle = typeof tab.title === 'function' ? tab.title() : tab.title;
        const cleaned = cleanYtMusicTitle(rawTitle);
        const looksLikeTrack = /[-–•]/.test(cleaned); // "Song - Artist" or "Song • Artist"

        // Prefer audible, then something that looks like a track
        let audible = false,
          muted = false;
        try {
          if (typeof tab.audible === 'function') audible = !!tab.audible();
        } catch (_) {}
        try {
          if (typeof tab.muted === 'function') muted = !!tab.muted();
        } catch (_) {}

        const score = (audible && !muted ? 2 : 0) + (looksLikeTrack ? 1 : 0);
        if (!best || score > best.score) best = { cleaned, score };
      });
    });

    return best ? best.cleaned : null;
  } catch (_) {
    return null;
  }
}

function scanSafari() {
  try {
    const safari = Application('Safari');
    if (!safari.running()) return null;

    let best = null;
    safari.windows().forEach((win) => {
      win.tabs().forEach((tab) => {
        const url = tab.url();
        if (!url || !musicDomains.some((domain) => url.includes(domain))) return;

        const cleaned = cleanYtMusicTitle(tab.name());
        const looksLikeTrack = /[-–•]/.test(cleaned);
        const score = looksLikeTrack ? 1 : 0;
        if (!best || score > best.score) best = { cleaned, score };
      });
    });

    return best ? best.cleaned : null;
  } catch (_) {
    return null;
  }
}

function scanMusic() {
  try {
    const app = Application('Music');
    if (!app.running()) return null;
    const t = app.currentTrack;
    return `${t.name()} - ${t.artist()}`;
  } catch (_) {
    return null;
  }
}

function scanSpotify() {
  try {
    const app = Application('Spotify');
    if (!app.running()) return null;
    const t = app.currentTrack;
    return `${t.name()} - ${t.artist()}`;
  } catch (_) {
    return null;
  }
}

function scanQuickTime() {
  try {
    const qt = Application('QuickTime Player');
    if (!qt.running()) return null;

    const docs = qt.documents();
    if (docs.length === 0) return null;

    const doc = docs[0];
    const isPlaying = doc.playing();
    if (!isPlaying) return null;

    // Prefer metadata title if available; otherwise use filename
    let title = '';
    try {
      title = doc.name().replace(/\.[^/.]+$/, '');
    } catch (_) {
      title = '';
    }

    return title ? `${title}` : null;
  } catch (_) {
    return null;
  }
}

function main() {
  const hits = [
    scanChromium('Google Chrome'),
    scanChromium('Brave Browser'),
    scanSafari(),
    scanMusic(),
    scanQuickTime(),
    scanSpotify(),
  ].filter(Boolean);

  if (hits.length === 0) return '';

  return `${symbol} ${hits[0]}`.substring(0, maxLen);
}

const browserMusic = main();

if (music.running()) {
  const track = music.currentTrack,
    artist = track.artist(),
    title = track.name();

  output = `${symbol} ${title} - ${artist}`.substr(0, 50);
} else if (browserMusic !== '') {
  output = browserMusic;
} else if (Application('Spotify').running()) {
  const track = Application('Spotify').currentTrack,
    artist = track.artist(),
    title = track.name();

  output = `${symbol} ${title} - ${artist}`.substr(0, 50);
} else if (Application('QuickTime Player').running()) {
  const qt = Application('QuickTime Player');
  try {
    const doc = qt.documents()[0];
    if (doc && doc.playing()) {
      const name = doc.name().replace(/\.[^/.]+$/, '');
      output = `${symbol} ${name}`.substr(0, 50);
    }
  } catch (_) {}
}

if (output === '♫ YouTube Music') {
  output = '';
}

output;
