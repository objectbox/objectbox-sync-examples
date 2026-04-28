#!/usr/bin/env bash
set -euo pipefail

# This script will replace the version strings for projects that use the ObjectBox Java libraries:
# - tasks/client-android-java
# - tasks/client-android-kotlin
# - tasks/client-java
# And commit the changes.

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <versionNew>"
    exit 1
fi
versionNew="$1"

# macOS includes the BSD version of sed, which has different options and syntax than the
# expected GNU version. So require users of this script to install gsed.
if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! command -v gsed &>/dev/null; then
    echo "Error: gsed is required but not installed. Install it, for example using 'brew install gsed'."
    exit 1
  fi
  sed="gsed"
else
  sed="sed"
fi

# Replace versions
scriptDir="$(dirname "$0")"
tasksBasePath="$scriptDir/../tasks"

versionCatalogAndroidJava="$tasksBasePath/client-android-java/gradle/libs.versions.toml"
echo "Updating $versionCatalogAndroidJava"
$sed --in-place "s/objectbox = \".*\"/objectbox = \"$versionNew\"/g" "$versionCatalogAndroidJava"

versionCatalogAndroidKotlin="$tasksBasePath/client-android-kotlin/gradle/libs.versions.toml"
echo "Updating $versionCatalogAndroidKotlin"
$sed --in-place "s/objectbox = \".*\"/objectbox = \"$versionNew\"/g" "$versionCatalogAndroidKotlin"

versionCatalogJavaGradle="$tasksBasePath/client-java/gradle/libs.versions.toml"
echo "Updating $versionCatalogJavaGradle"
$sed --in-place "s/objectbox = \".*\"/objectbox = \"$versionNew\"/g" "$versionCatalogJavaGradle"

mavenPom="$tasksBasePath/client-java/pom.xml"
echo "Updating $mavenPom"
$sed --in-place "s/<objectboxVersion>.*<\/objectboxVersion>/<objectboxVersion>$versionNew<\/objectboxVersion>/g" "$mavenPom"

git commit --all --message="Java: update to release $versionNew"
