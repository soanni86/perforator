{{/*
Expand the name of the chart.
*/}}
{{- define "perforator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "perforator.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "perforator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "perforator.labels" -}}
helm.sh/chart: {{ include "perforator.chart" . }}
{{ include "perforator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "perforator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "perforator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Agent selector labels
*/}}
{{- define "perforator.agent.selectorLabels" -}}
perforator.component: agent
{{- end }}

{{/*
Storage selector labels
*/}}
{{- define "perforator.storage.selectorLabels" -}}
perforator.component: storage
{{- end }}

{{/*
Proxy selector labels
*/}}
{{- define "perforator.proxy.selectorLabels" -}}
perforator.component: proxy
{{- end }}

{{/*
Web selector labels
*/}}
{{- define "perforator.web.selectorLabels" -}}
perforator.component: web
{{- end }}

{{/*
gc selector labels
*/}}
{{- define "perforator.gc.selectorLabels" -}}
perforator.component: gc
{{- end }}

{{/*
Offline processing selector labels
*/}}
{{- define "perforator.offlineprocessing.selectorLabels" -}}
perforator.component: offlineprocessing
{{- end }}

{{/*
PostgreSQL migration job selector labels
*/}}
{{- define "perforator.migrationspg.selectorLabels" -}}
app.kubernetes.io/component: migrations-pg
{{- end }}

{{/*
ClickHouse migration job selector labels
*/}}
{{- define "perforator.migrationsch.selectorLabels" -}}
app.kubernetes.io/component: migrations-ch
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "perforator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "perforator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
//////////////////////////////////////////////////////////////////////////////////////////// 
*/}}

{{/*
Return effective PostgreSQL endpoints.
*/}}
{{- define "perforator.postgresql.endpoints" -}}
{{- if .Values.testing.enableTestingDatabases -}}
- host: {{ printf "%s-postgresql" .Release.Name | quote }}
  port: {{ print 5432 }}
{{- else -}}
{{ toYaml .Values.databases.postgresql.endpoints }}
{{- end -}}
{{- end }}

{{/*
Return effective ClickHouse endpoints.
*/}}
{{- define "perforator.clickhouse.endpoints" -}}
{{- if .Values.testing.enableTestingDatabases -}}
{{- $host := printf "%s-clickhouse" .Release.Name -}}
{{- $port := "9440" -}}
- {{ printf "%s:%s" $host $port | quote }}
{{- else -}}
{{ toYaml .Values.databases.clickhouse.replicas }}
{{- end -}}
{{- end }}

{{/*
Return effective S3 endpoint.
*/}}
{{- define "perforator.s3.endpoint" -}}
{{- if .Values.testing.enableTestingDatabases -}}
{{- $host := printf "%s-minio" .Release.Name -}}
{{- $port := "9000" -}}
{{ printf "%s:%s" $host $port | quote }}
{{- else -}}
{{ .Values.databases.s3.endpoint | quote }}
{{- end -}}
{{- end }}

{{/*
//////////////////////////////////////////////////////////////////////////////////////////// 
*/}}

{{/*
Create secretKeyRef for one of databases
*/}}

{{- define "perforator.secretKeyRef.postgresql" -}}
{{- if .Values.databases.postgresql.password -}}
name: {{ include "perforator.fullname" . }}-postgresql-password
key: password
{{- else if (and .Values.databases.postgresql.secretName .Values.databases.postgresql.secretKey) -}}
name: {{ .Values.databases.postgresql.secretName }}
key: {{ .Values.databases.postgresql.secretKey }}
{{- else -}}
{{- printf "Specify postgresql secret name and password key name, your values: secret: %s field: %s" .Values.databases.postgresql.secretName .Values.databases.postgresql.secretKey | fail }}
{{- end }}
{{- end }}

{{- define "perforator.secretKeyRef.clickhouse" -}}
{{- if .Values.databases.clickhouse.password -}}
name: {{ include "perforator.fullname" . }}-clickhouse-password
key: password
{{- else if (and .Values.databases.clickhouse.secretName .Values.databases.clickhouse.secretKey) -}}
name: {{ .Values.databases.clickhouse.secretName }}
key: {{ .Values.databases.clickhouse.secretKey }}
{{- else -}}
{{- printf "Specify clickhouse secret name and password key name, your values: secret: %s field: %s" .Values.databases.clickhouse.secretName .Values.databases.clickhouse.secretKey | fail }}
{{- end }}
{{- end }}

{{- define "perforator.secretName.s3" -}}
{{- if and .Values.databases.s3.accessKey .Values.databases.s3.secretKey -}}
{{ include "perforator.fullname" . }}-storage-s3-keys
{{- else if .Values.databases.s3.secretName -}}
{{ .Values.databases.s3.secretName }}
{{- else -}}
{{- "Specify s3 access key and secret key or s3 secret name, containing this values" | fail }}
{{- end }}
{{- end }}

{{/*
//////////////////////////////////////////////////////////////////////////////////////////// 
*/}}

{{- define "perforator.storage.tlsSecretName" -}}
{{- if .Values.storageAgentTLS.autoGenerated -}}
    {{- printf "%s-storage-crt" (include "perforator.fullname" .) -}}
{{- else -}}
    {{- required "Existing secret with certificates must be specified when autoGenerated option is turned off" .Values.storageAgentTLS.storage.existingSecret | printf "%s" -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the perforator storage cert file.
*/}}
{{- define "perforator.storage.tlsCert" -}}
{{- if .Values.storageAgentTLS.autoGenerated -}}
    {{- printf "/etc/perforator/certificates/%s" "tls.crt" -}}
{{- else -}}
    {{- required "Certificate filename must be specified when autoGenerated option is turned off" .Values.storageAgentTLS.storage.certFilename | printf "/etc/perforator/certificates/%s" -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the perforator storage cert key file.
*/}}
{{- define "perforator.storage.tlsCertKey" -}}
{{- if .Values.storageAgentTLS.autoGenerated -}}
    {{- printf "/etc/perforator/certificates/%s" "tls.key" -}}
{{- else -}}
    {{- required "Certificate Key filename must be specified when autoGenerated option is turned off" .Values.storageAgentTLS.storage.certKeyFilename | printf "/etc/perforator/certificates/%s" -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the CA cert file signing the perforator storage cert.
*/}}
{{- define "perforator.storage.tlsCACert" -}}
{{- if .Values.storageAgentTLS.autoGenerated -}}
    {{- printf "/etc/perforator/certificates/%s" "ca.crt" -}}
{{- else if .Values.storageAgentTLS.storage.certCAFilename -}}
    {{- printf "/etc/perforator/certificates/%s" .Values.storageAgentTLS.storage.certCAFilename -}}
{{- else -}}
    {{- printf "" -}}
{{- end -}}
{{- end -}}

{{/*
//////////////////////////////////////////////////////////////////////////////////////////// 
*/}}

{{- define "perforator.agent.service.name" -}}
{{ printf "%s-agent-service" (include "perforator.fullname" .) }}
{{- end }}

{{/*
//////////////////////////////////////////////////////////////////////////////////////////// 
*/}}

{{- define "perforator.storage.host" -}}
{{ .Values.storage.hostname | default (printf "%s:%v" (include "perforator.storage.service.name" .) .Values.storage.service.ports.grpc.port) }}
{{- end }}

{{- define "perforator.storage.service.name" -}}
{{ printf "%s-storage-service" (include "perforator.fullname" .) }}
{{- end }}

{{/*
//////////////////////////////////////////////////////////////////////////////////////////// 
*/}}

{{- define "perforator.proxy.host.http" -}}
{{ .Values.proxy.hostname | default (printf "%s:%v" (include "perforator.proxy.service.name" .) .Values.proxy.service.ports.http.port) }}
{{- end }}

{{- define "perforator.proxy.host.grpc" -}}
{{ .Values.proxy.hostname | default (printf "%s:%v" (include "perforator.proxy.service.name" .) .Values.proxy.service.ports.grpc.port) }}
{{- end }}

{{- define "perforator.proxy.service.name" -}}
{{ printf "%s-proxy-service" (include "perforator.fullname" .) }}
{{- end }}



{{/*
//////////////////////////////////////////////////////////////////////////////////////////// 
*/}}

{{- define "perforator.web.service.name" -}}
{{ printf "%s-web-service" (include "perforator.fullname" .) }}
{{- end }}

{{/*
//////////////////////////////////////////////////////////////////////////////////////////// 
*/}}

{{/*
//////////////////////////////////////////////////////////////////////////////////////////// 
*/}}

{{- define "perforator.gc.service.name" -}}
{{ printf "%s-gc-service" (include "perforator.fullname" .) }}
{{- end }}

{{/*
//////////////////////////////////////////////////////////////////////////////////////////// 
*/}}

{{- define "perforator.ingress.apiVersion" -}}
  {{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.GitVersion -}}
    {{- print "extensions/v1beta1" -}}
  {{- else if semverCompare "<1.19-0" .Capabilities.KubeVersion.GitVersion -}}
    {{- print "networking.k8s.io/v1beta1" -}}
  {{- else -}}
    {{- print "networking.k8s.io/v1" -}}
  {{- end -}}
{{- end -}}
