# Mamba environment in garnatxa - SQANTI3

mkdir SQANTI3v5.3.4
cd SQANTI3v5.3.4

wget  https://github.com/ConesaLab/SQANTI3/releases/download/v5.3.4/SQANTI3_v5.3.4.zip 
# tar -xf SQANTI3_v5.3.4.zip command on SQANTI wikihow did not work
unzip SQANTI3_v5.3.4.zip

# From 2-02b-4) steps of this READme, I instead git clone https://github.com/ConesaLab/SQANTI3.git to be able to git pull in case some changes were made when small issues were encountered, as follow:
in SQANTI3/
git pull origin master

git log -1 # to get the latest commit of the pull
git status 

# To use SQANTI3, move into the SQANTI3 folder and create a virtual environment 
interactive
module load anaconda

# in SQANTI3v5.3.4/:
conda env create -f SQANTI3.conda_env.yml
conda activate SQANTI3.env # it didn't work, even with mamba

# from garnatxa support team:
export PIP_DEFAULT_TIMEOUT=100
mamba env remove -n sqanti3
module load anaconda
mamba env create -f SQANTI3.conda_env.yml
mamba activate sqanti3