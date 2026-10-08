#!/bin/sh
# The seeded admin account logs in (the core schema answers): the login servlet redirects to
# index.jsp, where a failed login goes back to login.jsp.
curl -sk -o /dev/null -w '%{redirect_url}' -X POST -d 'login=admin&pwd=password' \
  https://web:8443/login | grep -q '/index.jsp$'
