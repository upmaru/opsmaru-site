export const targets = [
  {
    id: 'local', label: 'Local', name: 'Your machine', icon: 'terminal', short: 'local / incus',
    description: 'Start with an Incus server you control. The native client connects over a local Unix socket or verified HTTPS.',
  },
  {
    id: 'digitalocean', label: 'DigitalOcean', name: 'DigitalOcean', icon: 'globe', short: 'cloud / digitalocean',
    description: 'The vision: provision a cloud VM, configure Incus, and register the host with Opsmaru. DigitalOcean provisioning is planned.',
  },
  {
    id: 'aws', label: 'AWS', name: 'Amazon Web Services', icon: 'globe', short: 'cloud / aws',
    description: 'The vision: bring AWS compute into the same pool through Incus. Provider provisioning and workload placement are planned.',
  },
  {
    id: 'gcp', label: 'GCP', name: 'Google Cloud', icon: 'globe', short: 'cloud / gcp',
    description: 'The vision: register Incus-backed Google Cloud hosts without changing the agent-facing compute contract. Provider provisioning is planned.',
  },
] as const;
