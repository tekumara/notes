# acorn

Install in current context (requires cluster admin privileges):

```
acorn install
```

To see the resources acorn install's:

```
acorn install -o yaml
```

## aml vs cue vs jsonnet

> We're building a tool to simplify developing and deploying containerized apps. We need something like json++ or yaml -= all-the-awful-parts, not programming-language-adjacent. And CUE has a lot of those things we like, but also does all sorts of other stuff.
> If you want to be a k8s expert or directly manipulate raw k8s manifests, we're just not going to be the tool for you. And that's ok.
> The runtime is k8s because that's the big obvious one you can go pick up at a cloud provider, but app description is purposefully abstracted from that. A target user has some app described by Dockerfiles, and knows they should be running on k8s because that's what everybody does. But they don't want to deal with describing their deployment and service and ingress and volume requirements in hundreds of lines of manifest with labels here that have to match there. And getting certs from cert manager. And making a chart for it and deciding which parts of all the previous stuff the chart should be able to override. And hosting and versioning that chart somewhere, separate from the images. Or documenting all the pieces of it you need to pre-pull and cobble together if you want to run in an air-gapped environment on an oil rig. Yada yada yada. There is much pain real people in real businesses have here.
> When we were Rancher we sold Kubernetes, so we did not have very good answers to offer for these problems. An engine manufacturer can't really help people who just want a car to get to work. In this context, a super powerful description language is just a steeper learning curve to climb. Anybody like this who googles cue (then tries again with cuelang or cue documentation) and lands anywhere near cuelang.org or even just early examples full of # & | \*"default" etc is, frankly, scared the hell away.
> It's important to understand first our needs. We largely need a data format. Our users are expecting YAML and will think that YAML is sufficient. We know it's not sufficient because it lack conditions, control loops, functions and expressions. YAML + gotemplate is basically the defacto approach for a lot of k8s projects, which is a horrific solution. We don't need schema definitions, unification, disjunctions for the most part. jsonnet would have been a good match for what we need, but I like the style of CUE better and it "scales" better in IMHO.
