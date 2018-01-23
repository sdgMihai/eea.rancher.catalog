version: "2"
services:
  docker:
    image: eeacms/jenkins-slave-dind:1.13-3.6.2
    labels:
      io.rancher.container.hostname_override: container_name
      io.rancher.scheduler.affinity:host_label: ${HOST_LABELS}
      io.rancher.scheduler.affinity:container_label_soft_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
    external_links:
    - "${JENKINS_MASTER}:jenkins-master"
    environment:
      JAVA_OPTS: "${JAVA_OPTS}"
      JENKINS_MASTER: "http://jenkins-master:8080"
      JENKINS_OPTS: "${JENKINS_OPTS}"
      JENKINS_MODE: "exclusive"
      JENKINS_NAME: "${JENKINS_NAME}"
      JENKINS_RETRY: "${JENKINS_RETRY}"
      JENKINS_USER: "${JENKINS_USER}"
      JENKINS_PASS: "${JENKINS_PASS}"
      JENKINS_LABELS: "${JENKINS_LABELS}"
      DOCKERHUB_USER: "${DOCKERHUB_USER}"
      DOCKERHUB_PASS: "${DOCKERHUB_PASS}"
      TZ: "${TZ}"
    network_mode: host
    volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    - jenkins-worker:/var/jenkins_home/worker

{{- if eq .Values.VOLUME_DRIVER "rancher-ebs"}}

volumes:
  jenkins-worker:
    driver: ${VOLUME_DRIVER}
    driver_opts:
      {{.Values.VOLUME_DRIVER_OPTS}}

{{- end}}
