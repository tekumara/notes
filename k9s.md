# k9s

k9s will show CPU and MEM if the metrics-server has been installed

k9s logs will show logs for a given period (eg: 1m, 5m, 15m, 30m 1h, all). Sometimes it fails to show any logs. See [#1152](https://github.com/derailed/k9s/issues/1152)

## Namespaces

k9s stores the active (ie: last used) namespace and a list of previously used namespaces in the UI as favourites. Favourites are per _cluster_ and stored in `$HOME/Library/Application\ Support/k9s/config.yml`.

The cluster is determined by the context. When k9s opens it populates the list of namespace favourites, and switches to the active namespace for the **context's cluster**. When you change context (either with `kubectx` or `:context` inside k9s) and the context is for a different cluster, then the active namespace and list of namespace favourites in k9s changes.

NB: The active namespace in k9s is not the namespace of the context set in the kube config. This is particularly jarring when the context you select via `kubectx` is for a namespace you've never opened in k9s. k9s will instead open to a different namespace (whichever was last active for the cluster the context is for). See [Add configuration flag to use namespace set in kubeconfig #1588](https://github.com/derailed/k9s/issues/1588).
