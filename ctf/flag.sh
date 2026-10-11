#!/bin/sh
# Places the player's flag (CTF_FLAG_MAIN, given by the launcher) in the table flags of the
# SqlInjLesson schema, readable by the SQL injection lesson's database user;
# without one (CI, a run by hand) the development flag.
dev='FLAG{dev-security-shepherd}'
flag=$(printf '%s' "${CTF_FLAG_MAIN:-$dev}" | sed "s/'/''/g")
until mysql -h 127.0.0.1 -uroot -pCowSaysMoo -e 'select 1' SqlInjLesson >/dev/null 2>&1; do sleep 2; done
mysql -h 127.0.0.1 -uroot -pCowSaysMoo SqlInjLesson -e "CREATE TABLE IF NOT EXISTS flags (flag varchar(255) NOT NULL); DELETE FROM flags; INSERT INTO flags (flag) VALUES ('$flag'); GRANT SELECT ON SqlInjLesson.flags TO 'firstBloodyMessL'@'%';"
