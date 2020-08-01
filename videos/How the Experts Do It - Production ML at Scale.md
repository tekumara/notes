# How the Experts Do It: Production ML at Scale

https://www.linkedin.com/pulse/how-experts-do-production-ml-scale-joel-young/

Folks from ML infra teams at LinkedIn, Airbnb, Netflix, Facebook, Google

Who are our customers?
* Different roles/personas - ML/application/algorithm engineers vs data/research scientists

Containerisation
* package pytorch in container, or common platform version?

Cost-to-serve vs. agility
* how do you balance things like cost-to-run, cost-to-serve, cost-to-train, versus agility for your customers?

Sharing ML Artifacts
* policy (should this be used with this other model?)
* reusing libraries (what do we have in terms of python infra for doing so?)
* conscious promotion of features that are generalizable, and documented with the intent

Extensibility
* AirBnb can add any framework, a BigHead libraries which you can
actually build wrappers around common ML frameworks.
And you have to define your serialization and deserialization of it as well as they're fit transform.
But, essentially, you can add in any ML framework you want.

Our definitions of success

* Reliability - usual metrics
* How many features shared?
* How many features go from inception to production?
* Training - time from starting writing pipeline to successful completion
* Inference - how quickly did you get to inference
* Dev productivity - how long to get to online experiment
* Balance Agility/Innovation/Cost efficiency (vendor management)
* Netflix - researcher productivity no. 1 - how many a/b tests we can enable on the platform?
how long to first a/b test?
* Airbnb - number of users for breadth, number of models per user/teams, QPS (both online and offline)
* Things get harder with larger number of models etc.
* How much can the infra of today power infra of tomorrow?
