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

# quote special characters
s?"?\\"?g
s?\([${}]\)?\\\\\\\1?g

# reinstate quotes
s?¬?\\\\\\"?g
s?¦?\\"?g
