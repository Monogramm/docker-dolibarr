#!/bin/bash
set -eo pipefail

declare -A cmd=(
	[apache]='apache2-foreground'
	[fpm]='php-fpm'
	[fpm-alpine]='php-fpm'
)

declare -A conf=(
	[apache]=''
	[fpm]='nginx'
	[fpm-alpine]='nginx'
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

min_version='10.0'
dockerLatest='13.0'


# version_greater_or_equal A B returns whether A >= B
function version_greater_or_equal() {
	[[ "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" || "$1" == "$2" ]];
}

php_versions=( "7.3" )

dockerRepo="monogramm/docker-dolibarr"
latests=( $( curl -fsSL 'https://api.github.com/repos/dolibarr/dolibarr/tags' |tac|tac| \
	grep -oE '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+' | \
	sort -urV )
	develop )

# Remove existing images
echo "reset docker images"
rm -rf ./images/*

echo "update docker images"
travisEnv=
for latest in "${latests[@]}"; do
	version=$(echo "$latest" | cut -d. -f1-2)

	# Only add versions >= "$min_version"
	if version_greater_or_equal "$version" "$min_version"; then

		for php_version in "${php_versions[@]}"; do

			for variant in "${variants[@]}"; do
				# Create the version+php_version+variant directory with a Dockerfile.
				dir="images/$version/php$php_version-$variant"
				if [ -d "$dir" ]; then
					continue
				fi
				echo "generating $latest [$version] php$php_version-$variant"
				mkdir -p "$dir"

				# Copy the files
				template="template/Dockerfile.${base[$variant]}.template"
				cp "$template" "$dir/Dockerfile"
				cp "template/entrypoint.sh" "$dir/entrypoint.sh"

				cp -r "template/hooks" "$dir/"
				cp -r "template/test" "$dir/"
				cp "template/.env" "$dir/.env"
				cp "template/.dockerignore" "$dir/.dockerignore"
				cp "template/docker-compose.${compose[$variant]}.test.yml" "$dir/docker-compose.test.yml"

				if [ -n "${conf[$variant]}" ] && [ -d "template/${conf[$variant]}" ]; then
					cp -r "template/${conf[$variant]}" "$dir/${conf[$variant]}"
				fi

				# Replace the variables.
				sed -ri -e '
					s/%%PHP_VERSION%%/'"$php_version"'/g;
					s/%%VARIANT%%/'"$variant"'/g;
					s/%%VERSION%%/'"$latest"'/g;
					s/%%CMD%%/'"${cmd[$variant]}"'/g;
				' "$dir/Dockerfile"

				sed -ri -e '
					s|DOCKER_TAG=.*|DOCKER_TAG='"$version"'|g;
					s|DOCKER_REPO=.*|DOCKER_REPO='"$dockerRepo"'|g;
				' "$dir/hooks/run"

				# Create a list of "alias" tags for DockerHub post_push
				if [ "$version" = "$dockerLatest" ]; then
					if [ "$variant" = 'apache' ]; then
						echo "$latest-$variant $version-$variant $variant $latest $version latest " > "$dir/.dockertags"
					else
						echo "$latest-$variant $version-$variant $variant " > "$dir/.dockertags"
					fi
				else
					if [ "$variant" = 'apache' ]; then
						echo "$latest-$variant $version-$variant $latest $version " > "$dir/.dockertags"
					else
						echo "$latest-$variant $version-$variant " > "$dir/.dockertags"
					fi
				fi

				# Add Travis-CI env var
				travisEnv="$travisEnv"'\n    - VERSION='"$version"' PHP_VERSION='"$php_version"' VARIANT='"$variant"

				if [[ $1 == 'build' ]]; then
					tag="$version-$php_version-$variant"
					echo "Build Dockerfile for ${tag}"
					docker build -t "${dockerRepo}:${tag}" "$dir"
				fi

			done

		done
	fi

done

# update .travis.yml
travis="$(awk -v 'RS=\n\n' '$1 == "env:" && $2 == "#" && $3 == "Environments" { $0 = "env: # Environments'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
