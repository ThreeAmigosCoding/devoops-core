{{/*
Expand the name of the chart.
*/}}
{{- define "devoops-service.name" -}}
{{- default .Chart.Name .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a fully qualified app name.
Uses fullnameOverride if set, otherwise falls back to release name.
*/}}
{{- define "devoops-service.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "devoops-service.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{ include "devoops-service.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "devoops-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "devoops-service.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
