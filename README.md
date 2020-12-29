# QENTA Online Guides

## Overall Structure

Organized as Git Submodules

UI Customizations, Layout, Styles, frontend JS, search: `ui-customizations/`
Content, pages, navigation, antora.yml: `content/`

# Recommended Workflow

## 1. Clone Recursively

## 2. Make Changes

After changing content, UI or any other part inside the submodules directories, **push the changes to the submodule(s) first**.

Then push current repo to trigger a build.

Pushes to `master` branch will be deployed **publically** to `gh-pages`
Pushes to any other branch will be deployed to S3/branches/branch_name/

# Build and Dev Locally

Highly recommended to use the Dockerfiles (ui and antora) via the Makefile for each step.

## 1. Build the UI
```sh
make ui.build
```

This creates `build/ui-bundle.zip` containing the UI, see it referenced in `antora-playbook.yml`
Pay attention to output, linter is very strict and will not build the UI if you're sloppy.

## 2. Build the Documentation
```sh
make antora.build
```
Creates the web pages in `build/site/`

## 3. Start Local Webserver
Contained in `antora.dockerfile`

```sh
make antora.run
```

NOTE: Console output says port `8080` but this is inside Docker, the forwarded port on `localhost` is `8051`, see `docker-compose.yml`

[http://localhost:8051/](http://localhost:8051/)

---

# Important Files

## Global Control
`antora-playbook.yml`
Disable displaying a _Page Edit_ button
`url` can be a repository url or local folder. In our case it is both: a Git submodule

```yaml
content:
  edit_url: ~
  sources:
  - url: ./
    branches: HEAD
    start_paths:
    - content/*
```

## Content Control
`antora.yml`

### Page Navigation
Navigation on the left of the page is controlled by `content/online-guides/modules/ROOT/nav.adoc`
It is a simple list of pages and their hierarchy.

# Dockerfiles
To add search functionality `antora-site-generator-lunr` is installed in the container. 
See `antora.dockerfile` for required ENV variables if you run antora without the provided Dockerfile/Makefile commands.
