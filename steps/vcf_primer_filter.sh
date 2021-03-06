#!/bin/bash

usage() {
echo "
Required parameters:
    -v|--vcf		    Path to vcf file
    -p|--primers		Path to primers file

Optional parameters:
    -h|--help       Shows help
    -s|--script     Path to vcf_primer_filter.py [$SCRIPT]
    -e|--venv   Path to virtual env of NanoSV [$VENV]
    -o|--output     VCF output file [$OUTPUT]
"
}

POSITIONAL=()

# DEFAULTS
OUTPUT='/dev/stdout'
SCRIPT='/hpc/cog_bioinf/cuppen/project_data/Jose_SHARC/sharc/scripts/vcf_primer_filter.py'
VENV='/hpc/cog_bioinf/cuppen/project_data/Jose_SHARC/sharc/venv/bin/activate'

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
    -h|--help)
    usage
    shift # past argument
    ;;
    -v|--vcf)
    VCF="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--primers)
    PRIMERS="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--script)
    SCRIPT="$2"
    shift # past argument
    shift # past value
    ;;
    -e|--venv)
    VENV="$2"
    shift # past argument
    shift # past value
    ;;
    -o|--output)
    OUTPUT="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters
if [ -z $VCF ]; then
    echo "Missing -v|--vcf parameter"
    usage
    exit
elif [ -z $PRIMERS ]; then
    echo "Missing -p|--primers parameter"
    usage
    exit
fi

echo `date`: Running on `uname -n`

. $VENV

python $SCRIPT $VCF $PRIMERS > $OUTPUT

echo `date`: Done
