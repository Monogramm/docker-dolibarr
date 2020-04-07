#!/bin/bash
set -eo pipefail

declare -A cmd=(
	[apache]='apache2-foreground'
	[fpm]='php-fpm'
	[fpm-alpine]='php-fpm'
)

declare -A conf=(
	[apache]=''
	[fpm]='nginx.conf'
	[fpm-alpine]='nginx.conf'
)

declare -A compose=(
	[apache]='apache'
	[fpm]='fpm'
	[fpm-alpine]='fpm'
)

declare -A base=(
	[apache]='debian'
	[fpm]='debian'
	[fpm-alpine]='alpine'
)

variants=(
	apache
	fpm
	fpm-alpine
)

archis=(
	amd64
	#arm32v5
	#arm32v6
	#arm32v7
	#arm64v8
	i386
	#ppc64le
)

min_version='7.0'


# version_greater_or_equal A B returns whether A >= B
function version_greater_or_equal() {
	[[ "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" || "$1" == "$2" ]];
}

php_versions=( "7.2" )

dockerRepo="monogramm/docker-dolibarr"
latests=( $( curl -fsSL 'https://api.github.com/repos/dolibarr/dolibarr/tags' |tac|tac| \
	grep -oE '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+' | \
	sort -urV )
	develop )

# Remove existing images
echo "reset docker images"
rm -rf ./images/
mkdir -p ./images

echo "update docker images"
travisEnv=
for latest in "${latests[@]}"; do
	version=$(echo "$latest" | cut -d. -f1-2)

	# Only add versions >= "$min_version"
	if version_greater_or_equal "$version" "$min_version"; then

		for php_version in "${php_versions[@]}"; do

			for variant in "${variants[@]}"; do

				for archi in "${archis[@]}"; do
					# Create the version+php_version+variant directory with a Dockerfile.
					dir="images/$version/php$php_version-$variant-$archi"
					if [ -d "$dir" ]; then
						continue
					fi
					echo "generating $latest [$version] php$php_version-$variant-$archi"
					mkdir -p "$dir"

					# Copy the files
					for name in entrypoint; do
						cp "template/$name.sh" "$dir/$name.sh"
						chmod 755 "$dir/$name.sh"
					done

					template="template/Dockerfile.${base[$variant]}.template"
					cp "$template" "$dir/Dockerfile"

					cp -r "template/hooks" "$dir/"
					cp -r "template/test" "$dir/"
					cp "template/.env" "$dir/.env"
					cp "template/.dockerignore" "$dir/.dockerignore"
					cp "template/docker-compose_${compose[$variant]}.yml" "$dir/docker-compose.yml"

					if [ -f "template/${conf[$variant]}" ]; then
						cp "template/${conf[$variant]}" "$dir/${conf[$variant]}"
					fi

					# Replace the variables.
					sed -ri -e '
						s/%%PHP_VERSION%%/'"$php_version"'/g;
						s/%%VARIANT%%/'"$variant"'/g;
						s/%%ARCHI%%/'"$archi"'/g;
						s/%%VERSION%%/'"$latest"'/g;
						s/%%CMD%%/'"${cmd[$variant]}"'/g;
					' "$dir/Dockerfile"

					travisEnv='\n    - VERSION='"$version"' PHP_VERSION='"$php_version"' VARIANT='"$variant"' ARCHI='"$archi$travisEnv"

					if [[ $1 == 'build' ]]; then
						tag="$version-$php_version-$variant"
						echo "Build Dockerfile for ${tag}"
						docker build -t "${dockerRepo}:${tag}" "$dir"
					fi
				done

			done

		done
	fi

done

# update .travis.yml
travis="$(awk -v 'RS=\n\n' '$1 == "env:" && $2 == "#" && $3 == "Environments" { $0 = "env: # Environments'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
