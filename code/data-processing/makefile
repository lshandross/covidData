# covidData

# Define global variables
# Where JHU files are downloaded
JHUDIR = ../../data-raw/JHU/
# One directory above package root
ROOTDIR = ../../../

# Define the full make
all: install pull

# Define the full make using only recent data
recent_data: install_recent 

# Pull latest changes to covidData github repo
pull:
	git -C ../../ pull origin master --ff-only

# Install R package with updated data
install: pull
	R CMD INSTALL ../../../covidData

# Install R package with most recent data
install_recent: pull
	R CMD INSTALL ../../../covidData


	
