# CU Experts - experts.colorado.edu - CU Customizations for vivo-project/VIVO are listed up here

## Build process
### below is a copy  of the original VIVO README section with just VIVO maven build steps
Before building VIVO, you will also need to clone (and switch to the same branch, if other than main) of [Vitro](https://github.com/vivo-project/Vitro). The Vitro project must be cloned to a sibling directory next to VIVO so that it can be found during the build. You will also need to clone (and switch to the appropriate branch) of [Vitro-languages](https://github.com/vivo-project/Vitro-languages) and [VIVO-languages](https://github.com/vivo-project/VIVO-languages).

Build and start VIVO.

1. In Vitro-languages, run:
```
mvn install
```

2. In VIVO-languages, run:
```
mvn install
```

3. In VIVO (with Vitro cloned alongside it), run:
```
mvn clean package -s installer/example-settings.xml
```

## Docker setup
### docker-compose setup
There is a docker-compose.yml file for each vivo instance with the name of the instance appended to the end of the file.
So we have a:
1. docker-compose.yml.experts ( prod )
2. docker-compose.yml.staging ( staging )
3. docker-compose.yml.setup ( setup )

create a link to the appropropriate docker.compose.yml file for your environment
example for staging: ln -s docker-dompose.yml.staging docker-compose.yml

### Docker environment and docker context setup
This is different then the original VIVO environment. It limits the Dockerfile context to just the necessary components needed to build the tomcat docker image.
This is set here: https://github.com/UCBoulder/VIVO/blob/CUB-1.12.3/docker-compose.yml.experts#L23
This is why our CU fork has a subdirectory called - ./vivo-dockerbuild
The CU repo has copied the vivo-project start.sh and Dockerfile from the parent directory into this context directory.

Following a maven build it is necessary to copy the results of the build into this vivo-dockerbuild directory.
```
cp -rp installer/* vivo-dockerbuild/installer/
```
Note that the results of a build are NOT checked into github - this should still be setup in .gitignore to make sure it doesn't automatically happen

#### in the top level VIVO directory as the vivo user create a vivo-home directory
For example:
```
[elsborg@prometheus02 VIVO]$ pwd
/data/vivo/vivo-cub-setup/VIVO
[elsborg@prometheus02 VIVO]$ ls -lad vivo-home
drwxrwsr-x. 9 vivo fis-developers 113 Aug 19 23:39 vivo-home
```

At this point we're ready to start docker

### Prior to Starting docker

#### If your latest maven build isn't an initial build and you changed rdf files
```
# Force a start to re-read the rdf files if there a new code change
sudo rm -rf vivo-home/rdf
```
#### If you want to move around loaded database files
The VIVO software stores it's data in a TDB database - google "Apache Jena TDB"
This is located at:
```
[elsborg@prometheus02 VIVO]$ pwd
/data/vivo/vivo-cub-setup/VIVO
[elsborg@prometheus02 VIVO]$ ls -latd vivo-home/tdbContentModels/
drwxr-s---. 2 vivo fis-developers 4096 Aug 19 23:32 vivo-home/tdbContentModels/
```
We, at CU, have created backup copies of this database to baseline and empty database, templates for load databases, and backups of loaded databases.
This is the time to move them around if needed. 
Specifics will be in the CU FIS Confluence

### Starting docker
Each of the experts instances has it's own setup of systemV start scripts.
The name is the same as the instance directory:
```
[elsborg@prometheus02 vivo]$ ls -latd vivo-cub*
drwxrwsr-x. 7 elsborg fis-developers 96 Aug 18 07:55 vivo-cub-staging
drwxrwsr-x. 6 elsborg fis-developers 76 Aug 16 09:44 vivo-cub
drwxrwsr-x. 7 elsborg fis-developers 96 Aug 12 14:52 vivo-cub-setup
```
so to start vivo vivo-cub-staging do:
sudo systemctl start vivo-cub-staging

The rest of the CU Boulder specific commands to view logs and debug will be in Confluence.
To do generic VIVO debugging please see the VIVO confluence:
https://wiki.lyrasis.org/display/VIVODOC112x/

## Custom local files

Outside of various customizations for listviewConfigs, Freemarker templates, and RDF files the big addition of CU customizations is in our theme:
https://github.com/UCBoulder/VIVO/tree/CUB-1.12.3/webapp/src/main/webapp/themes/cu-boulder
eg:

```
[elsborg@prometheus02 cu-boulder]$ pwd
/data/vivo/vivo-cub-setup/VIVO/webapp/src/main/webapp/themes/cu-boulder
```

## End of CU Boulder specific section

# VIVO: Connect, Share, Discover

[![Build](https://github.com/vivo-project/VIVO/workflows/Build/badge.svg)](https://github.com/vivo-project/VIVO/actions?query=workflow%3ABuild) [![Deploy](https://github.com/vivo-project/VIVO/workflows/Deploy/badge.svg)](https://github.com/vivo-project/VIVO/actions?query=workflow%3ADeploy) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.2639714.svg)](https://doi.org/10.5281/zenodo.2639713)

VIVO is an open source semantic web tool for research discovery -- finding people and the research they do.

VIVO supports editing, searching, browsing and visualizing research activity in order to discover people, programs, 
facilities, funding, scholarly works and events. VIVO's search returns results faceted by type for rapid retrieval of 
desired information across disciplines.

## Resources

### VIVO Project web site
http://vivoweb.org/

### VIVO Project Wiki
https://wiki.lyrasis.org/display/VIVO/

### Installation Instructions

Installation instructions for the latest release can be found at this location on the wiki:  
https://wiki.lyrasis.org/display/VIVODOC112x/Installing+VIVO

### Docker

VIVO docker container is available at [vivoweb/vivo](https://hub.docker.com/repository/docker/vivoweb/vivo) with accompanying [vivoweb/vivo-solr](https://hub.docker.com/repository/docker/vivoweb/vivo-solr). These can be used independently or with docker-compose.

### Docker Compose

Docker Compose environment variables:

.env defaults
```
LOCAL_VIVO_HOME=./vivo-home
RESET_HOME=false
RESET_CORE=false
```

- `LOCAL_VIVO_HOME`: VIVO home directory on your host machine which will mount to volume in docker container. Set this environment variable to persist your VIVO data on your host machine.
- `RESET_HOME`: Convenience to reset VIVO home when starting container. **Caution**, will delete local configuration, content, and configuration model.
- `RESET_CORE`: Convenience to reset VIVO Solr core when starting container. **Caution**, will require complete reindex.

Before building VIVO, you will also need to clone (and switch to the same branch, if other than main) of [Vitro](https://github.com/vivo-project/Vitro). The Vitro project must be cloned to a sibling directory next to VIVO so that it can be found during the build. You will also need to clone (and switch to the appropriate branch) of [Vitro-languages](https://github.com/vivo-project/Vitro-languages) and [VIVO-languages](https://github.com/vivo-project/VIVO-languages).

Build and start VIVO.

1. In Vitro-languages, run:
```
mvn install
```

2. In VIVO-languages, run:
```
mvn install
```

3. In VIVO (with Vitro cloned alongside it), run:
```
mvn clean package -s installer/example-settings.xml
docker-compose up
```

### Docker Image

To build and run local Docker image.

```
docker build -t vivoweb/vivo:development .
docker run -p 8080:8080 vivoweb/vivo:development
```

## Contact us
There are several ways to contact the VIVO community. 
Whatever your interest, we would be pleased to hear from you.

### Contact form 
http://vivoweb.org/support/user-feedback

### Mailing lists

#### [vivo-all](https://groups.google.com/forum/#!forum/vivo-all) 
This updates list provides news to the VIVO community of interest to all.

#### [vivo-community](https://groups.google.com/forum/#!forum/vivo-community)  
Join the VIVO community!  Here you'll find non-technical discussion regarding participation, the VIVO
conference,  policy, project management, outreach, and engagement. 

#### [vivo-tech](https://groups.google.com/forum/#!forum/vivo-tech)  
The best place to get your hands dirty in the VIVO Project. 
Developers and implementers frequent this list to get the latest on feature design, 
development, implementation, and testing.

## Contributing Code
If you would like to contribute code to the VIVO project, please open a ticket 
in our [JIRA](https://jira.lyrasis.org/projects/VIVO), and prepare a 
pull request that references your ticket.  Contributors welcome!

## Citing VIVO
If you are using VIVO in your publications or projects, please cite the software paper in the Journal of Open Source Software:

* Conlon et al., (2019). VIVO: a system for research discovery. Journal of Open Source Software, 4(39), 1182, https://doi.org/10.21105/joss.01182

### BibTeX
```tex
@article{Conlon2019,
  doi = {10.21105/joss.01182},
  url = {https://doi.org/10.21105/joss.01182},
  year = {2019},
  publisher = {The Open Journal},
  volume = {4},
  number = {39},
  pages = {1182},
  author = {Michael Conlon and Andrew Woods and Graham Triggs and Ralph O'Flinn and Muhammad Javed and Jim Blake and Benjamin Gross and Qazi Asim Ijaz Ahmad and Sabih Ali and Martin Barber and Don Elsborg and Kitio Fofack and Christian Hauschke and Violeta Ilik and Huda Khan and Ted Lawless and Jacob Levernier and Brian Lowe and Jose Martin and Steve McKay and Simon Porter and Tatiana Walther and Marijane White and Stefan Wolff and Rebecca Younes},
  title = {{VIVO}: a system for research discovery},
  journal = {Journal of Open Source Software}
}
