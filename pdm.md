# pdm

## Troubleshooting

### pip doesn't show any packages in the virtualenv

pdm can manage a virtualenv but by default it [doesn't install `pip` into the virtualenv](https://pdm.fming.dev/latest/usage/venv/#including-pip-in-your-virtual-environment). So running `pip` will show packages from the system environment only.
