# add spaces at head and tail
s?^? ?
s?$? ?

# preserve escaped quotes
s?\\"?¬?g

# preserve quotes from "'str'"
s?"'?¦'?g
s?'"?'¦?g

# use / for pathnames
s?\\?/?g

# escape ' in JSON values
:a;s?\( [¬"]\{0,1\}--extra-vars[ =][¬"]\{0,1\}{[^'}]*\)'\([^}]*}[¬"]\{0,1\} \)?\1\v\2?g;ta
:b;s?\( [¬"]\{0,1\}-e [¬"]\{0,1\}{[^'}]*\)'\([^}]*}[¬"]\{0,1\} \)?\1\v\2?g;tb

# adjust quoting of JSON values
s? [¬"']\{0,1\}\(--extra-vars[ =]\)[¬"']\{0,1\}\({[^}]*}\)[¬"']\{0,1\} ? \1'\2' ?g
s? [¬"']\{0,1\}\(-e \)[¬"']\{0,1\}\({[^}]*}\)[¬"']\{0,1\} ? \1'\2' ?g

# escape ' in string values
:c;s?\( --extra-vars[ =]"[^"']*\)'\([^"]*" \)?\1\v\2?g;tc
:d;s?\( --extra-vars[ =][^"' ][^ ']*\)'\([^ ]* \)?\1\v\2?g;td
:e;s?\( -e "[^"']*\)'\([^"]*" \)?\1\v\2?g;te
:f;s?\( -e [^"' ][^ ']*\)'\([^ ]* \)?\1\v\2?g;tf

# adjust quoting of string values
s?\( --extra-vars[ =]\)"\([^"]*\)" ?\1'\2' ?g
s?\( --extra-vars[ =]\)\([^"' ][^ ]*\) ?\1'\2' ?g
s?\( -e \)"\([^"]*\)" ?\1'\2' ?g
s?\( -e \)\([^"' ][^ ]*\) ?\1'\2' ?g

# reinstate quotes within variables
:g;s?\( --extra-vars[ =]'[^'¬]*\)¬?\1"?;tg
:h;s?\( -e '[^'¬]*\)¬?\1"?;th

# quote special characters
s?\$?\\$?g

# escape remaining quotes
s?\v?'¦'¦'?g
s?["¦]?\\"?g
s?¬?\\\\\\"?g

# remove spaces at head and tail
s?^ *??
s? *$??
