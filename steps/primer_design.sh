#!/bin/bash

usage() {
echo "
Required parameters:
    -f|--fasta		Path to fasta file

Optional parameters:
    -h|--help     Shows help
    -pdb|--bindir		Bindir [$BINDIR]
    -pdpt|--pcr_type   PCR type [$PCR_TYPE]
    -pdtp|--tilling_params Tilling parameters [$TILLING_PARAMS]
    -psr|--psr  PSR [$PSR]
    -pdgp|--guix_profile   GUIX profile [$GUIX_PROFILE]
    -pdpc|--primer3_core   Primer3 core [$PRIMER3_CORE]
    -pdm|--mispriming     Mispriming [$MISPRIMING]
"
}

POSITIONAL=()

# DEFAULTS
BINDIR='/hpc/cog_bioinf/cuppen/personal_data/jvalleinclan/tools_kloosterman/primer3/primers'
PCR_TYPE='single'
TILLING_PARAMS=' '
PSR='30-230'
GUIX_PROFILE='/hpc/cog_bioinf/cuppen/personal_data/jvalleinclan/tools_kloosterman/primer3/emboss/.guix-profile'
PRIMER3_CORE='/hpc/cog_bioinf/cuppen/personal_data/jvalleinclan/tools_kloosterman/primer3/primer3/src/primer3_core'
MISPRIMING='/hpc/cog_bioinf/cuppen/personal_data/jvalleinclan/tools_kloosterman/primer3/repbase/current/empty.ref'
#MISPRIMING='/hpc/cog_bioinf/cuppen/personal_data/jvalleinclan/tools_kloosterman/primer3/repbase/current/humrep.ref'

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
    -h|--help)
    usage
    shift # past argument
    ;;
    -f|--fasta)
    FASTA="$2"
    shift # past argument
    shift # past value
    ;;
    -pdb|--bindir)
    BINDIR="$2"
    shift # past argument
    shift # past value
    ;;
    -pdpt|--pcr_type)
    PCR_TYPE="$2"
    shift # past argument
    shift # past value
    ;;
    -pdtp|--tilling_params)
    TILLING_PARAMS="$2"
    shift # past argument
    shift # past value
    ;;
    -psr|--psr)
    PSR="$2"
    shift # past argument
    shift # past value
    ;;
    -pdgp|--guix_profile)
    GUIX_PROFILE="$2"
    shift # past argument
    shift # past value
    ;;
    -pdpc|--primer3_core)
    PRIMER3_CORE="$2"
    shift # past argument
    shift # past value
    ;;
    -pdm|--mispriming)
    MISPRIMING="$2"
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
if [ -z $FASTA ]; then
    echo "Missing -f|--fasta parameter"
    usage
    exit
fi

echo `date`: Running on `uname -n`

# echo "$BINDIR/primerBATCH1 $MISPRIMING $PCR_TYPE $PSR $TILLING_PARAMS <$FASTA"

guixr load-profile $GUIX_PROFILE --<<EOF

export EMBOSS_PRIMER3_CORE=$PRIMER3_CORE
$BINDIR/primerBATCH1 $MISPRIMING $PCR_TYPE $PSR $TILLING_PARAMS <$FASTA
EOF

echo `date`: Done
