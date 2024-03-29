#!/bin/bash

source=$(readlink -f ${BASH_SOURCE[0]})
prefix=$(dirname ${source})

base_item_trunk="${prefix}/base"
base_item_profile="${base_item_trunk}/rprofile-base"
base_item_dev="${base_item_trunk}/makevars-base"

source_data="${prefix}/trunk"
source_trunk_lib="${source_data}/.rlibs"
source_trunk_dev="${source_data}/.R"
source_trunk_profile="${source_data}"
source_item_profile=".Rprofile"
source_item_dev="Makevars"

target_trunk="${HOME}"
target_trunk_libs="${target_trunk}/.rlibs"
target_trunk_dev="${target_trunk}/.R"
target_trunk_profile="${target_trunk}"
target_item_profile=".Rprofile"
target_item_dev="Makevars"
target_profile="${target_trunk_profile}/${target_item_profile}"
target_dev="${target_trunk_dev}/${target_item_dev}"

feature_name="devtools"
feature_item_dev="${base_item_trunk}/makevars-${feature_name}"
feature_module_list="${base_item_trunk}/modules-${feature_name}"
feature_setup_command="Rscript"
feature_setup_script="${base_item_trunk}/rscript-${feature_name}"

function target-disable() {
    
    local stamp="$(date +'%m%d%Y-%H%M')"
    local backup="${1}-${stamp}"
	local target="${1}"
    
    [[ -z ${target} ]] && { echo -e "usage: ${FUNCNAME[0]} <file_or_symlink_path>"; return 1; } # no file passed to function
    [[ -h ${target} ]] && rm ${target} &>/dev/null #|| { echo "error: unable to remove symbolic link" >&2; return 1; }  # symbolic link, okay too just delete
    [[ -e ${target} ]] || return 0 # no existing file, already "disabled"
    [[ -f ${target} ]] && mv ${target} ${backup} &>/dev/null #|| { echo "error: unable to remove symbolic link" >&2; return 1; } # regular file, create copy
    [[ -e ${target} ]] && return 1 # still exists, something must've gone wrong

	return 0

}

function target-enable() {
	
    local source=${1}
    local target=${2} 
    
    [[ -z ${target} ]] && return 1
    [[ ! -e ${source} ]] && return 1
    
    target-disable ${target} || return 1
    
    [[ ! -e ${target} ]] && ln -s ${source} ${target} &>/dev/null || return 1
    [[ -L ${target} ]] || return 1
	
    return 0

}
