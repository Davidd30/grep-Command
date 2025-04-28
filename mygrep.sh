#!/bin/bash

show_line_numbers=0
invert_match=0
pattern=""
filename=""

helpp() {
  echo "Usage of $0 : "
  echo "Search for Pattern in file"
  echo ""
  echo "Options:"
  echo " -n Show line numbers for each match"
  echo " -v Invert the match"
  exit 0
}


for arg in "$@"; do
  if [ "$arg" = "--help" ]; then
    helpp
  fi
done


while getopts ":nv" opt; do
    case $opt in
        n)
            show_line_numbers=1
            ;;
        v)
            invert_match=1
            ;;
    esac
done


shift $((OPTIND-1))

if [ $# -lt 2 ]; then
    echo "Error: Missing required arguments" >&2
fi

pattern="$1"
filename="$2"


if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' not found" >&2
    exit 1
fi


line_number=0
while IFS= read -r line; do
    ((line_number++))

    # -i    
    if echo "$line" | grep -qi "$pattern"; then
        match=1
    else
        match=0
    fi
    
    # -nv -vn
    if [ $invert_match -eq 1 ]; then
        match=$((1-match))
    fi
    
    if [ $match -eq 1 ]; then
        if [ $show_line_numbers -eq 1 ]; then
            echo "$line_number:$line"
        else
            echo "$line"
        fi
    fi
done < "$filename"
