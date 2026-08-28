# moc-dns

DNS zone file management for [massopen.cloud](https://massopen.cloud) and related domains, hosted on AWS Route 53. Changes to zone files are automatically validated and applied via GitHub Actions.

## Managed Zones

| Zone file | Domain |
|-----------|--------|
| `zonefiles/massopen.cloud.zone` | `massopen.cloud` |
| `zonefiles/int.massopen.cloud.zone` | `int.massopen.cloud` |
| `zonefiles/ocp.massopen.cloud.zone` | `ocp.massopen.cloud` |

## Making Changes

1. Edit the relevant zone file under `zonefiles/`.
2. Open a pull request. The pre-commit CI will validate the zone file using `named-checkzone` and reformat it if necessary.
3. Once merged to `main`, the **Update DNS records** workflow automatically pushes the changed zones to Route 53 using [cli53](https://github.com/barnybug/cli53).

> **Note:** Only zone files that are added or modified in a commit are pushed to Route 53. Unchanged zones are left untouched.

## Local Development

Install pre-commit and bind utilities, then run the hooks manually:

```bash
# Install dependencies (Debian/Ubuntu)
sudo apt-get install bind9-utils
pip install pre-commit

# Run hooks against all zone files
pre-commit run --all-files
```

The `format-zonefiles.sh` script normalises zone files by running them through `named-checkzone -D` and writing the canonical output back in place.

## CI/CD

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `pre-commit` | PRs, pushes (non-`main`) | Validates and formats zone files |
| `apply` | Push to `main` (zone files changed), manual dispatch | Applies changed zones to Route 53 |

AWS credentials are obtained via OIDC (`AWS_ROLE_ARN` secret) — no long-lived keys are stored in the repository.
