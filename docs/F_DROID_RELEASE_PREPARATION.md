# F-Droid release preparation

This repository is prepared for a future first public release, but it is not
yet published and no F-Droid metadata submission has been made.

## Information required after publication

Fill these values in the F-Droid submission metadata only after the public
repository exists:

- `SourceCode`: the public Git repository URL;
- `IssueTracker`: the public issue tracker URL;
- `Changelog`: the public changelog URL, if maintained separately;
- `WebSite`: the project website, if one is created;
- maintainer/support contact, according to the selected hosting and F-Droid
  process;
- the immutable `v1.0.0` source tag.

Do not replace these with invented or local URLs.

## Local fdroidserver setup

Do not install system packages automatically from this repository. In a clean
Ubuntu environment, install fdroidserver in an isolated Python environment
using the current official instructions:

```sh
python3 -m venv "$HOME/.venvs/fdroidserver"
"$HOME/.venvs/fdroidserver/bin/python" -m pip install --upgrade pip
"$HOME/.venvs/fdroidserver/bin/pip" install \
  git+https://gitlab.com/fdroid/fdroidserver.git
```

Then, from the repository checkout, run the official metadata/build checks
after the public repository URL and tag are available:

```sh
cd app
"$HOME/.venvs/fdroidserver/bin/fdroid" readmeta
"$HOME/.venvs/fdroidserver/bin/fdroid" lint
"$HOME/.venvs/fdroidserver/bin/fdroid" build -v -l
```

The exact F-Droid build recipe belongs in the public F-Droid metadata
submission once the source URL and tag exist. `.fdroid.yml` is intentionally
not added yet because it would require repository-specific source information.

References:

- <https://f-droid.org/docs/Installing_the_Server_and_Repo_Tools/>
- <https://gitlab.com/fdroid/fdroiddata/-/blob/master/CONTRIBUTING.md>
- <https://f-droid.org/docs/Building_Applications/>
