export const targets = [
  {
    id: 'linux', label: 'Linux', name: 'Linux with Incus', icon: 'terminal', short: 'local / incus',
    description: 'Start with an Incus server you control. The native client connects over a local Unix socket or verified HTTPS.',
  },
  {
    id: 'mac', label: 'Mac', name: 'Mac with Macus', icon: 'laptop', short: 'local / macus',
    description: 'Macus boots a Linux Incus host on Apple Silicon with Virtualization.framework, then serves native Incus and agent tools over local HTTPS.',
  },
  {
    id: 'digitalocean', label: 'DigitalOcean', name: 'DigitalOcean', icon: 'globe', short: 'cloud / digitalocean',
    description: 'Planned: Opsmaru creates the VM, installs Incus with cloud-init and registers the host with a pinned certificate.',
  },
  {
    id: 'aws', label: 'AWS', name: 'Amazon Web Services', icon: 'globe', short: 'cloud / aws',
    description: 'Planned: a native adapter calls the AWS API directly. No Terraform runtime, and every created resource is labelled with its host.',
  },
  {
    id: 'gcp', label: 'GCP', name: 'Google Cloud', icon: 'globe', short: 'cloud / gcp',
    description: 'Planned: the same reconciled lifecycle, from requested to ready, with Incus as the only interface agents ever touch.',
  },
] as const;
