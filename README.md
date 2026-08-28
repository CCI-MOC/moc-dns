# MOC Static DNS Records

This repository manages MOC DNS records in AWS Route 53 using standard DNS zonefiles.

## Repository structure

DNS zone file are stored in the [`zonefiles`](zonefiles) directory. The name of the zone file must match the zone it manages. That is, if you are managing records for `ocp.massopen.cloud`, you must create a zonefile `ocp.massopen.cloud.zone`.

> [!WARNING]
> The zone files are *authoritative*: when changes are applied, they will
> *replace* the content of the target zone. If there are any records that were
> created manually through the Route 53 console or dynamically through the
> Route 53 UI, and those records are not defined in this repository, they will
> be removed.

## Zone file format

The zone file format is described by [RFC 1035].

[rfc 1035]: https://www.rfc-editor.org/info/rfc1035/

## Making changes

To add, remove, or modify DNS records:

1. Edit the relevant zone file in the `zonefiles/` directory.
2. Push your changes and open a pull request. Our CI workflow will automatically validate the changes using the [pre-commit workflow].
3. Once your pull request has been approved and merged to main, the [apply workflow] will use [cli53] to automatically apply your changes to Route 53.

[cli53]: https://github.com/barnybug/cli53
[apply workflow]: .github/workflows/apply.yaml
[pre-commit workflow]: .github/workflows/pre-commit.yaml

### Running checks locally

We use `ldns-read-zone` from the `ldnsutils` package to lint and format the zone files. These checks are driven by the [pre-commit] tool. You will want to configure these checks to run locally before you submit a pull request. After installing `pre-commit`, run:

[pre-commit]: https://pre-commit.com/

```sh
pre-commit install
```

This will install a Git pre-commit hook that will run these checks whenever you commit changes to the repository.

> [!NOTE]
> You will need to install `ldnsutils` in order to run the pre-commit checks.
