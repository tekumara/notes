# Python Resources for Application Development

A small curated list of Python application development resources for practising programmers who want to come up to speed with modern Python practices and core idioms.  

## Overviews
[Hypermodern Python (2020)](https://cjolowicz.github.io/posts/hypermodern-python-01-setup/) is an end-to-end overview of a modern approach and covers:
* Pyenv, poetry
* Testing with nox
* Linting
* Type annotations and type checking
* Dataclasses and data validation with Desert and Marshmallow
* Documentation with docstrings and Sphinx
* Packaging and publishing

[Fluent Python: Clear, Concise, and Effective Programming (2015)](https://www.amazon.com/Fluent-Python-Concise-Effective-Programming-dp-1491946008/dp/1491946008/ref=mt_paperback?_encoding=UTF8&me=&qid=1589359612) - covers the core and unique parts of Python for practising programmers

## Code bases
Code bases that exhibit modern Python practice:

* [Prefect](https://github.com/PrefectHQ/prefect) - a multiple project repo using the [src/ layout](https://github.com/tekumara/notes/blob/master/python-project-layout.md)

## Dependencies and packaging
[Python Application Dependency Management in 2018](https://hynek.me/articles/python-app-deps-2018/) reviews pipenv, poetry, and pip-tools and finally recommends pip-tools.

[Cindy Sridharan, The Python Deployment Albatross, PyBay2016](https://www.youtube.com/watch?v=nwsCUfodq7I) a brief history of Python packaging - setuptools, eggs, pip, virtualenvs, wheels, pants, pex, docker 

## Best practices
[Effective Python: 90 Specific Ways to Write Better Python (2019)](https://www.amazon.com/Effective-Python-Specific-Software-Development-ebook-dp-B07ZG18BH3/dp/B07ZG18BH3/ref=mt_kindle?_encoding=UTF8&me=&qid=) - Pythonic best practices contextualised and organised. More accessible than a PEP!

## Web applications
[Armin Ronacher, "Flask for Fun and Profit", PyBay2016](https://github.com/wgwz/flask-for-fun-and-profit) - the author of Flask talks about Flask app structure, WSGI, Web sockets vs SSE vs HTTP2, validation & serialisation, and mistakes he made in Flask

[We have to talk about this Python, Gunicorn, Gevent thing (2020)](https://news.ycombinator.com/item?id=22514004) - challenges with gunicorn and its forking model. 

[Graham Dumpleton - Secrets of a WSGI master. - PyCon 2018](https://www.youtube.com/watch?v=CPz0s1CQsTE) - the author of mod_wsgi gives best practices for running mod_wsgi in production

## DDD
[Architecture Patterns with Python (2020)](https://www.cosmicpython.com/) (aka cosmic python) - Domain modelling, and event-driven architectures in Python.
