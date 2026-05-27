# Back up to Google Drive with rustic and 1Password

This guide configures rustic to store an encrypted backup repository in Google Drive. OpenDAL connects rustic to Google Drive. The 1Password CLI supplies the Google OAuth credentials and rustic repository password at runtime.

The setup uses 2 separate forms of authentication:

- Google OAuth credentials give OpenDAL access to Google Drive
- the rustic repository password encrypts the backup repository

Keep the rustic repository password. You need it to restore your backups.

## Prerequisites

Install:

- [rustic](https://rustic.cli.rs/)
- [1Password CLI](https://developer.1password.com/docs/cli/get-started/)

Sign in to the 1Password CLI before continuing:

```sh
op signin
```

## Create the Google Drive credentials

### Create a Google Cloud project

1. Open the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a project or select an existing project for rustic.
3. Open the [Google API Library](https://console.cloud.google.com/apis/library).
4. Find and enable the Google Drive API.

### Configure the OAuth application

1. Open [Google Auth Platform](https://console.cloud.google.com/auth/overview).
2. Configure the application branding and audience.
3. Use an External audience for a personal Google account. Add your account as a test user while setting up the application.

Google limits refresh tokens to 7 days when an External application remains in Testing and requests the Drive scope. Moving the application to Production removes that fixed testing limit. However this requires going through the verification process.

Google Workspace users can use an Internal audience when the Cloud project belongs to their organisation. Internal applications do not have the External testing restriction.

### Create a web OAuth client

1. Open Google Auth Platform and select Clients.
2. Select Create client.
3. Choose `Web application` as the application type.
4. Name the client, for example `rustic`.
5. Add this exact authorized redirect URI:

   ```text
   https://developers.google.com/oauthplayground
   ```

6. Leave Authorized JavaScript origins empty.
7. Create the client and copy its client ID and client secret.

NB: A Desktop app client does not show the Authorized redirect URIs setting. You must use a `Web application` client.

### Create a refresh token

Open the [Google OAuth 2.0 Playground](https://developers.google.com/oauthplayground/).

1. Open the settings using the cog icon.
2. Enable `Use your own OAuth credentials`.
3. Enter the web client ID and client secret.
4. Set the access type to `Offline` if the option is shown.
5. Set the prompt to `Consent` if the option is shown.
6. Enter this scope:

   ```text
   https://www.googleapis.com/auth/drive
   ```

7. Select Authorize APIs and approve access with the Google account that owns the target Drive.
8. Select Exchange authorization code for tokens.
9. Copy the refresh token from the response.

Use the refresh token, not the short-lived access token. OpenDAL uses the refresh token to request new access tokens.

If the response does not contain a refresh token, remove the application's existing access from [Google Account connections](https://myaccount.google.com/connections). Repeat the authorization with offline access and consent enabled.

If Google reports `redirect_uri_mismatch`, check that:

- the OAuth client is a Web application
- the client has `https://developers.google.com/oauthplayground` as an authorized redirect URI
- OAuth Playground uses the ID and secret from that client

Google can take several minutes to apply a new redirect URI.

## Store the credentials in 1Password

Create these items in the Personal vault.

### rustic-password

Store the rustic repository encryption password in:

```text
op://Personal/rustic-password/password
```

Use a generated password. Losing this password prevents recovery of the repository.

### gcp-rustic

Store the Google credentials in these fields:

| 1Password field | Value | Secret reference |
| --- | --- | --- |
| `username` | OAuth client ID | `op://Personal/gcp-rustic/username` |
| `credential` | OAuth client secret | `op://Personal/gcp-rustic/credential` |
| `password` | OAuth refresh token | `op://Personal/gcp-rustic/password` |

## Configure rustic

Save `gdrive.toml` in rustic's user configuration directory. The default locations are:

- macOS: `~/Library/Application Support/rustic/gdrive.toml`
- Linux: `~/.config/rustic/gdrive.toml`

Create the directory on macOS if it does not exist:

```sh
mkdir -p "$HOME/Library/Application Support/rustic"
```

Add this configuration to `gdrive.toml`:

```toml
[repository]
repository = "opendal:gdrive"

[repository.options]
root = "/rustic-backups"
```

The `root` option is the folder that holds the repository in Google Drive. This example uses:

```text
My Drive/rustic-backups/
```

## Map 1Password fields to environment variables

Store `rustic.op.env` next to `gdrive.toml` in rustic's user configuration directory. Keeping both files together makes the backup configuration easier to find and protect.

```dotenv
RUSTIC_USE_PROFILE="gdrive.toml"
RUSTIC_PASSWORD="op://Personal/rustic-password/password"
OPENDAL_CLIENT_ID="op://Personal/gcp-rustic/username"
OPENDAL_CLIENT_SECRET="op://Personal/gcp-rustic/credential"
OPENDAL_REFRESH_TOKEN="op://Personal/gcp-rustic/password"
```

`RUSTIC_USE_PROFILE` tells rustic to load `gdrive.toml` from its standard configuration search path. You do not need to pass `-P` on each command.

This file contains 1Password references rather than secret values. Restrict access to both files on macOS:

```sh
chmod 600 \
  "$HOME/Library/Application Support/rustic/rustic.op.env" \
  "$HOME/Library/Application Support/rustic/gdrive.toml"
```

`op run` resolves the references and supplies the values only to its child process. Do not pass the secret values as command-line arguments.

## Open one 1Password-enabled shell

Open an interactive shell with the resolved environment variables:

```sh
op run --env-file="$HOME/Library/Application Support/rustic/rustic.op.env" -- zsh -i
```

or on Linux:

```sh
op run --env-file="$HOME/.config/rustic/rustic.op.env" -- zsh -i
```

Run all rustic commands from this shell. This resolves the 1Password references once and avoids repeating `op run` for each command.

Exit the shell when you finish:

```sh
exit
```

The resolved secrets remain available to the shell and its child processes until you exit. Avoid running `env`, `printenv` or shell tracing with `set -x` in this shell.

## Initialize the repository

Run this command once from the 1Password-enabled shell:

```sh
rustic init
```

Rustic creates its repository files below `My Drive/rustic-backups/`.

## Check the repository

List its snapshots:

```sh
rustic snapshots
```

An initialized repository with no backups returns an empty snapshot list.

## Run a backup

Pass the source path to rustic:

```sh
rustic backup /path/to/data
```

You can also define backup sources and retention rules in `gdrive.toml`. See the [rustic configuration specification](https://github.com/rustic-rs/rustic/tree/main/config#repository-options-repository).

## Restore selected files or directories

List the snapshots, then inspect the contents of the snapshot you want to restore:

```sh
rustic snapshots
rustic ls latest
```

Use `SNAPSHOT:/path` to restore one file or directory. The first path is the path stored in the snapshot. The second path is the local destination.

Restore a directory from the latest snapshot:

```sh
rustic restore latest:/home/tekumara/Documents/ "$HOME/Restored/Documents/"
```

Restore one file:

```sh
rustic restore latest:/home/tekumara/Documents/report.pdf ./report.pdf
```

Replace `latest` with a snapshot ID to restore from a specific snapshot:

```sh
rustic restore 01a2b3c4:/home/tekumara/Documents/ ./restored-documents/
```

If the repository contains snapshots from several hosts or backup definitions, filter which snapshot `latest` selects:

```sh
rustic restore latest:/home/tekumara/Documents/ ./restored/ \
  --filter-host my-mac \
  --filter-label home
```

Use `--glob` when the files share a pattern rather than a directory:

```sh
rustic --dry-run restore latest ./restored/ \
  --glob 'home/tekumara/Documents/**/*.pdf'
```

Remove `--dry-run` after checking the proposed restore. Prefer `latest:/path` when restoring one file or directory because it avoids scanning unrelated parts of the snapshot.

Rustic leaves unrelated files in the destination by default. The `--delete` option removes destination files that do not exist in the snapshot. Preview any restore that uses it:

```sh
rustic --dry-run restore \
  latest:/home/tekumara/Documents/ \
  "$HOME/Documents/" \
  --delete
```

## Remove old snapshots with forget and prune

The `forget` command removes snapshot records according to retention rules. The `prune` command then deletes repository data that no remaining snapshot uses.

Forgetting a snapshot does not immediately reclaim all of its storage. Rustic deduplicates data, so other snapshots may still refer to the same files and data chunks. Pruning finds data with no remaining references and removes it from Google Drive.

Add a retention policy to `gdrive.toml`:

```toml
[forget]
group-by = "host,label,paths"
keep-last = 3
keep-daily = 7
keep-weekly = 4
keep-monthly = 12
keep-yearly = 5
prune = true
```

Rustic applies these rules separately to each combination of host, label and backup paths. It keeps a snapshot if any rule selects it. The example keeps:

- the latest 3 snapshots
- one snapshot for each of the latest 7 days
- one snapshot for each of the latest 4 weeks
- one snapshot for each of the latest 12 months
- one snapshot for each of the latest 5 years

One snapshot can satisfy several rules. The rules do not keep 31 separate snapshots in every group.

Preview the result before deleting anything:

```sh
rustic --dry-run forget
```

Check the `Action` and `Reason` columns in the output. Pay particular attention to the snapshot groups. An unexpected host, label or path can put snapshots in a different group.

Run the configured policy after checking the preview:

```sh
rustic forget
```

With `prune = true`, this command forgets the selected snapshots and then reclaims unreferenced data. To separate the operations, leave `prune` unset or set it to `false`:

```sh
rustic forget
rustic prune
```

You can also remove a specific snapshot by its ID:

```sh
rustic forget SNAPSHOT_ID
```

This explicit form removes the named snapshot instead of applying the configured retention rules. Preview it first with `rustic --dry-run forget SNAPSHOT_ID`.

Rustic requires at least one `keep-*` rule when it applies retention. Setting `keep-none = true` explicitly permits removal of every selected snapshot and should only be used when that is the intended result.

## Run unattended backups

Interactive use can rely on the 1Password desktop application's CLI integration. Scheduled jobs need a non-interactive authentication method, such as a narrowly scoped [1Password service account](https://developer.1password.com/docs/service-accounts/).

Give the service account access only to the vault or items required for the backup. Protect its service account token using the operating system's secret-management facilities.

## References

- [rustic configuration specification](https://github.com/rustic-rs/rustic/tree/main/config#repository-options-repository)
- [rustic Google Drive example](https://github.com/rustic-rs/rustic/blob/main/config/services/gdrive.toml)
- [OpenDAL Google Drive service](https://opendal.apache.org/docs/rust/opendal/services/struct.Gdrive.html)
- [Google OAuth 2.0 documentation](https://developers.google.com/identity/protocols/oauth2)
- [1Password CLI environment variables](https://developer.1password.com/docs/cli/secrets-environment-variables/)
