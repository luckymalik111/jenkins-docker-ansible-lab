# Jenkins + Docker + Ansible + AWS Lab

A self-contained, buildable version of the classic "Jenkins for DevOps" course
project: Jenkins running in Docker, driving SSH/Ansible deployments, a MySQL
database backed up to S3, a PHP+NGINX web app displaying data from that
database, and a Maven build/test/package/email pipeline.

This is an original implementation of the same architecture the course
teaches — not a copy of the course's own sample files (those live behind the
course platform and aren't something I can fetch for you).

Repo: https://github.com/luckymalik111/jenkins-docker-ansible-lab

## Stack

| Course topic | Where it lives here |
|---|---|
| Docker + Jenkins | [docker-compose.yml](docker-compose.yml), [jenkins/Dockerfile](jenkins/Dockerfile) |
| Jenkins plugins (SSH, Ansible, Mail, Maven, Role Strategy) | [jenkins/plugins.txt](jenkins/plugins.txt) |
| MySQL + backup to S3 | [sql/init.sql](sql/init.sql), [scripts/backup_db_to_s3.sh](scripts/backup_db_to_s3.sh) |
| Feed the DB with users | [scripts/feed_db.sh](scripts/feed_db.sh) |
| Trigger Jenkins jobs from bash (with/without params) | [scripts/trigger_job.sh](scripts/trigger_job.sh) |
| Jenkins + Ansible playbooks | [ansible/](ansible/) |
| NGINX + PHP web app showing the users table | [webapp/](webapp/) |
| Ansible role that redeploys the web table | [ansible/roles/webapp](ansible/roles/webapp) |
| Jenkinsfiles (backup job, Ansible deploy job, Maven job) | [ci/](ci/) |
| Maven build/test/package + email notification | [maven-sample/](maven-sample/), [ci/Jenkinsfile.maven-build](ci/Jenkinsfile.maven-build) |

## Quick start

```bash
cp .env.example .env
docker compose up -d --build
```

- Jenkins UI: http://localhost:8080 (initial admin password: `docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword`)
- Web app: http://localhost:8081
- MySQL: `localhost:3307` (mapped off the default 3306 to avoid clashing with a local MySQL install; see `.env` for credentials)

Seed some sample users:

```bash
./scripts/feed_db.sh 10 127.0.0.1 usersdb labuser labpass
```

Refresh http://localhost:8081 to see them.

## Wiring up Jenkins jobs

1. Create credentials in Jenkins (Manage Jenkins → Credentials):
   - `aws-backup-user`: Username/password credential holding your AWS access key ID/secret.
2. Create three Pipeline jobs pointing at this repo, each using "Pipeline script from SCM"
   with the script path set to one of:
   - `ci/Jenkinsfile.backup`
   - `ci/Jenkinsfile.ansible-deploy`
   - `ci/Jenkinsfile.maven-build`
3. For the Ansible job, make sure the `ansible` plugin is configured (Manage Jenkins →
   Global Tool Configuration) and that the Jenkins container can reach the `web-nginx-php`
   container (they're on the same `lab` Docker network already).

## Notes

- `webapp/` and `ansible/roles/webapp/templates/index.php.j2` intentionally contain the
  same page — the Ansible role is what a Jenkins "Ansible deploy" job pushes out after
  you edit the template, mirroring the course's playbook-driven redeploy step.
- Swap the `agent any` / plugin names in the `ci/Jenkinsfile.*` files to match whatever
  you actually install in your Jenkins instance.
