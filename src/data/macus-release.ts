// Single source of truth for Macus distribution on the site.
//
// Release day: set the channel(s) that shipped to `available: true`, fill in the
// version, artifact URL and checksum, and rebuild. Buttons, badges, install
// steps and the hero status all derive from this file.

export interface MacusDownload {
  /** A signed and notarized artifact attached to a GitHub Release on upmaru/macus. */
  available: boolean;
  url: string | null;
  fileName: string | null;
  sha256: string | null;
  sizeLabel: string | null;
  /** Steps shown after the download button, e.g. "Open the disk image…". */
  steps: string[];
}

export interface MacusHomebrew {
  /** True once upmaru/homebrew-tap publishes a verified Formula/macus.rb with bottles. */
  available: boolean;
  command: string;
}

export interface MacusRelease {
  version: string | null;
  releasedOn: string | null;
  notesUrl: string | null;
  download: MacusDownload;
  homebrew: MacusHomebrew;
}

export const macusRelease: MacusRelease = {
  version: null,
  releasedOn: null,
  notesUrl: null,
  download: {
    available: false,
    url: null,
    fileName: null,
    sha256: null,
    sizeLabel: null,
    steps: [
      'Open the downloaded installer and follow the prompts.',
      'Open Terminal and run macus start.',
    ],
  },
  homebrew: {
    available: false,
    command: 'brew install upmaru/tap/macus',
  },
};

export const macusRepo = 'https://github.com/upmaru/macus';
export const macusReleasesUrl = `${macusRepo}/releases`;

/** "available" once any prebuilt channel has shipped; "preview" until then. */
export const macusStatus: 'available' | 'preview' =
  macusRelease.download.available || macusRelease.homebrew.available ? 'available' : 'preview';

export const macusRequirements = [
  { label: 'Apple Silicon Mac', detail: 'Virtualization.framework on ARM64. Intel Macs are not supported.' },
  { label: 'macOS 15 or later', detail: 'Unsupported hosts fail before anything is downloaded or changed.' },
  { label: '4 GiB memory for the guest', detail: 'Reserved while the Linux appliance is running.' },
  { label: 'Disk space for the appliance', detail: 'A 12 GiB writable root plus a 32 GiB sparse data disk that only uses space as workloads fill it.' },
  { label: 'Internet on first start', detail: 'To fetch the pinned appliance image and workload images.' },
  { label: 'Homebrew, if incus is missing', detail: 'macus start installs the official incus formula when no incus client is on your PATH. It never installs Homebrew or uses sudo.' },
] as const;
