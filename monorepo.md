# Monorepos


## Why a monorepo?

* Continuous integration - test consumers and libraries together [ref](https://medium.com/@Jakeherringbone/you-too-can-love-the-monorepo-d95d1d6fcebe)
* Everyone will be on the latest and "breaking changes are caught synchronously and so impossible" [ref](http://www.draconianoverlord.com/2018/07/15/mono-repos.html)
* Makes integration of shared internal code much easier - common code can be shared without dependency management and private repos (eg: nexus). If you are only used only third party dependencies from maven central then you probably don't need a monorepo
* Build everything from source - rather than managing two dependency graphs (source repos + binary artifacts) you only need to manage one. [ref](https://gist.github.com/mariusae/7c4c7a57dc34e53ad4bf2cfcd94bf9f0#file-monorepo-txt-L40)
* Forces teams to communicate with one another. [ref](https://medium.com/@adamhjk/monorepo-please-do-3657e08a4b70)
* Easier to refactor code across projects
* Makes it easier to write integration tests across multiple applications. With a Monorepo you can build multiple applications in parallel and then integration test them all before deploying.

Monorepos work well at certain sizes - too big and you run into tooling problems. Consider at what size your VCS grinds to a halt, or your IDE indexes become slow (if your IDE can unload modules that might help). The arguments for a monorepo within a team are different from the arguments for  a monorepo for your whole company.

In a monorepos that always builds HEAD, multiple versions are supported by duplicating the source of a module and having two copies. For a monorepo that supports branches, different versions can live on different branches.


## Quotes


"The other one that was kinda nice was, because of the mono-repo, it was kinda amazing to make a 3 line change in some core java library and then see CI run a suite of 1M unit tests across all projects in the mono repo dependent on that lib." https://twitter.com/patricktoomey/status/1223406186898153473?s=20


"The model quickly broke down, however, when, through util and finagle, we introduced a substantial amount of shared software infrastructure. In order for some downstream projects (e.g. the original version of Woodstar) to consume changes to, say, util, all intermediate projects needed to be updated—integrated, compiled, re-published—in order to avoid introducing dependency diamond conflicts. The upshot is that some teams spent roughly half of their time simply integrating changes. One way to view this is: binary dependencies introduce an additional, extrinsic, dependency graph which must be independently synchronized with the source dependency graph. The situation is greatly improved—simplified, easier to reason about, avoiding external synchronization—when software is compiled entirely and transitively from source code." [ref](https://gist.github.com/mariusae/7c4c7a57dc34e53ad4bf2cfcd94bf9f0#file-monorepo-txt-L40)

"My advice is that if components need to release together, then they ought to be in the same repo. I'd probably go further and say that if you just think components might need to release together then they should go in the same repo, because you can in fact pretty easily manage projects with different release schedules from the same repo if you really need to.
On the other hand if you've got a whole bunch of components in different repos which need to release together it suddenly becomes a real pain.

If you've got components that will never need to release together, then of course you can stick them in different repositories. But if you do this and you want to share common code between the repositories then you will need to manage that code with some sort of robust versioning system, and robust versioning systems are hard. Only do something like that when the value is high enough to justify the overhead. If you're in a startup, chances are very good that the value is not high enough.

As a final observation, you can split big repositories into smaller ones quite easily (in Git anyway) but sticking small repositories together into a bigger one is a lot harder. So start out with a monorepo and only split smaller repositories out when it's clear that it really makes sense." [ref](https://news.ycombinator.com/item?id=18811368)

"Oddly enough, I think that monorepos may be best suited for either "small" orgs (where there isn't that much code, relatively speaking; tooling can keep up) or really big ones (where infrastructure investments can be made). Medium sized orgs suffer the most: they have neither." [ref](https://twitter.com/marius/status/1080594560965763073)

"We've had a monorepo from ~day 1 at GRAIL, and it's been great (I'd say we're in the category of "small" org: git can keep up easily). We've been using Bazel, and _have_ been able to make many large-scale refactoring (and continue to do so)."

"But, I think, more importantly: it's simple (again, small org, no scaling issues); and there is zero tax for putting code in the right places (e.g., co-developing a file-access library with a user of it). It's been great." [ref](https://twitter.com/marius/status/1080594562991542272)

"I prefer monorepos for those organization sizes you mention, but I've noticed that it makes consuming and publishing open source more difficult. I think that should be seriously factored into one's decision about whether or not to use a monorepo."


"...at least the monorepo+tests give you a way to actually detect all the stuff you're about to break. When you remove the monorepo, you remove the problems of lockstep, but this creates other problems (like security holes not getting patched everywhere)." [ref](https://twitter.com/apenwarr/status/1230512918166462464?s=20)

"Further, mono-repos may simply be part of a different “contract” with users. Instead of supporting older versions (imposing a cost only on the library developer), you instead split the costs a little bit. Library developers have to write patches to downstream projects on any breaking change, and downstream projects have to review these patches in a timely manner. This isn’t a contract that works with external users, but with internal users where you can expect these responsibilities to be honored, it has its benefits." [ref](https://www.tedinski.com/2018/02/06/system-boundaries.html)