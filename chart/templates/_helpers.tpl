{{/*
Expand the name of the chart.
*/}}
{{- define "karakeep.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "karakeep.fullname" -}}
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
{{- define "karakeep.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "karakeep.labels" -}}
helm.sh/chart: {{ include "karakeep.chart" . }}
{{ include "karakeep.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "karakeep.selectorLabels" -}}
app.kubernetes.io/name: {{ include "karakeep.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "karakeep.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "karakeep.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Persistence resources
*/}}
{{- define "karakeep.persistenceVolumeName" -}}
{{- if .Values.persistence.volume }}
{{- default .Values.persistence.volume.name "data" }}
{{- else }}
{{- "data" }}
{{- end }}
{{- end }}

{{- define "karakeep.persistenceVolumeMountPath" -}}
{{- if .Values.persistence.volume }}
{{- default .Values.persistence.volume.mountPath "/data" }}
{{- else }}
{{- "/data" }}
{{- end }}
{{- end }}

{{/*
NextAuth URL
Return the primary ingress host if enabled and defined; otherwise, return "localhost".
*/}}
{{- define "karakeep.nextAuthURL" -}}
{{- if and .Values.ingress.enabled (gt (len .Values.ingress.hosts) 0) (index .Values.ingress.hosts 0).host }}
  {{- (index .Values.ingress.hosts 0).host | quote -}}
{{- else -}}
  "localhost"
{{- end -}}
{{- end }}

{{/*
Return an env var definition for OPENAI_API_KEY if .Values.openAIApiKey is set.
*/}}
{{- define "karakeep.openAIEnv" -}}
{{- if .Values.openAIApiKey }}
- name: OPENAI_API_KEY
  value: {{ .Values.openAIApiKey | quote }}
{{- end -}}
{{- end }}
