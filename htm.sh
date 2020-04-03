#!/bin/bash

# sudo cp htm.sh /usr/local/bin/htm
# sudo chmod a+x /usr/local/bin/htm

echo "== Generarte HTML blocks for ruu.lv  ==
Example
htm 20190820-Kurzeme-Klaipeda-0002-Pavilosta-by-Janis-Rullis Pavilosta 2019:08:20
";

if [[ ! -n $1 ]]; then
        echo "Filename?";
        exit;
fi
if [[ ! -n $2 ]]; then
        echo "Description?";
        exit;
fi
if [[ ! -n $3 ]]; then
        echo "Date?";
        exit;
fi

# #2 https://clubmate.fi/replace-strings-in-files-with-the-sed-bash-command/#Replace_an_array_of_values
# Associative array where key represents a search string,
# and the value itself represents the replace string.
declare -A confs
DATE=$3;
DATE_SHORT=${DATE//:/};
DESCRIPTION=$2
DATE_W_DOTS=`tr ':' '.' <<< ${DATE}`.;

confs=(
  [DATE_W_HYPENS]=`tr ':' '-' <<< ${DATE}`
  [DATE_W_DOTS]=$DATE_W_DOTS
  [DATE_SHORT]=$DATE_SHORT
  [DATE]=$3
  [HTML_FILENAME]="${DATE_SHORT}-${DESCRIPTION}.html"
  [HTML_SHORT_TITLE]="${DATE_W_DOTS} ${DESCRIPTION}"
  [HTML_TITLE]="Analog Photography | ${DATE_W_DOTS} ${DESCRIPTION} | ruu.lv"  
  [FILENAME]=$1
  [DESCRIPTION]=$DESCRIPTION 
)

setVariables(){
  if [[ ! -n $1 ]]; then
        echo "Filename?";
        exit;
  fi
  target=$1

  for i in "${!confs[@]}"
  do
      search=$i
      replace=${confs[$i]}
      sed -i -e "s/${search}/${replace}/g" $target;
  done
}

# #2 tpl.html can be found in https://github.com/ruu-lv/content_gen

# #2 Append the image template block to the target HTML.
cat /usr/local/bin/img.tpl.html >> img.html
setVariables img.html

# #2 Create the HTML page only once (for the first image).
if [[ ! -r ${confs[HTML_FILENAME]} ]]; then
  cat /usr/local/bin/news.tpl.html > ${confs[HTML_FILENAME]};
  setVariables ${confs[HTML_FILENAME]};
  echo ${confs[HTML_FILENAME]};
fi
