#!/bin/bash

versions=( "5.0.7" "6.0.5" "7.0.0" "latest" )
variants=( "5.6" "7" )

rm -rf images/

for version in ${versions[@]}; do
  echo "Generate Dockerfile for Dolibarr $version"
  if [ "$version" = "latest" ]; then
    archive="develop"
  else
    archive="${version}"
  fi

  for php_version in ${variants[@]}; do
    if [ "$php_version" = "5.6" ]; then
      tag="${version}"
    else 
      tag="${version}-php${php_version}"
    fi
    dir="images/${tag}"

    mkdir -p $dir

    sed '
          s/%PHP_VERSION%/'"$php_version"'-apache/;
          s/%VERSION%/'"$archive"'/;
    ' Dockerfile.template > $dir/Dockerfile

    cp entrypoint.sh $dir/

    if [[ $1 ]]; then
      echo "Build Dockerfile for Dolibarr ${tag}"
      docker build -t madmath03/dolibarr:${tag} $dir
    fi
  done
done
