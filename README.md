Django Project Template
=============================

Common Django project template for MU-Team existing and future projects.

### Current Versions

```
# for common usage:
django == 2.1.1

# for dev usage:
ipython == 6.5.0
ipdb    == 0.11
```

### The project template hierarchy

```
- requirements/
              / - common.txt  # common dependencies for development and production environments
              / - dev.txt     # only for development environment
              / - prod.txt    # only for production environment
- src/
     / - apps/...             # all user-defined apps collect here (via `./manage.py startapp`)
     / - project/...          # all project-wide configuration (settings, urls, etc.) collect here
     / - static/...           # all static sources collect here (js, css, etc.)
     / - templates/...        # all common/non-standard templates collect here
- static/...                  # `./manage.py collectstatic` root directory
- manage.py                   # project controls
```

### Conventions

1. The different settings for the development/production environment are placed in `local.example.py` with `--PLACEHOLDER--`. 
   Specific values are specified in `local.py`. Example: `DEBUG = '--DEBUG -'` --> `DEBUG = True`.
2. All user-defined apps must be placed in `apps` directory. 
   Example: `mkdir -p src/apps/core && ./manage.py startapp core src/apps/core`.
3. Installed apps must be separated by `INSTALLED_APPS`, `THIRD_PARTY_APPS`, `PROJECT_APPS`.
   `INSTALLED_APPS` contains only `django` core apps.

### Useful scripts

Setup development environment from scratch:
```bash
${PWD}/scripts/dev_setup.sh
```
