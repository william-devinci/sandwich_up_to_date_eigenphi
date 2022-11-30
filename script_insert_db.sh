#!/bin/bash

outfile="reception.txt"
url="https://eigenphi.io/api/v1/dataservice/sandwich/latestSandwichTxs/?chain=ethereum&pageNum=0&pageSize=10&period=7"

function get_webpage(){
        curl -s  $url > $outfile
}

function get_values(){
        blockNumber="$(grep -oP '(?<="blockNumber":)(\d+)' $outfile | head -1)"
        profit="$(grep -oP '(?<="profit":)(\d+).(\d+)' $outfile | head -1)"
        date=$(date '+%Y-%m-%d')
        symbols="$(grep -oP '(?<="symbol":\")(\w+)' $outfile | head -1)-$(grep -oP '(?<="symbol":\")(\w+)' $outfile | head -2 | tail -1)" 
        address_1="$(grep -oP '(?<="address":\")(\w+)' $outfile | head -1)"
        address_2="$(grep -oP '(?<="address":\")(\w+)' $outfile | head -2 | tail -1)"
        text="${blockNumber}  -  ${profit}    -   ${date}     -    ${symbols}  -     ${address_1}    -    ${address_2}"
        echo "${text}"
}
function send(){
        #chat_id="CHAT_ID"
        #url_telegram="https://api.telegram.org/botKEY/sendMessage?parse_mode=HTML"
        #curl --data chat_id=$chat_id --data-urlencode "text=${text}" $url_telegram

        sqlite3 ./arch.db "insert into  eigen_sandwich (blockNumber, profit, date, symbols, address_1, address_2) values ('$blockNumber','$profit','$date','$symbols','$address_1','$address_2');"
}

get_webpage
get_values
send