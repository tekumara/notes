# gitpod

Private ports are accessible publicly [#1751](https://github.com/gitpod-io/gitpod/issues/1751)

## git

The GitHub OAuth integration sets your GitHub primary email address as the git config `user.email`, and your GitHub username as git config `user.name` . This can be overriden by setting the following environment variables for your account:

- GIT_AUTHOR_EMAIL
- GIT_COMMITTER_EMAIL
- GIT_AUTHOR_NAME

gitpod has it's [own credential-helper](https://github.com/gitpod-io/gitpod/blob/52660b5ad8a1456d0c28de3833216b8971af0c38/components/gitpod-cli/cmd/credential-helper.go) which fetches creds via OAuth, eg:

```
echo github.com | gp credential-helper get
```

## python

gitpod sets `PYTHONUSERBASE=/workspace/.pip-modules` which causes all pip user installed packages to end up in _/workspace/.pip-modules/lib/python3.8/site-packages/_

gitpod also sets `PIP_USER=yes` which changes every `pip` invocation to be `pip --user` which means packages are installed into the user package directory, and not virtualenvs. See [#479](https://github.com/gitpod-io/gitpod/issues/479#issuecomment-482585774) and [#1552](https://github.com/gitpod-io/gitpod/issues/1552)

## self-hosted

```
git clone https://github.com/gitpod-io/self-hosted
cd self-hosted
```

Create a [Github OAuth App](https://docs.github.com/en/developers/apps/creating-an-oauth-app):

1. [Register a new OAuth application](https://github.com/settings/applications/new) and specify the _Authorization callback URL_ as `https://<your-domain.com>/auth/github/callback`
1. Copy `Client ID` into clientID in _values.yaml_
1. Copy `Client Secret` into clientSecret in _values.yaml_

Update `hostname` with your domain name in _values.yaml_

## vs cdr/code-server

gitpod uses the open-vsx marketplace, whereas cdr/code-server has its [own marketplace](https://github.com/cdr/code-server/blob/master/doc/FAQ.md#differences-compared-to-vs-code).

Coder Enterprise allows memory, CPU and disk to be configured [per environment](https://enterprise.coder.com/docs/create-an-environment).

Coder Enterprise has [dev-urls](https://enterprise.coder.com/docs/dev-urls) to access ports in the environment. cdr/code-server has [proxy paths](https://github.com/cdr/code-server/blob/master/doc/FAQ.md#how-do-i-securely-access-web-services).

cdr/code-server config is compatible for VS code. Theia has a different format.

cdr/code-server doesn't automatically clone a repo, or have a yaml file for specifying what to run on startup. Gitpod builds docker images on demand.

If cdr/code-server is Jupyter, then gitpod is Binder.

cdr/code-server can be installed as a Chrome App (aka PWA). When used as an app, the keybindings match VS code.

cdr/code-server has a [heartbeat file](https://github.com/cdr/code-server/blob/master/doc/FAQ.md#heartbeat-file), but no idle timeout yet, see [#1636](https://github.com/cdr/code-server/issues/1636)

[Eclipse Che](https://www.eclipse.org/che/) provides Theia workspaces in Kubernetes

cdr/code-server can be installed and run directly on a host (ie: not inside a container), eg: in macOS: `brew install code-server`

## VS Code Codespaces

Can self host but requires an Azure billing account, and you have to access instances via the Codespaces web dashboard.
