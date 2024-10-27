#!/bin/bash

## Author : Werbhat
# Script to grep artefacts in the file 

# Couleurs
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
NC='\e[0m' # No Color

# Banner
echo -e "${YELLOW} - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ${NC}"
figlet -k WerbHat
echo ""
echo "Version 2.0"
echo ""
echo -e "${YELLOW} With this script, we can find artefact in the file."
echo -e "${YELLOW} For example, you can find IPv4 address, email, domain"
echo -e "${YELLOW} Command: ./grepartefact.sh file -ip4 -dom"
echo -e "${RED}   -help for display available options"
echo -e "${YELLOW} - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ${NC}"

# User guide
usage() {
    echo -e "${GREEN}Usage:${NC} $0 <file> <options...> [-o output_file]"
    echo -e "${BLUE}Available Options:${NC}"
    echo -e "  ${YELLOW}-ip4${NC}    IPv4 Addresses"
    echo -e "  ${YELLOW}-email${NC}  Email Addresses"
    echo -e "  ${YELLOW}-dom${NC}    Domain Names"
    echo -e "  ${YELLOW}-url${NC}    URLs"
    echo -e "  ${YELLOW}-mac${NC}    MAC Addresses"
    echo -e "  ${YELLOW}-phone${NC}  Phone Numbers"
    echo -e "  ${YELLOW}-dateUS${NC} Dates (ISO 8601)"
    echo -e "  ${YELLOW}-dateFR${NC} Dates (French)"
    echo -e "  ${YELLOW}-ip6${NC}    IPv6 Addresses"
    echo -e "  ${YELLOW}-www${NC}    URLs beginning with www"
    echo -e "  ${YELLOW}-all${NC}    All of the above"
    exit 1
}

if [ -z "$1" ]; then
    usage
fi

if [[ "$1" == "-help" ]]; then
    usage
fi

file=$1
shift
file_report=""
search_all=false
declare -A patterns=(
    ["-ip4"]="IPv4 Addresses:|([0-9]{1,3}\.){3}[0-9]{1,3}"
    ["-email"]="Email Addresses:|[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}"
    ["-dom"]="Domain Names:|([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}"
    ["-url"]="URLs:|https?://[a-zA-Z0-9./?=_-]+"
    ["-mac"]="MAC Addresses:|([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}"
    ["-phone"]="Phone Numbers:|\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}"
    ["-dateUS"]="Dates (ISO 8601):|\b\d{4}-\d{2}-\d{2}\b"
    ["-dateFR"]="Dates (French):|\b[0-3][0-9]/[0-1][0-9]/[0-9]{4}\b"
    ["-ip6"]="IPv6 Addresses:|([a-fA-F0-9]{1,4}:){7}[a-fA-F0-9]{1,4}"
    ["-www"]="URLs beginning with www:|www\.[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}"
)

# Check for -o option for output file
while (( "$#" )); do
    if [[ "$1" == "-o" ]]; then
        shift
        file_report=$1
        shift
    else
        break
    fi
done

if [ -n "$file_report" ]; then
    echo -e "${BLUE}Analysis report of file $file${NC}" > $file_report
    echo -e "${BLUE}Date:${NC} $(date)" >> $file_report
    echo "" >> $file_report
fi

while (( "$#" )); do
    if [[ "$1" == "-all" ]]; then
        search_all=true
    elif [[ -n "${patterns[$1]}" ]]; then
        if [ -n "$file_report" ]; then
            echo -e "${YELLOW}${patterns[$1]%%|*}${NC}" >> $file_report
            grep -Eo "${patterns[$1]#*|}" $file >> $file_report
            echo "" >> $file_report
        else
            echo -e "${YELLOW}${patterns[$1]%%|*}${NC}"
            grep -Eo "${patterns[$1]#*|}" $file
            echo ""
        fi
    else
        echo -e "${RED}Invalid option: $1${NC}" >&2
        usage
    fi
    shift
done

if $search_all; then
    for key in "${!patterns[@]}"; do
        if [ -n "$file_report" ]; then
            echo -e "${YELLOW}${patterns[$key]%%|*}${NC}" >> $file_report
            grep -Eo "${patterns[$key]#*|}" $file >> $file_report
            echo "" >> $file_report
        else
            echo -e "${YELLOW}${patterns[$key]%%|*}${NC}"
            grep -Eo "${patterns[$key]#*|}" $file
            echo ""
        fi
    done
fi

if [ -n "$file_report" ]; then
    cat $file_report
fi

