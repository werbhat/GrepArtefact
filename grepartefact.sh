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
echo "Version 2.1"
echo ""
echo -e "${YELLOW} With this script, we can find artefact in the file."
echo -e "${YELLOW} For example, you can find IPv4 address, email, domain"
echo -e "${YELLOW} Command: ./grepartefact.sh -f file -ip4 -dom -o output_report.txt"
echo -e "${BLUE}   -help for display available options"
echo -e "${YELLOW} - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ${NC}"

# User guide
usage() {
    echo -e "${GREEN}Usage:${NC} $0 -f <file> <options...> [-o output_file]"
    echo -e "${BLUE}Available Options:${NC}"
    echo -e "  ${YELLOW}-all${NC}    All of the above"
    echo -e "  ${YELLOW}-ip4${NC}    IPv4 Addresses"
    echo -e "  ${YELLOW}-ip6${NC}    IPv6 Addresses"
    echo -e "  ${YELLOW}-email${NC}  Email Addresses"
    echo -e "  ${YELLOW}-dom${NC}    Domain Names"
    echo -e "  ${YELLOW}-url${NC}    URLs"
    echo -e "  ${YELLOW}-mac${NC}    MAC Addresses"
    echo -e "  ${YELLOW}-phone${NC}  Phone Numbers"
    echo -e "  ${YELLOW}-dateUS${NC} Dates (ISO 8601)"
    echo -e "  ${YELLOW}-dateFR${NC} Dates (French)"
    echo -e "  ${YELLOW}-www${NC}    URLs beginning with www"
    exit 1
}

file=""
file_report=""
search_all=false

if [ -z "$1" ]; then
    usage
fi

while (( "$#" )); do
    case "$1" in
        -help)
            usage
            ;;
        -f)
            shift
            file=$1
            ;;
        -o)
            shift
            file_report=$1
            ;;
        -all)
            search_all=true
            ;;
        -ip4|-email|-dom|-url|-mac|-phone|-dateUS|-dateFR|-ip6|-www)
            options+=("$1")
            ;;
        *)
            echo -e "${RED}Invalid option: $1${NC}" >&2
            usage
            ;;
    esac
    shift
done

if [ -z "$file" ]; then
    echo -e "${RED}Error: Input file not specified. Use -f to specify the file.${NC}" >&2
    usage
fi

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

if [ -n "$file_report" ]; then
    echo -e "${BLUE}Analysis report of file $file${NC}" > $file_report
    echo -e "${BLUE}Date:${NC} $(date)" >> $file_report
    echo "" >> $file_report
fi

if $search_all; then
    options=("-ip4" "-email" "-dom" "-url" "-mac" "-phone" "-dateUS" "-dateFR" "-ip6" "-www")
fi

for opt in "${options[@]}"; do
    if [ -n "$file_report" ]; then
        echo -e "${YELLOW}${patterns[$opt]%%|*}${NC}" >> $file_report
        grep -Eo "${patterns[$opt]#*|}" $file >> $file_report
        echo "" >> $file_report
    else
        echo -e "${YELLOW}${patterns[$opt]%%|*}${NC}"
        grep -Eo "${patterns[$opt]#*|}" $file
        echo ""
    fi
done

if [ -n "$file_report" ]; then
    cat $file_report
fi
