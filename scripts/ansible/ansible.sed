# add space at head and tail
s?^\(.*\)$? \1 ?

# rename -e to --Extra-vars
s?\( ["']\{0,1\}\)-e\([ =]\)?\1--Extra-vars\2?g

# preserve quotes
s?\\"?¬?g
s?'?¦?g

# use / for pathnames
s?\\?/?g

# adjust quoting of JSON values
s? [¬¦"]\{0,1\}\(--[Ee]xtra-vars[ =]\)[¬¦"]\{0,1\}\({[^}]*}\)[¬¦"]\{0,1\} ? \1'\2' ?g

# adjust quoting of string values
s?\( --[Ee]xtra-vars[ =]\)"\([^"]*\)" ?\1'\2' ?g
s?\( --[Ee]xtra-vars[ =]\)\([^"'= ][^ ]*\) ?\1'\2' ?g

# reinstate quotes within variables
:a
s?\( --[Ee]xtra-vars[ =]'[^'¬]*\)¬?\1"?;ta
s?\( --[Ee]xtra-vars[ =]'[^'¦]*\)¦?\1\v?;ta
s?\v?'"'"'?g

# quote special characters
s?\([\$"]\)?\\\1?g

# reinstate quotes
s?¦?'?g
s?¬?\\\\\\"?g

# reinstate -e argument
s? --Extra-vars? -e?g

# remove spaces at head and tail
s?^ \(.*\) $?\1?
