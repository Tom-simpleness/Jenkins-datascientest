{{/*
Return the fully qualified name of a resource.
*/}}
{{- define "docker-compose.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the name of the chart.
*/}}
{{- define "docker-compose.name" -}}
{{- .Chart.Name -}}
{{- end -}}