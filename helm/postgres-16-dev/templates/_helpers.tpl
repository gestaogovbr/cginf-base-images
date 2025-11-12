{{- define "postgres-16-dev.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "postgres-16-dev.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "postgres-16-dev.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "postgres-16-dev.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" -}}
{{- end -}}

{{- define "postgres-16-dev.labels" -}}
helm.sh/chart: {{ include "postgres-16-dev.chart" . }}
{{ include "postgres-16-dev.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "postgres-16-dev.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postgres-16-dev.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "postgres-16-dev.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "postgres-16-dev.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{- define "postgres-16-dev.authSecretName" -}}
{{- if .Values.auth.existingSecret -}}
{{- .Values.auth.existingSecret -}}
{{- else -}}
{{- default (printf "%s-auth" (include "postgres-16-dev.fullname" .)) .Values.auth.secretName -}}
{{- end -}}
{{- end -}}

