# F-Droid release preparation

This public repository is prepared for a future first F-Droid submission. No
F-Droid metadata submission has been made yet.

## Public repository

- SourceCode: <https://github.com/RuslanLit/Tutor_Language>
- IssueTracker: <https://github.com/RuslanLit/Tutor_Language/issues>

No project website or personal support email is declared.

## Information required before submission

Complete these values in the F-Droid submission metadata before submission:

- `SourceCode`: use the public Git repository URL above;
- `IssueTracker`: use the public issue tracker URL above;
- `Changelog`: the public changelog URL, if maintained separately;
- `WebSite`: the project website, if one is created;
- maintainer/support contact, according to the selected hosting and F-Droid
  process;
- the immutable `v1.0.0` source tag, which has not been created yet.

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
after the `v1.0.0` source tag is available:

```sh
cd app
"$HOME/.venvs/fdroidserver/bin/fdroid" readmeta
"$HOME/.venvs/fdroidserver/bin/fdroid" lint
"$HOME/.venvs/fdroidserver/bin/fdroid" build -v -l
```

The exact F-Droid build recipe belongs in the public F-Droid metadata
submission. `.fdroid.yml` is intentionally not added yet because the release
tag and final F-Droid build recipe are not available.

## Reproducible-build follow-up

Future reproducible-build work: investigate Flutter embedded absolute build
paths. This does not block the standard F-Droid source-build/signing workflow
for v1.0.0.

References:

- <https://f-droid.org/docs/Installing_the_Server_and_Repo_Tools/>
- <https://gitlab.com/fdroid/fdroiddata/-/blob/master/CONTRIBUTING.md>
- <https://f-droid.org/docs/Building_Applications/>
