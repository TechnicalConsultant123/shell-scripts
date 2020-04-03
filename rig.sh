#!/bin/bash

# sudo apt install cwebp
# sudo cp rig.sh /usr/local/bin/rig
# sudo chmod a+x /usr/local/bin/rig

echo "== Resize an image into defined sizes for a responsive page ==
Example
1) rig - generates a list of sizes.
2) rig 1920 - only 1 size.
4) rig '' 'Birds' '2020-03-03' - also generate HTML and placeholders.
";

HTML_IMG_DESCRIPTION="";
HTML_IMG_DATE="2020-03-03";
target_dir="responsive";
sizes=(3840 3200 2732 2048 1920 1600 1536 1366 1024 900 768 450);

if [[ -n $1 ]]; then
        readonly target_dir="$1x";
        readonly sizes=($1);
fi
if [[ -n $2 ]]; then
        HTML_IMG_DESCRIPTION=$2;
fi
if [[ -n $3 ]]; then
        HTML_IMG_DATE=$3;
fi

# #2 Genereate various size images and prepare HTML.
rig $SIZES $WITH_PLACEHOLDER DESCRIPTION;

if [[ ! -d $target_dir ]]; then
        mkdir $target_dir;
        echo "Created $target_dir"
fi

for f in `find ./  -maxdepth 1 -type f \( -iname \*.jpg -o -iname \*.png -o -iname \*.tif \)`
do
        # Trim the ./ part .
        f=${f:2};
        filename=$(basename $f);
        target_prefix=${target_dir}/${filename%.*};

        # #2 Generate a placeholder image and HTML.
        if [[ $HTML_IMG_DESCRIPTION != "" ]]; then

            # #2 Generate a JPG placeholder.
            convert "$f" -resize 700x -strip -blur 0x8 -quality 20 "${target_prefix}-700x-placeholder.jpg";
            convert "${target_prefix}-700x-placeholder.jpg" -grayscale Rec709Luminance "${target_prefix}-700x-gray-placeholder.jpg";
            
            # #2 Generate a WEMP placeholder.
            cwebp -q 40 "${target_prefix}-700x-placeholder.jpg" -noalpha -mt -o "${target_prefix}-700x-placeholder.webp";
            cwebp -q 40 "${target_prefix}-700x-gray-placeholder.jpg" -noalpha -mt -o "${target_prefix}-700x-gray-placeholder.webp";

            # #2 Generate img.html and json.html.
            htm ${filename%.*} "${HTML_IMG_DESCRIPTION}" "${HTML_IMG_DATE}";
        fi

        # Loop through sizes.
        for index in ${!sizes[*]}
        do
            size=${sizes[$index]};
            target="${target_prefix}-${size}x";
            dir=$(dirname $f);

            # Convert to *.jpg.
            convert "$f" -resize ${size} -gaussian-blur 0.05 -quality 85%  "${target}.jpg";

            # Convert to *.webp.
            cwebp -q 85 "${f}"  -resize ${size} 0 -mt  -metadata all -o "${target}.webp"
            echo $target;
        done
done
