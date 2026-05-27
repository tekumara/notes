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
4. Add this Google Drive scope under data access:

   ```text
   https://www.googleapis.com/auth/drive
   ```

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

Create `gdrive.toml`:

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

Create `rustic.op.env` next to `gdrive.toml`:

```dotenv
RUSTIC_PASSWORD="op://Personal/rustic-password/password"
OPENDAL_CLIENT_ID="op://Personal/gcp-rustic/username"
OPENDAL_CLIENT_SECRET="op://Personal/gcp-rustic/credential"
OPENDAL_REFRESH_TOKEN="op://Personal/gcp-rustic/password"
```

This file contains 1Password references rather than secret values. Restrict access to it and the rustic profile:

```sh
chmod 600 rustic.op.env gdrive.toml
```

`op run` resolves the references and supplies the values only to its child process. Do not pass the secret values as command-line arguments.

## Initialize the repository

Run this command once:

```sh
op run --env-file="./rustic.op.env" -- \
  rustic -P ./gdrive.toml init
```

Rustic creates its repository files below `My Drive/rustic-backups/`.

## Check the repository

List its snapshots:

```sh
op run --env-file="./rustic.op.env" -- \
  rustic -P ./gdrive.toml snapshots
```

An initialized repository with no backups returns an empty snapshot list.

## Run a backup

Pass the source path to rustic:

```sh
op run --env-file="./rustic.op.env" -- \
  rustic -P ./gdrive.toml backup /path/to/data
```

You can also define backup sources and retention rules in `gdrive.toml`. See the [rustic configuration specification](https://github.com/rustic-rs/rustic/tree/main/config#repository-options-repository).

## Run unattended backups

Interactive use can rely on the 1Password desktop application's CLI integration. Scheduled jobs need a non-interactive authentication method, such as a narrowly scoped [1Password service account](https://developer.1password.com/docs/service-accounts/).

Give the service account access only to the vault or items required for the backup. Protect its service account token using the operating system's secret-management facilities.

## References

- [rustic configuration specification](https://github.com/rustic-rs/rustic/tree/main/config#repository-options-repository)
- [rustic Google Drive example](https://github.com/rustic-rs/rustic/blob/main/config/services/gdrive.toml)
- [OpenDAL Google Drive service](https://opendal.apache.org/docs/rust/opendal/services/struct.Gdrive.html)
- [Google OAuth 2.0 documentation](https://developers.google.com/identity/protocols/oauth2)
- [1Password CLI environment variables](https://developer.1password.com/docs/cli/secrets-environment-variables/)
