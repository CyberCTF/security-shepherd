# Upstream

| | |
| --- | --- |
| Project | OWASP Security Shepherd |
| Repository | https://github.com/OWASP/SecurityShepherd |
| Version | v3.1 |
| Commit | d5c716629a9ff66b9dce2360e7b11a0c34bc9674 |
| Licence | GPL-3.0 |

`build/web/app/` is that release, unchanged, without its Git history. The v3.1 tree carries the
GPL-3.0 notice in its source headers but no licence file; [LICENSE](LICENSE) is the one upstream
added in commit 83437f2 (January 2019).

`build/web/Dockerfile` is upstream's Dockerfile preceded by a Maven stage that runs upstream's
`mvn -Pdocker clean install -DskipTests` (which builds the WAR and the TLS keystore, on the host
upstream), with `tomcat:alpine` pinned to `8.5.41-jre8-alpine`, the build arguments of upstream's
compose file as defaults, the database host set to `db` and the HTTPS redirect port set to 8443.

`build/db/Dockerfile` is upstream's `docker/mysql/Dockerfile` on `mysql:5.5.62`.
`build/db/coreSchema.sql` and `build/db/moduleSchemas.sql` are unchanged copies of
`build/web/app/src/main/resources/database/`; the Dockerfile makes the DELIMITER edits upstream's
Maven profile makes, and creates the challenge database users for any host (`'%'`) instead of
the Tomcat container's DNS name. Upstream's MongoDB service is optional in v3.1 (its compose file
leaves it out and the NoSQL level is closed), so it is left out here.

To update, replace `build/web/app/` with a newer release, copy its two schema files to
`build/db/`, then change this table.
