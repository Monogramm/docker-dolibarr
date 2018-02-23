#!/bin/bash
set -eo pipefail

declare -A cmd=(
	[apache]='apache2-foreground'
	[fpm]='php-fpm'
)

# version_greater_or_equal A B returns whether A >= B
function version_greater_or_equal() {
	[[ "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" || "$1" == "$2" ]];
}

# TODO Find a way to retrieve automatically the latest versions
# latests=( $( curl -fsSL 'https://sourceforge.net/projects/dolibarr/files/Dolibarr%20ERP-CRM/' |tac|tac| \
# 	grep -oE '[[:digit:]]+(.[[:digit:]]+)+(.[[:digit:]]+)+' | \
# 	sort -urV ) )
latests=( "5.0.7" "6.0.5" "7.0.0" )

# Remove existing images
echo "reset docker images"
find ./images -maxdepth 1 -type d -regextype sed -regex '\./images/[[:digit:]]\+\.[[:digit:]]\+' -exec rm -r '{}' \;

echo "update docker images"
travisEnv=
for latest in "${latests[@]}"; do
	version=$(echo "$latest" | cut -d. -f1-2)

	if [ -d "$version" ]; then
		continue
	fi

	# Only add versions >= 5
	if version_greater_or_equal "$version" "5.0"; then

		for variant in apache fpm; do
			echo "updating $latest [$version] $variant"

			# Create the version+variant directory with a Dockerfile.
			dir="images/$version/$variant"
			mkdir -p "$dir"

			template="Dockerfile.template"
			cp "$template" "$dir/Dockerfile"

			# Replace the variables.
			sed -ri -e '
				s/%%VARIANT%%/'"$variant"'/g;
				s/%%VERSION%%/'"$latest"'/g;
				s/%%CMD%%/'"${cmd[$variant]}"'/g;
			' "$dir/Dockerfile"

			# Copy the shell scripts
			for name in entrypoint; do
				cp "docker-$name.sh" "$dir/$name.sh"
				chmod 755 "$dir/$name.sh"
			done

			travisEnv='\n    - VERSION='"$version"' VARIANT='"$variant$travisEnv"

			if [[ $1 == 'build' ]]; then
				echo "Build Dockerfile for Dolibarr ${tag}"
				docker build -t madmath03/docker-dolibarr:${tag} $dir
			fi
		done
	fi
done

# update .travis.yml
travis="$(awk -v 'RS=\n\n' '$1 == "env:" && $2 == "#" && $3 == "Environments" { $0 = "env: # Environments'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
