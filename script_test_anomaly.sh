#!/bin/bash
treeshold=$(cat threeshold.txt)
mean=$(sqlite3 ./arch.db "SELECT AVG(profit) from eigen_sandwich;")
sqrt_n=$(sqlite3 ./arch.db "SELECT sqrt(COUNT(*)) from eigen_sandwich;")
s=$(sqlite3 ./arch.db "SELECT sqrt(SUM((profit -(SELECT AVG(profit) FROM eigen_sandwich))*(profit -(SELECT AVG(profit) FROM eigen_sandwich)) ) / COUNT(*) ) FROM eigen_sandwich;")
under=$(echo "$mean - $treeshold * ( $s / $sqrt_n )" | bc)
over=$(echo "$mean + $treeshold * ( $s / $sqrt_n )" | bc)

echo "treeshold: "$treeshold
echo "mean : "$mean
echo "sqrt_n : "$sqrt_n
echo "s: "$s
echo "[ 25% : "$under"; 75% : "$over"]"


data_under=$(sqlite3 ./arch.db "SELECT blockNumber, profit, date, symbols, address_1, address_2  FROM eigen_sandwich WHERE profit < $under ORDER BY profit DESC;")
data_over=$(sqlite3 ./arch.db "SELECT blockNumber, profit, date, symbols, address_1, address_2  FROM eigen_sandwich WHERE profit > $over ORDER BY profit ASC;")


text_under=""
for data in $data_under
do
  text_under+="$data \n"
done 

text_over=""
for data in $data_over
do
        text_over+="$data \n"
done

echo -e $text_under 
echo "-------------------------------------"
echo -e $text_over