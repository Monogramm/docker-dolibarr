#! .venv/bin/python3
import os
import shutil
import fileinput
import glob
import requests
import json
import re
import markdown

# Docker repository to push images to
docker_repo = 'mlaplanche/dolibarr-docker'

# Versions of Dolibarr to build Docker images for
versions = []

# Minimum version of Dolibarr to build Docker images for
min_version = "11.0.0"

# Latest version of Dolibarr
latest_version = ''

# Dictionary of base images and their corresponding Dockerfile variants
bases_images_variants = {
    'apache': 'debian',
    'fpm': 'debian',
    'fpm-alpine': 'alpine'
}

# Dictionary of base images and their corresponding Docker Compose variants
compose_variants = {
    'apache': 'apache',
    'fpm': 'fpm',
    'fpm-alpine': 'fpm'
}

# Dictionary of base images and their corresponding command variants
cmd_variants = {
    'apache': 'apache2-foreground',
    'fpm': 'php-fpm',
    'fpm-alpine': 'php-fpm'
}

# Dictionary of base images and their corresponding server web variants
serverweb_variants = {
    'apache': '',
    'fpm': 'nginx',
    'fpm-alpine': 'nginx'
}

# List of base image variants to build images for
variants = [
    "apache",
    "fpm",
    "fpm-alpine"
]

# List of architectures to build images for
archis = [
    "amd64",
    "i386"
]

php_version_by_dolibarr_version = {
    "11.0": "7.4",
    "12.0": "7.4",
    "13.0": "7.4",
    "14.0": "7.4",
    "15.0": "7.4",
    "16.0": "8.1",
}

# Fetch the tags for Dolibarr from GitHub API
dolibarr_tags = requests.get("https://api.github.com/repos/dolibarr/dolibarr/tags").text
dolibarr_tags_obj = json.loads(dolibarr_tags)

# Loop through the tags to find the versions of Dolibarr to build images for
for tag in dolibarr_tags_obj:
    print(tag['name'])
    versions.append(tag['name'])

# Sort the versions in descending order
versions.sort(reverse=True)

# Find all old Dockerfiles and delete them
old_dockerfiles = glob.glob("./images/*", recursive=True)

# Delete all old dockerfile
for file in old_dockerfiles:
    shutil.rmtree(file)

# Loop through the versions to build Docker images for
for version in versions:
    # Get the major version of the current version
    major_version = version[:4]
    
    # If latest version hasn't been set, set it to the current major version
    if latest_version == '':
        latest_version = major_version

    # If the version is less than the minimum version to build images for, skip it
    if (version < min_version):
        continue

    # Loop through the variants and architectures to build images for
    for variant in variants:
        for archi in archis:
            # Initialize variables and directories for the Docker image
            docker_tags = ''
            directory_name = f"images/{major_version}/php{php_version_by_dolibarr_version[major_version]}-{variant}-{archi}"

            # If the directory for the Docker image already exists, skip it
            if os.path.exists(directory_name):
                continue

            # Create the directory for the Docker image and copy the necessary files
            os.makedirs(directory_name)
            
            # Determine the Dockerfile template to use based on the variant and architecture
            template = f"template/Dockerfile.{bases_images_variants[variant]}.template"
            shutil.copy(template, f"{directory_name}/Dockerfile")
            shutil.copy("template/entrypoint.sh", f"{directory_name}/entrypoint.sh")
            shutil.copytree("template/hooks", f"{directory_name}/hooks")
            shutil.copytree("template/test", f"{directory_name}/test")
            shutil.copy("template/.env", f"{directory_name}/.env")
            shutil.copy("template/.dockerignore", f"{directory_name}/.dockerignore")
            shutil.copy(f"template/docker-compose.{compose_variants[variant]}.test.yml", f"{directory_name}/docker-compose.test.yml")
        
            # If there is a server web variant and its directory exists, copy it to the Docker image directory
            if serverweb_variants[variant] and os.path.exists(f"template/{serverweb_variants[variant]}"):
              shutil.copytree(f"template/{serverweb_variants[variant]}", f"{directory_name}/{serverweb_variants[variant]}")

            # Replace variables in files
            with fileinput.FileInput(directory_name+'/Dockerfile', inplace=True) as file:
                for line in file:
                    print(
                        line.replace("%%PHP_VERSION%%", php_version_by_dolibarr_version[major_version])
                        .replace("%%VARIANT%%", variant)
                        .replace("%%ARCHI%%", archi)
                        .replace("%%VERSION%%", version)
                        .replace("%%CMD%%", cmd_variants[variant]), end='')
            
            # Replace variables in the "run" hook
            with fileinput.FileInput(directory_name+'/hooks/run', inplace=True) as file:
                for line in file:
                    print(
                        line.replace("${VARIANT}", major_version)
                        .replace("${DOCKER_REPO}", docker_repo), end='')

            # Create list of tags for docker hub
            if major_version == latest_version:
                if variant == "apache":
                    docker_tags = f"{version}-{variant} {major_version}-{variant} {variant} {version} {major_version} latest"
                else:
                    docker_tags = f"{major_version}-{variant} {version}-{variant} {variant}"
            else:
                if variant == "apache":
                    docker_tags = f"{version}-{variant} {major_version}-{variant} {version} {major_version}"
                else:
                    docker_tags = f"{version}-{variant} {major_version}-{variant}"
            
            # Write the list of tags to a file
            with open(f"{directory_name}/.dockertags", "w") as f:
                f.write(docker_tags)
            dockertag_file = open(directory_name+'/.dockertags', "w")
            dockertag_file.write(docker_tags)
            dockertag_file.close()

# Update readme
# Define the table header for the Docker tags
readme_table_tags = """
|Version|Tags|Architecture|PHP|
|---|---|---|---|
"""

# Initialize the variable to keep track of the last major version processed
last_version=''

# Loop over the versions list
for version in versions:
  # Skip current iteration if major version is same as previous version
  if(last_version == version[:4]):
    continue 

  # Get the major version from the current version
  major_version = version[:4]
  
  # Update the last version variable
  last_version = major_version
  
  # Check if the current version is greater than or equal to the minimum version
  if (version >= min_version):
    # Loop over the variants list
    for variant in variants:

      # Add the major version to the table row for the Docker tags
      readme_table_tags += f"|[{major_version}](./images/{major_version})"
      
      # Determine the Docker tags based on the major version, the current
      # version, and the variant
      if major_version == latest_version:
          if variant == 'apache':
              docker_tags = f"`{version}-{variant}` `{major_version}-{variant}` `{variant}` `{version}` `{major_version}` **`latest`**"
          else:
              docker_tags = f"`{version}-{variant}` `{major_version}-{variant}` `{variant}`"
      else:
          if variant == 'apache':
              docker_tags = f"`{version}-{variant}` `{major_version}-{variant}` `{version}` `{major_version}`"
          else:
              docker_tags = f"`{version}-{variant}` `{major_version}-{variant}`"
      
      # Add the Docker tags and the architectures to the table row
      readme_table_tags += f"|{docker_tags}|"
      readme_table_tags += ", ".join(archis)
      readme_table_tags += f"|{php_version_by_dolibarr_version[major_version]}|\n"

# Open the README file for reading and writing
with open('README.md', 'r+') as file:
    # Read the contents of the file
    content = file.read()

    # Find the start and end indices of the Docker tags section in the file
    start_index_tags = content.find("<!-- >Docker Tags -->")
    end_index_tags = content.find("<!-- <Docker Tags -->")

    start_index_summary = content.find("<!-- >Summary -->")
    end_index_summary = content.find("<!-- <Summary -->")

        # Convertir le contenu markdown en HTML
    html_content = markdown.markdown(content)
    # Parcourir le contenu HTML pour extraire les titres
    headers = []
    for line in html_content.splitlines():
        # Rechercher les balises de titre
        if line.startswith("<h"):
            # Extraire le texte de la balise
            title_text = line.split(">")[1].split("<")[0]
            # Extraire le niveau de la balise
            title_level = int(line[2])
            # Ajouter le titre à la liste
            headers.append((title_text, title_level))
    
    # If the Docker tags section is found in the file,
    if (start_index_tags != -1 and end_index_tags != -1) and (start_index_summary != -1 and end_index_summary != -1):
        # Extract the old content of the Docker tags section
        old_content_tags = content[start_index_tags:end_index_tags]
        old_content_summmary = content[start_index_summary:end_index_summary]

        # Create the new content for the Docker tags section with the updated
        # table of Docker tags
        new_content_tags = f"<!-- >Docker Tags -->\n{readme_table_tags}\n"
        
        new_content_summary=f"<!-- >Summary -->\n"
        # Afficher les titres
        for title, level in headers:
            # Ajouter des espaces pour l'indentation en fonction du niveau de la balise
            indentation = "  " * (level - 1)
            # Afficher le titre formaté avec l'indentation et le niveau
            new_content_summary+=f"{indentation}- [{title}](#{title.lower().replace(' ', '-')})\n"

        # Replace the old content with the new content in the file
        content = content.replace(old_content_tags, new_content_tags)
        content = content.replace(old_content_summmary, new_content_summary)

        # Move the file pointer to the beginning of the file
        file.seek(0)

        # Write the new content to the file
        file.write(content)

        # Truncate the file to erase any remaining content after the new content
        file.truncate()
