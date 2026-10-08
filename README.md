# OWASP Security Shepherd

[OWASP Security Shepherd](https://owasp.org/www-project-security-shepherd/) by Mark Denihan and
the OWASP Security Shepherd contributors: a security training platform with lessons and challenge
levels that return result keys. This repository runs it with
[Isoloom](https://www.isoloom.com): [`isoloom.yml`](isoloom.yml) describes the machines, and the
upstream source in [`build/web/app/`](build/web/app) builds with its own Maven profile and
Dockerfile in one multi-stage build.

| Machine | Service |
| --- | --- |
| web | Security Shepherd on Tomcat, HTTPS on port 8443 (port 8080 redirects to it) |
| db | MySQL 5.5 on port 3306, seeded with the core and module schemas |

## Run it

```bash
isoloom generate
isoloom up docker
```

Then open https://localhost:8443/ (self-signed certificate) and log in as `admin` / `password`;
Shepherd asks for a new password at first login. The same spec runs as Docker on a local VM
(`docker-vm`), on a cloud VM (`cloud-docker`) or on Kubernetes. Lab guide:
[Security Shepherd wiki](https://github.com/OWASP/SecurityShepherd/wiki).

Upstream version and commit: [UPSTREAM.md](UPSTREAM.md).

## Licence

GPL-3.0, as Security Shepherd ([LICENSE](LICENSE)). This application is deliberately vulnerable:
keep it isolated.
