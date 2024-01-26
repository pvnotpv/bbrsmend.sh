#!/bin/fish
touch bbrhash.txt

while true;
  set wdtNonce (curl -s https://bbradar.io/ | grep -o 'id="wdtNonceFrontendEdit_1" name="wdtNonceFrontendEdit_1" value="[^"]*"' | cut -d ' ' -f3 | sed 's/value="\([^"]*\)"/\1/'); 

  set out (curl -s 'https://bbradar.io/wp-admin/admin-ajax.php?action=get_wdtable&table_id=1' -H 'authority: bbradar.io' -H 'accept: application/json, text/javascript, */*; q=0.01' -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'origin: https://bbradar.io' -H 'referer: https://bbradar.io/' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36' -H 'x-requested-with: XMLHttpRequest' --data-raw "draw=2&columns[0][data]=0&columns[0][name]=handle&columns[0][searchable]=true&columns[0][orderable]=true&columns[0][search][value]=&columns[0][search][regex]=false&columns[1][data]=1&columns[1][name]=date_launched&columns[1][searchable]=true&columns[1][orderable]=true&columns[1][search][value]=&columns[1][search][regex]=false&columns[2][data]=2&columns[2][name]=profile_picture&columns[2][searchable]=true&columns[2][orderable]=true&columns[2][search][value]=&columns[2][search][regex]=false&columns[3][data]=3&columns[3][name]=name&columns[3][searchable]=true&columns[3][orderable]=true&columns[3][search][value]=&columns[3][search][regex]=false&columns[4][data]=4&columns[4][name]=platform&columns[4][searchable]=true&columns[4][orderable]=true&columns[4][search][value]=&columns[4][search][regex]=false&columns[5][data]=5&columns[5][name]=link&columns[5][searchable]=true&columns[5][orderable]=true&columns[5][search][value]=&columns[5][search][regex]=false&order[0][column]=1&order[0][dir]=desc&start=0&length=5&search[value]=&search[regex]=false&wdtNonce=$wdtNonce" --compressed)

  set final "$(echo $out | jq  '.data' | jq -r '.[] | "\(.[3]) - \(.[1]) - \(.[5] | scan("<a href=\'(.*?)\'")[0])" + "\n"')"
  set hash (echo $out | md5sum)
  set oldhash (cat bbrhash.txt)
 
  if test "$hash" = "$oldhash"
  else
    curl -d 'New Program Released!' ntfy.sh/$argv[2]
    curl -d $final ntfy.sh/$argv[2]
    rm bbrhash.txt
    echo $out | md5sum >> bbrhash.txt
  end

  sleep $argv[1]
;end 
