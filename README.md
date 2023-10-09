# Dock Campaign Template
An opinionated template for a Dock based virtual screening campaign

* Dock involves running a bunch of fortran wrapped in python wrapped
  in shell scripts. This template setups a standard way to organize
  the data and common workflows.

* For each call to a script in `scripts/`, I recommand reading through
  it to make sure you understand what it is doing.

* All files/folders with date codes indicate that once the analysis is
  done they are immutable, and can be referenced externally. To keep
  sortable I like to use the format YYYYMMDD.

* For scripts that must be run sequentially number them with leading 0s
  so they are sortable

# Getting started

0. Install DOCK (http://dock.compbio.ucsf.edu/)
  
     0. Go to click on [DOCK 3](http://dock.compbio.ucsf.edu/DOCK3.7/)
     1. Click the **Obtaining Dock** -> [License Information](http://dock.compbio.ucsf.edu/Online_Licensing/index.htm) link
     2. Click either link for [academic license](http://dock.compbio.ucsf.edu/Online_Licensing/dock_license_application.html) or follow instructions for the industry license.
     3. Specify version **Dock 3.8**
     4. Submit and wait for the email/download link

1. Clone the template repo to somewhere you can reference. I like to put it in ~/opt/dock_campaign_template.git

```shell
cd ~/opt
git clone https://github.com/maomlab/dock_campaign_template.git
```

2. Create a base directory for the project, e.g. for example for docking to KCNQ channels on the UMich Great Lakes cluster we may use ~/turbo/KCNQ/docking

```shell
cd ~/turbo/KCNQ
mkdir docking
cd docking


2. Initialize the environment. Currently this is setup up for paths on the bkslab cluster, so modify for your environment. This creates several directories.
```shell
source ~/opt/dock_campaign_template/scripts/initialize_dock_campaign.sh
```

3. Edit setup_dock_environment.sh for your environment. For example if you can submit jobs to a HPC cluster, fill in the cluster type and parameters

# Using the Dock Campaing Template

Each time you log in, source the setup file to set paths etc.

```shell
source setup_dock_environment.sh
```

Docking involves a series of stages from setting up the receptor and database to running dock

At each stage call the wizard to guide you through using the templates
```shell
${DOCK_TEMPLATE}/scripts/wizard.sh
```

