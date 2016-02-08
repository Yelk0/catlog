#!/bin/bash
​
printf "\nProcessing...\n"
​
nerrors=0
​
while IFS='' read -r line || [[ -n "$line" ]]; do
    
    if [[ $line == *"*INFO*"* ]]
    then
        error=false
    fi
    
    if [[ $line == *"*WARN*"* ]]
    then
        error=false
    fi
    
    if [[ $line == *"*ERROR*"* ]]
    then
        rep=0
        new=${log[$nerrors]};
        for error in "${log[@]}"
        do
            if [[ "$error" == "$new" ]];
            then
                let "rep++"
            fi
        done
        
        if [ "$rep" -gt 1 ]
        then
            nerrors=$nerrors-1
        fi
        
        let "nerrors++"
        log[$nerrors]=${line##*\*ERROR\*}
        error=true
    else
        if [[ $error == "true" ]]
        then
            log[$nerrors]=${log[$nerrors]}$line;
        fi
    fi
done < "$1"
​
rm -rf ./grouped-errors.log
​
printf "\n\n\n\n\n\n" >> grouped-errors.log
​
for error in "${log[@]}"
do
    echo "$error" | tr '\t' '\n' >> grouped-errors.log
    printf "\n\n" >> grouped-errors.log
done
​
printf "\n$nerrors errors saved into ./groupederrors.log\n\n"
