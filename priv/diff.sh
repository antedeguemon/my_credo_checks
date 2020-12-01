#/bin/bash
git diff --name-only master | sed -e 's/^/--files-included=/' | xargs antedeguemon_checks
