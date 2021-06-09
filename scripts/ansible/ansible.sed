# add spaces at head and tail
s?^? ?
s?$? ?

# preserve escaped quotes
s?\\"?¬?g

# preserve quotes from "'str'"
s?"'?¦'?g
s?'"?'¦?g

# preserve single quotes
s?'?\f?g

# use / for pathnames
s?\\?/?g

# adjust quoting of JSON values
s? [¬"']\{0,1\}\(--extra-vars[ =]\)[¬\f"']\{0,1\}\({[^}]*}\)[¬\f"']\{0,1\} ? \1'\2' ?g
s? [¬"']\{0,1\}\(-e[ =]\)[¬\f"']\{0,1\}\({[^}]*}\)[¬\f"']\{0,1\} ? \1'\2' ?g

# adjust quoting of string values
s?\( --extra-vars[ =]\)"\([^"]*\)" ?\1'\2' ?g
s?\( --extra-vars[ =]\)\([^"' ][^ ]*\) ?\1'\2' ?g
s?\( -e[ =]\)"\([^"]*\)" ?\1'\2' ?g
s?\( -e[ =]\)\([^"' =][^ ]*\) ?\1'\2' ?g

# reinstate quotes within variables
:a
s?\( --extra-vars[ =]'[^'¬]*\)¬?\1"?;ta
s?\( -e[ =]'[^'¬]*\)¬?\1"?;ta

# escape single quotes in variables
:b
s?\( --extra-vars[ =]'[^'\f]*\)\f?\1\v?;tb
s?\( -e[ =]'[^'\f]*\)\f?\1\v?;tb
s?\v?'¦'¦'?g

# quote special characters
s?\$?\\$?g

# reinstate single quotes
s?\f?'?g

# escape remaining quotes
s?["¦]?\\"?g
s?¬?\\\\\\"?g

# remove spaces at head and tail
s?^ *??
s? *$??