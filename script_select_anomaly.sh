#!/bin/bash
treeshold=$(cat threeshold.txt)
mean=$(sqlite3 ./arch.db "SELECT AVG(profit) from eigen_sandwich;")
sqrt_n=$(sqlite3 ./arch.db "SELECT sqrt(COUNT(*)) from eigen_sandwich;")
s=$(sqlite3 ./arch.db "SELECT sqrt(SUM((profit -(SELECT AVG(profit) FROM eigen_sandwich))*(profit -(SELECT AVG(profit) FROM eigen_sandwich)) ) / COUNT(*) ) FROM eigen_sandwich;")
under=$(echo "$mean - $treeshold * ( $s / $sqrt_n )" | bc)
test=$(echo "$treeshold * ( $s / $sqrt_n )" | bc)
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
echo "------------- $test ---------------"
echo -e $text_over


sudo cat > ~/os/project_2/main/index.html <<EOF
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="UTF-8">
    <title>Project OS</title>
  </head>
  <body>
    <main>
      <h1>Sandwich via EigenPhi</h1>
    </main>
    <h3>Change coefficient  :</h3>
    <form action="~/os/project_2/main/set_threeshold.sh" method="post">
        <input type="submit" value="Send">
    </form>
    <h3>
        Parameters
    </h3>
    <p>[$under ; $over]</p>
    <p>Coeff : $treeshold </p>
    <p>Mean : $mean </p>
 

  <h2>Anomalie history  under: </h2>
  <table>
  <tr>
    <th>Block Number</th>
    <th>Profit in $</th>
    <th>Date</th>
    <th>symbols</th>
    <th>adress 1</th>
    <th>adress 2</th>
  </tr>
  
EOF

for values in $data_under
do
  blockNumber="$(echo ${values} | cut -d'|' -f1)"
  profit="$(echo ${values} | cut -d'|' -f2)"
  date="$(echo ${values} | cut -d'|' -f3)"
  symbols="$(echo ${values} | cut -d'|' -f4)"
  adress_1="$(echo ${values} | cut -d'|' -f5)"
  adress_2="$(echo ${values} | cut -d'|' -f6)"

  sudo cat >> ~/os/project_2/main/index.html <<EOF
  <tr>
    <td>$blockNumber</td>
    <td>$profit</td>
    <td>$date</td>
    <td>$symbols</td>
    <td>$adress_1</td>
    <td>$adress_2</td>
  </tr>
EOF
done

sudo cat >> ~/os/project_2/main/index.html <<EOF
</table>

  <h2>Anomalie history over : </h2>
  <table>
  <tr>
    <th>Block Number</th>
    <th>Profit in $</th>
    <th>Date</th>
    <th>symbols</th>
    <th>adress 1</th>
    <th>adress 2</th>
  </tr>
  
EOF

for values in $data_over
do
  blockNumber="$(echo ${values} | cut -d'|' -f1)"
  profit="$(echo ${values} | cut -d'|' -f2)"
  date="$(echo ${values} | cut -d'|' -f3)"
  symbols="$(echo ${values} | cut -d'|' -f4)"
  adress_1="$(echo ${values} | cut -d'|' -f5)"
  adress_2="$(echo ${values} | cut -d'|' -f6)"

  sudo cat >> ~/os/project_2/main/index.html <<EOF
  <tr>
    <td>$blockNumber</td>
    <td>$profit</td>
    <td>$date</td>
    <td>$symbols</td>
    <td>$adress_1</td>
    <td>$adress_2</td>
  </tr>
EOF
done

sudo cat >> ~/os/project_2/main/index.html <<EOF
</table>
   </body>
</html>
EOF