{{/*
Expand the name of the chart.
*/}}
{{- define "java.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name with tenant
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
Optionally includes functional environment if one was defined using pattern <tenant>-<app-name>-<functional-environment>
e.g a4e-example-service-live, e.g a4e-example-service-try
*/}}
{{- define "java.fullnameWithTenant" -}}
{{- printf "%s-%s" .Values.tenant (include "java.fullname" .) | trunc 63 | trimSuffix "-" | lower}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
Optionally includes functional environment if one was defined using pattern -<app-name>-<functional-environment>
e.g example-service-live, e.g example-service-try
*/}}
{{- define "java.fullname" -}}
{{- if .Values.global.fullnameOverride }}
{{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" | lower}}
{{- else }}
{{- $name := default .Values.name }}
{{- if .Values.global.functionalEnvironment }}
{{- printf "%s-%s" $name .Values.global.functionalEnvironment | trunc 63 | trimSuffix "-" | lower}}
{{- else }}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" | lower }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create namespace using tenant and name using patternt <tenant>-<app-name> e.g a4e-example-service
optionally includes functional environment if one was defined using pattern <tenant>-<app-name>-<functional-environment>
e.g a4e-example-service-live, e.g a4e-example-service-try
*/}}
{{- define "java.namespace" -}}
{{- if .Values.global.namespaceOverride }}
{{- .Values.global.namespaceOverride | trunc 63 | trimSuffix "-" | lower}}
{{- else }}
{{- if .Values.global.functionalEnvironment }}
{{- printf "%s-%s-%s" .Values.tenant .Values.name .Values.global.functionalEnvironment | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Values.tenant .Values.name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "java.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "java.labels" -}}
{{ include "java.selectorLabels" . }}
{{ include "java.metaLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "java.selectorLabels" -}}
app.kubernetes.io/name: {{ include "java.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end }}

{{/*
Create unified labels
*/}}
{{- define "java.metaLabels" -}}
helm.sh/chart: {{ include "java.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "java.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "java.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
