#!/bin/bash
#
# author : werbhat
# script to grep artefact in the file 
#

# Couleurs
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
NC='\e[0m '

# create your banner with package figlet: www.figlet.com
echo -e "${YELLOW} - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ${NC}"
figlet -k WerbHat
echo ""
echo "version 1.0"
echo ""
echo -e "${YELLOW} With this script, we can find artefact in the file."
echo -e "${YELLOW} For exemple, you can find ipv4_address, email, domain"
echo -e "${YELLOW} cmd : ./grepartefact.sh file -ip4 -dom"
echo -e "${RED}   -help for display available options"
echo -e "${YELLOW} - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ${NC}"
#################################################################


# user guide
usage() {
    echo -e "${GREEN}Usage:${NC} $0 <file> <options...>"
    echo "Available Options :"
    echo "  -ip4    IPv4 Address"
    echo "  -email  Emails Address"
    echo "  -dom    Domains names"
    echo "  -url    URLs"
    echo "  -mac    MAC Address"
    echo "  -tel    Tel Numbers"
    echo "  -dateUS   Dates (ISO 8601)"
    echo "  -ip6    IPv6 Address"
    echo "  -www    URLs begin by www"
    echo "  -cc     Credit card numbers"
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
file_report="grep_report_$(date +'%Y%m%d_%H%M%S').txt"

echo -e "${BLUE}Analyse report of file $fichier${NC}" > $file_report
echo -e "${BLUE}Date:${NC} $(date)" >> $file_report
echo "" >> $file_report


while (( "$#" )); do
    case "$1" in
        -ip4)
            echo -e "${YELLOW}IPv4 Address :${NC}" >> $file_report
            grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' $file >> $file_report
            echo "" >> $file_report
            ;;
        -email)
            echo -e "${YELLOW}Emails Address :${NC}" >> $file_report
            grep -Eo '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}' $file >> $file_report
            echo "" >> $file_report
            ;;
        -dom)
            echo -e "${YELLOW}Domains Names :${NC}" >> $file_report
            grep -Eo '([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}' $file >> $file_report
            echo "" >> $file_report
            ;;
        -url)
            echo -e "${YELLOW}URLs :${NC}" >> $file_report
            grep -Eo 'https?://[a-zA-Z0-9./?=_-]+' $file >> $file_report
            echo "" >> $file_report
            ;;
        -mac)
            echo -e "${YELLOW}MAC Address :${NC}" >> $file_report
            grep -Eo '([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}' $file >> $file_report
            echo "" >> $file_report
            ;;
        -tel)
            echo -e "${YELLOW}Tel Numbers :${NC}" >> $file_report
            grep -Eo '\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}' $file >> $file_report
            echo "" >> $file_report
            ;;
        -date)
            echo -e "${YELLOW}Dates (ISO 8601) :${NC}" >> $file_report
            grep -Eo '\b\d{4}-\d{2}-\d{2}\b' $file >> $file_report
            echo "" >> $file_report
            ;;
        -ip6)
            echo -e "${YELLOW}IPv6 Address :${NC}" >> $file_report
            grep -Eo '([a-fA-F0-9]{1,4}:){7}[a-fA-F0-9]{1,4}' $file >> $file_report
            echo "" >> $file_report
            ;;
        -www)
            echo -e "${YELLOW}URLs begin by www :${NC}" >> $file_report
            grep -Eo 'www\.[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}' $file >> $file_report
            echo "" >> $file_report
            ;;
        -cc)
            echo -e "${YELLOW}Credit card numbers :${NC}" >> $file_report
            grep -Eo '\b4[0-9]{12}(?:[0-9]{3})?\b|\b5[1-5][0-9]{14}\b' $file >> $file_report
            echo "" >> $file_report
            ;;
        *)
            echo -e "${RED}Available Options :$1${NC}" >> $file_report
            echo "Available Options : -ip4, -email, -dom, -url, -mac, -tel, -date, -ip6, -www, -cc" >> $file_report
            ;;
    esac
    shift
done


cat $file_report
