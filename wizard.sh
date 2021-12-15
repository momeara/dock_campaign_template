#!/bin/bash

##
## This is an interactive script to giuide through the stages
## of a docking campaign. To get started:
##
##  cd <campaign_base_directory>
##  /path/to/dock_campaign_template/wizard.sh
##
##




# test if ${DOCK_TEMPLATE} has been defined

if [ -z ${DOCK_TEMPLATE+x} ]; then
    echo "Please set the \${DOCK_TEMPLATE} environment variable."
    echo "Usually you would do this by"
    echo ""
    echo "  cd <campaign_root>"
    echo "  source setup_dock_environment.sh"
    echo ""
    exit 1
fi


setup_database () {

    #######################################
    # Check campaign has been initialized #
    #######################################
    if [ ! -d databases ]; then
	echo "ERROR: './databases' does not exist"
	echo "Please change to the campaign base direcotry"
	echo ""
	echo "   cd <campaign_base_direcotry>"
	echo ""
	echo "or if you you are already there, then initialize the dock campaign by running"
	echo ""
	echo "   \${DOCK_TEMPLATE}/scripts/initialize_dock_campaign.sh"
	echo ""
	exit 1
    fi

    ###############################
    # Have user select a template #
    ###############################
    PS3='Select a template:'
    database_templates=($(cd ${DOCK_TEMPLATE}/databases && find * -name "TEMPLATE_*" | sort -t '\0'))
    database_templates+=("Use existing database as template")
    select database_template in "${database_templates[@]}"; do
	if [[ ${database_template} = "Use existing database as template" ]]; then
	    database_ids=($(find databases -mindepth 1 -maxdepth 1 -type d -printf "%P\n" | sort -t '\0'))
	    if [ ${#database_ids[@]} -eq 0 ]; then
		echo "ERROR: No databases have been setup"
		echo "Please run"
		echo ""
		echo "  \${DOCK_TEMPLATE}/wizard.sh"
		echo "  select '1) Database'"
		echo ""
		exit 1
	    fi
	    PS3='Select an existing database as a template:'
	    select database_id in "${database_ids[@]}"; do
		break
	    done
	    template_path="databases/${database_id}"
	else
	    template_path="${DOCK_TEMPLATE}/databases/${database_template}"
	fi
	break
    done

    if [ ! -d ${template_path} ]; then
	echo "The template path '${template_path}' does not exist!"
	break
    fi

    ###########################################
    # Have the user define the database path #
    ###########################################
    read -p "Database tag:" -s database_tag
    database_path="databases/${database_tag}_$(date +%Y%m%d)"
    if [ -d ${database_path} ]; then
       echo "The database path '${database_path}' already exists!"
       break
    fi

    #########################################
    # Copy template to initialize database #
    #########################################
    echo "Copying database template '${template_path}' -> '${database_path}'"
    cp -r ${template_path} ${database_path}
    if [ ! $? -eq 0 ]; then
	echo "ERROR: Failed to initialize database ${database_path}, check setup and try again."
	exit 1
    fi

    #######################
    # Describe next steps #
    #######################
    echo "Next steps:"
    echo ""
    echo "  pushd ${database_path}"
    echo "  # edit 1_make_database.sh"
    echo "  ./1_make_database.sh"
    echo "  popd"
    echo ""
    echo "Then make the structure..."
    echo ""
    echo "  \${DOCK_TEMPLATE}/wizard.sh"
    echo "  select '2) Make structure'"
    echo ""
}

make_structure () {

    #######################################
    # Check campaign has been initialized #
    #######################################
    if [ ! -d structures ]; then
	echo "ERROR: './structures' does not exist"
	echo "Please change to the campaign base direcotry"
	echo ""
	echo "   cd <campaign_base_direcotry>"
	echo ""
	echo "or if you you are already there, then initialize the dock campaign by running"
	echo ""
	echo "   \${DOCK_TEMPLATE}/scripts/initialize_dock_campaign.sh"
	echo ""
	exit 1
    fi

    ###############################
    # Have user select a template #
    ###############################
    template_path=''
    PS3='Select a template:'
    structure_templates=($(cd ${DOCK_TEMPLATE}/structures && find * -name "TEMPLATE_*" | sort -t '\0'))
    structure_templates+=("Use existing structure as template")
    select structure_template in "${structure_templates[@]}"; do
	if [[ ${structure_template} = "Use existing structure as template" ]]; then
	    structure_ids=($(find structures -mindepth 1 -maxdepth 1 -type d -printf "%P\n" | sort -t '\0'))
	    if [ ${#structure_ids[@]} -eq 0 ]; then
		echo "ERROR: No structures have been setup"
		echo "Please run"
		echo ""
		echo "  \${DOCK_TEMPLATE}/wizard.sh"
		echo "  select '2) Make structure'"
		echo ""
		exit 1
	    fi
	    PS3='Select an existing structure as a template:'
	    select structure_id in "${structure_ids[@]}"; do
		break
	    done
	    template_path="structures/${structure_id}"
	else
	    template_path="${DOCK_TEMPLATE}/structures/${structure_template}"
	fi
	break
    done

    if [ ! -d ${template_path} ]; then
       echo "The template path '${template_path}' does not exist!"
       break
    fi

    ###########################################
    # Have the user define the structure path #
    ###########################################
    read -p "structure tag:" -s structure_tag
    structure_path="structures/${structure_tag}_$(date +%Y%m%d)"
    if [ -d ${structure_path} ]; then
       echo "The structure path '${structure_path}' already exists!"
       break
    fi

    #########################################
    # Copy template to initialize structure #
    #########################################
    echo "Copying structure template '${template_path}' -> '${structure_path}'"
    if [[ ${structure_template} = "Use existing structure as template" ]]; then
	mkdir ${structure_path}
	cp ${template_path}/1_make_structure.sh ${structure_path}/
    else
	cp -r ${template_path} ${structure_path}
    fi

    if [ ! $? -eq 0 ]; then
	echo "ERROR: Failed to initialize structure ${structure_path}, check setup and try again."
	exit 1
    fi

    #######################
    # Describe next steps #
    #######################
    echo "Next steps:"
    echo ""
    echo "  pushd ${structure_path}"
    echo "  # edit 1_make_structure.sh"
    echo "  ./1_make_structure.sh"
    echo "  popd"
    echo ""
    echo "Next prepare the structure for docking with"
    echo ""
    echo "  \${DOCK_TEMPLATE}/wizard.sh"
    echo "  select '3) Prepare structure'"
    echo ""
}

prepare_structure () {

    #######################################
    # Check campaign has been initialized #
    #######################################
    if [ ! -d prepared_structures ]; then
	echo "ERROR: './prepared_structures' does not exist"
	echo "Please change to the campaign base direcotry"
	echo ""
	echo "   cd <campaign_base_direcotry>"
	echo ""
	echo "or if you you are already there, then initialize the dock campaign by running"
	echo ""
	echo "   \${DOCK_TEMPLATE}/scripts/initialize_dock_campaign.sh"
	echo ""
	exit 1
    fi

    ###############################################
    # Have the user select a structure to prepare #
    ###############################################
    PS3='Select a structure to prepare:'
    structure_ids=($(find structures -mindepth 1 -maxdepth 1 -type d -printf "%P\n" | sort -t '\0'))
    if [ ${#structure_ids[@]} -eq 0 ]; then
	echo "ERROR: No structures have been setup"
	echo "Please run"
	echo ""
	echo "  \${DOCK_TEMPLATE}/wizard.sh"
	echo "  select '2) Make structure'"
	echo ""
	exit 1
    fi
    select prepared_structure_id in "${structure_ids[@]}"; do
	break
    done
    prepared_structure_path="prepared_structures/${prepared_structure_id}"

    if [ -d ${prepared_structure_path} ]; then
       echo "The prepared structure path '${prepared_structure_path}' already exists!"
       break
    fi

    ###############################
    # Have user select a template #
    ###############################
    template_path=''
    PS3='Select a template:'
    prepared_structure_templates=($(cd ${DOCK_TEMPLATE}/prepared_structures && find * -name "TEMPLATE_*" | sort -t '\0'))
    prepared_structure_templates+=("Use existing prepared structure as template")
    select prepared_structure_template in "${prepared_structure_templates[@]}"; do
	if [[ ${prepared_structure_template} = "Use existing prepared structure as template" ]]; then
	    prepared_structure_ids=($(find prepared_structures -mindepth 1 -maxdepth 1 -type d -printf "%P\n" | sort -t '\0'))
	    if [ ${#prepared_structure_ids[@]} -eq 0 ]; then
		echo "ERROR: No prepared structures have been setup"
		echo "Please run"
		echo ""
		echo "  \${DOCK_TEMPLATE}/wizard.sh"
		echo "  select '3) Prepare structure'"
		echo ""
		exit 1
	    fi
	    PS3='Select an existing prepared structure as a template:'
	    select prepared_structure_id in "${prepared_structure_ids[@]}"; do
		break
	    done
	    template_path="structures/${prepared_structure_id}"
	else
	    template_path="${DOCK_TEMPLATE}/structures/${prepared_structure_template}"
	fi
	break
    done

    echo "Template path ${template_path}"
    if [ ! -d ${template_path} ]; then
       echo "The template path '${template_path}' does not exist!"
       break
    fi

    ######################################################
    # Copy template to initialize the prepared structure #
    ######################################################
    echo "Copying structure template '${template_path}' -> '${prepared_structure_path}'"
    if [[ ${structure_template} = "Use existing structure as template" ]]; then
	mkdir ${prepared_structure_path}
	cp ${template_path}/1_prepare_structure.sh ${prepared_structure_path}/
    else
	cp -r ${template_path} ${prepared_structure_path}
    fi

    if [ ! $? -eq 0 ]; then
	echo "ERROR: Failed to initialize prepared structure ${prepared_structure_path}, check setup and try again."
	exit 1
    fi

    #######################
    # Describe next steps #
    #######################
    echo "Next steps:"
    echo ""
    echo "  pushd ${prepared_structure_path}"
    echo "  # edit 1_prepare_structure.sh"
    echo "  ./1_prepare_structure.sh"
    echo "  popd"
    echo ""
    echo "Then setup to run dock..."
    echo ""
    echo "  \${DOCK_TEMPLATE}/wizard.sh"
    echo "  select '4) Docking run'"
    echo ""
}

docking_run () {

    #######################################
    # Check campaign has been initialized #
    #######################################
    if [ ! -d docking_runs ]; then
	echo "ERROR: './docking_runs' does not exist"
	echo "Please change to the campaign base direcotry"
	echo ""
	echo "   cd <campaign_base_direcotry>"
	echo ""
	echo "or if you you are already there, then initialize the dock campaign by running"
	echo ""
	echo "   \${DOCK_TEMPLATE}/scripts/initialize_dock_campaign.sh"
	echo ""
	exit 1
    fi

    ###############################
    # Have user select a database #
    ###############################
    PS3='Select a database:'
    database_ids=($(find databases -mindepth 1 -maxdepth 1 -type d -printf "%P\n" | sort -t '\0'))
    if [ ${#database_ids[@]} -eq 0 ]; then
	echo "ERROR: No databases have been setup"
	echo "Please run"
	echo ""
	echo "  \${DOCK_TEMPLATE}/wizard.sh"
	echo "  select '1) Database'"
	echo ""
	exit 1
    fi
    select database_id in "${database_ids[@]}"; do
	break
    done

    #########################################
    # Have user select a prepared structure #
    #########################################
    PS3='Select a prepared structure:'
    prepared_structure_ids=($(find prepared_structures -mindepth 1 -maxdepth 1 -type d -printf "%P\n"| sort -t '\0'))
    if [ ${#prepared_structure_ids[@]} -eq 0 ]; then
	echo "ERROR: No structures have been prepared for docking"
	echo "Please run"
	echo ""
	echo "  \${DOCK_TEMPLATE}/wizard.sh"
	echo "  select '3) Prepare structure'"
	echo ""
	exit 1
    fi
    select prepared_structure_id in "${prepared_structure_ids[@]}"; do
	break
    done

    ###############################
    # Have user select a template #
    ###############################
    template_path=''
    PS3='Select a template:'
    docking_run_templates=($(cd ${DOCK_TEMPLATE}/docking_runs && find * -name "TEMPLATE_*" | sort -t '\0'))
    docking_run_templates+=("Use existing docking run as template")
    select docking_run_template in "${docking_run_templates[@]}"; do
	if [[ ${docking_run_template} = "Use existing docking run as template" ]]; then
	    docking_run_ids=($(find docking_runs -mindepth 1 -maxdepth 1 -type d -printf "%P\n" | sort -t '\0'))
	    if [ ${#docking_run_ids[@]} -eq 0 ]; then
		echo "ERROR: No docking_runs have been setup"
		echo "Please run"
		echo ""
		echo "  \${DOCK_TEMPLATE}/wizard.sh"
		echo "  select '4) Docking run'"
		echo ""
		exit 1
	    fi
	    PS3='Select an existing docking run as a template:'
	    select docking_run_id in "${docking_run_ids[@]}"; do
		break
	    done
	    template_path="docking_runs/${docking_run_id}"
	else
	    template_path="${DOCK_TEMPLATE}/docking_runs/${docking_run_template}"
	fi

	if [ ! -d ${template_path} ]; then
	    echo "The template path '${template_path}' does not exist!"
	    exit 1
	fi
	break
    done

    #############################################
    # Have the user define the docking run path #
    #############################################
    read -p "docking_run tag (leave blank for default):" -s docking_run_tag
    docking_run_path="docking_runs/${prepared_structure_id},${database_id},${docking_run_tag},$(date +%Y%m%d)"
    if [ -d ${docking_run_path} ]; then
       echo "The dock_run path '${docking_run_path}' already exists!"
       break
    fi

    ###########################################
    # Copy template to initialize docking run #
    ###########################################
    echo "Copying dock_run template '${template_path}' -> '${docking_run_path}'"
    if [[ ${docking_run_template} = "Use existing docking run as template" ]]; then
	mkdir ${docking_run_path}
	cp ${template_path}/1_run.sh ${docking_run_path}/
    else
	cp -r ${template_path} ${docking_run_path}
    fi

    if [ ! $? -eq 0 ]; then
	echo "ERROR: Failed to initialize docking run ${docking_run_path}, check setup and try again."
	exit 1
    fi

    #######################
    # Describe next steps #
    #######################
    echo "Next steps:"
    echo ""
    echo "  pushd ${docking_run_path}"
    echo "  # edit 1_run.sh"
    echo "  ./1_run.sh"
    echo "  popd"
    echo ""
    echo "Then for the final results check"
    echo ""
    echo "  product/$(basename ${docking_run_path})"
    echo ""
}


##############################
# Main entry point to script #
##############################

PS3='What would you like to setup next?'
options=("Database" "Make structure" "Prepare structure" "Docking run" "Quit")
select opt in "${options[@]}"; do
case $opt in
  "Database")
  echo "Set up a database for docking..."
  setup_database
  break
  ;;
  "Make structure")
  echo "Set up a structure for docking..."
  make_structure
  break
  ;;
  "Prepare structure")
  echo "Prepare a structure for docking..."
  prepare_structure
  break
  ;;
  "Docking run")
  echo "Set up a docking run..."
  docking_run
  break
  ;;
  "Quit")
  break
  ;;
  *) echo "invalid option $REPLY";;
esac
done
