# _____.___.              __       ___.            ________                      .__                    .___
# \__  |   | ____  __ ___/  |_ __ _\_ |__   ____   \______ \   ______  _  ______ |  |   _________     __| _/___________
#  /   |   |/  _ \|  |  \   __\  |  \ __ \_/ __ \   |    |  \ /  _ \ \/ \/ /    \|  |  /  _ \__  \   / __ |/ __ \_  __ \
#  \____   (  <_> )  |  /|  | |  |  / \_\ \  ___/   |    `   (  <_> )     /   |  \  |_(  <_> ) __ \_/ /_/ \  ___/|  | \/
#  / ______|\____/|____/ |__| |____/|___  /\___  > /_______  /\____/ \/\_/|___|  /____/\____(____  /\____ |\___  >__|
#  \/                                   \/     \/          \/                  \/                \/      \/    \/

# Coded by Anas Fanani
# 20 September 2019
# Hire me : anasfanani1337@gmail.com
base64 -d <<<"CgpfX19fXy5fX18uICAgICAgICAgICAgICBfXyAgICAgICBfX18uICAgICAgICAgICAgX19fX19fX18gICAgICAgICAgICAgICAgICAgICAgLl9fICAgICAgICAgICAgICAgICAgICAuX19fICAgICAgICAgICAgClxfXyAgfCAgIHwgX19fXyAgX18gX19fLyAgfF8gX18gX1xfIHxfXyAgIF9fX18gICBcX19fX19fIFwgICBfX19fX18gIF8gIF9fX19fXyB8ICB8ICAgX19fX19fX19fICAgICBfX3wgXy9fX19fX19fX19fXyAKIC8gICB8ICAgfC8gIF8gXHwgIHwgIFwgICBfX1wgIHwgIFwgX18gXF8vIF9fIFwgICB8ICAgIHwgIFwgLyAgXyBcIFwvIFwvIC8gICAgXHwgIHwgIC8gIF8gXF9fICBcICAgLyBfXyB8LyBfXyBcXyAgX18gXAogXF9fX18gICAoICA8Xz4gKSAgfCAgL3wgIHwgfCAgfCAgLyBcX1wgXCAgX19fLyAgIHwgICAgYCAgICggIDxfPiApICAgICAvICAgfCAgXCAgfF8oICA8Xz4gKSBfXyBcXy8gL18vIFwgIF9fXy98ICB8IFwvCiAvIF9fX19fX3xcX19fXy98X19fXy8gfF9ffCB8X19fXy98X19fICAvXF9fXyAgPiAvX19fX19fXyAgL1xfX19fLyBcL1xfL3xfX198ICAvX19fXy9cX19fXyhfX19fICAvXF9fX18gfFxfX18gID5fX3wgICAKIFwvICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcLyAgICAgXC8gICAgICAgICAgXC8gICAgICAgICAgICAgICAgICBcLyAgICAgICAgICAgICAgICBcLyAgICAgIFwvICAgIFwvICAgICAgIAoKQ29kZWQgYnkgQW5hcyBGYW5hbmkKMjAgU2VwdGVtYmVyIDIwMTkKSGlyZSBtZSA6IGFuYXNmYW5hbmkxMzM3QGdtYWlsLmNvbQo="
echo "=======================================================================================================================";
if [ -z "$1" ];then
    echo "Usage : bash $0 [list url youtube]";
    echo "Ex    : bash $0 list.txt";
    exit;
fi
progressfilt ()
{
    local flag=false c count cr=$'\r' nl=$'\n'
    while IFS='' read -d '' -rn 1 c
    do
        if $flag
        then
            printf '%s' "$c"
        else
            if [[ $c != $cr && $c != $nl ]]
            then
                count=0
            else
                ((count++))
                if ((count > 1))
                then
                    flag=true
                fi
            fi
        fi
    done
}
while read url; do
    cok=$(curl "https://youtubemp4.to/download_ajax/" --silent -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:69.0) Gecko/20100101 Firefox/69.0" -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Accept-Language: en-US,en;q=0.5" --compressed -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "X-Requested-With: XMLHttpRequest" -H "Connection: keep-alive" -H "Referer: https://youtubemp4.to/" --data "url=$url");
    cok=$(echo $cok|jq .result);
    cok=$(sed 's/^.*<a class=\\\"btn btn-red\\\" rel=\\\"nofollow noreferrer\\\" href=\\\"//;s/\\\">Best download.*$//' <<< $cok);
    nama=$(echo $cok|sed 's/^.*title=//;'|sed "s@+@ @g;s@%@\\\\x@g" | xargs -0 printf "%b");
    echo $cok>>"youtube_download.txt"
    echo "Done -> $url"
    echo "Downloading -> $nama";
    wget --progress=bar:force "$cok" -O "$nama.mp4" 2>&1 | progressfilt
    echo "=======================================================================================================================";
done < $1
