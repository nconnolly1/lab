# preserve escaped quotes
s?\\"?¬?g

# preserve quotes from "'str'"
s?"'?¦'?g
s?'"?'¦?g

# use / for pathnames
s?\\?/?g

# adjust quoting of JSON values
s? [¬"']\{0,1\}\(--extra-vars[ =]\)[¬"']\{0,1\}{\([^}]*\)}[¬"']\{0,1\}? \1'{\2}'?g
s? [¬"']\{0,1\}\(-e \)[¬"']\{0,1\}{\([^}]*\)}[¬"']\{0,1\}? \1'{\2}'?g

# adjust quoting of string values
s? -e "\([^"]*\)" ? -e '\1' ?g
s? -e \([^"' ][^ ]*\) ? -e '\1' ?g

# reinstate quotes within extra-vars
:l;s?\( -extra-vars[ =]'[^'¬]*\)¬?\1"?;tl
:l;s?\( -e '[^'¬]*\)¬?\1"?;tl

# quote special characters
s?\$?\\$?g

# escape remaining quotes
s?["¦]?\\"?g
s?¬?\\\\\\"?g
