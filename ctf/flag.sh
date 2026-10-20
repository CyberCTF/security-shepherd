#!/bin/sh
# >>> isoloom-1.0 secret-from-file shim (auto-added by convert-lab.py) >>>
# Inputs now arrive as files (isoloom.yml `files:`), not environment variables.
# Read each into its old variable when unset, keeping the dev/CI fallback working.
for __p in CTF_FLAG_MAIN:/run/lab/ctf_flag_main; do
  __n=${__p%%:*}; __f=${__p#*:}
  eval "__v=\${$__n:-}"
  if [ -z "$__v" ] && [ -s "$__f" ]; then
    __v=$(tr -d '\r\n' < "$__f"); eval "export $__n=\"\$__v\""
  fi
done
unset __p __n __f __v 2>/dev/null || true
# <<< isoloom-1.0 secret-from-file shim <<<
# Places the player's flag (CTF_FLAG_MAIN, given by the launcher) in the table flags of the
# SqlInjLesson schema, readable by the SQL injection lesson's database user;
# without one (CI, a run by hand) the development flag.
dev='FLAG{dev-security-shepherd}'
flag=$(printf '%s' "${CTF_FLAG_MAIN:-$dev}" | sed "s/'/''/g")
until mysql -h 127.0.0.1 -uroot -pCowSaysMoo -e 'select 1' SqlInjLesson >/dev/null 2>&1; do sleep 2; done
mysql -h 127.0.0.1 -uroot -pCowSaysMoo SqlInjLesson -e "CREATE TABLE IF NOT EXISTS flags (flag varchar(255) NOT NULL); DELETE FROM flags; INSERT INTO flags (flag) VALUES ('$flag'); GRANT SELECT ON SqlInjLesson.flags TO 'firstBloodyMessL'@'%';"
