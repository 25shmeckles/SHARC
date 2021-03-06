#!/bin/bash

usage() {
echo "
Required parameters:
    -v|--vcf		Path to vcf file

Optional parameters:
    -h|--help     Shows help
    -vff|--flank		Flank [$FLANK]
    -vfs|--vcf_fasta_script   Path to vcf_to_fasta.py script [$VCF_FASTA_SCRIPT]
    -vfo|--offset   Offset [$OFFSET]
    -vfm|--mask   Mask [$MASK]
    -e|--venv   Path to virtual env of NanoSV [$VENV]
    -o|--output Fasta output file [$OUTPUT]
"
}

POSITIONAL=()

# DEFAULTS
FLANK=200
OFFSET=0
MASK=false
OUTPUT='/dev/stdout'
VCF_FASTA_SCRIPT='/hpc/cog_bioinf/cuppen/project_data/Jose_SHARC/sharc/scripts/vcf_to_fasta.py'
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
    -vff|--flank)
    FLANK="$2"
    shift # past argument
    shift # past value
    ;;
    -vfo|--offset)
    OFFSET="$2"
    shift # past argument
    shift # past value
    ;;
    -vfm|--mask)
    MASK=true
    shift # past argument
    ;;
    -vfs|--vcf_fasta_script)
    VCF_FASTA_SCRIPT="$2"
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
fi

echo `date`: Running on `uname -n`

. $VENV

if [ $MASK = true ]; then
  python $VCF_FASTA_SCRIPT -o $OFFSET -f $FLANK -m $VCF > $OUTPUT
else
  python $VCF_FASTA_SCRIPT -o $OFFSET -f $FLANK $VCF > $OUTPUT
fi

echo `date`: Done
