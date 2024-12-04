{{/*
Define an outline container common fields
EXAMPLE USAGE: {{ include "outline.container.common" (dict "Release" .Release "Values" .Values) }}
*/}}
{{- define "outline.container.common" }}
{{- with .Values.outline.resources }}
resources:
  {{- toYaml . | nindent 2 }}
{{- end }}

{{- with .Values.outline.envFrom }}
envFrom:
  {{- toYaml . | nindent 2 }}
{{- end }}

env:
  - name: NODE_ENV
    value: "production"
  - name: URL
    value: "http://{{ .Values.ingress.host }}"
  - name: PORT
    value: {{ .Values.outline.port | quote }}
  - name: FORCE_HTTPS
    value: "false"
  - name: ENABLE_UPDATES
    value: "false"
  - name: FILE_STORAGE_UPLOAD_MAX_SIZE
    value: "26214400"
  {{- if .Values.outline.storage.filesystem.enabled }}
  - name: FILE_STORAGE
    value: local
  - name: FILE_STORAGE_LOCAL_ROOT_DIR
    value: /var/lib/outline/data
  {{- else if .Values.outline.storage.s3.enabled }}
  - name: FILE_STORAGE
    value: "s3"
  {{- with .Values.outline.storage.s3.forcePathStyle }}
  - name: AWS_S3_FORCE_PATH_STYLE
    value: {{ . | quote }}
  {{- end }}
  {{- with .Values.outline.storage.s3.bucket }}
  - name: AWS_S3_UPLOAD_BUCKET_NAME
    value: {{ . | quote }}
  {{- end }}
  {{- with .Values.outline.storage.s3.bucketUrl }}
  - name: AWS_S3_UPLOAD_BUCKET_URL
    value: {{ . | quote }}
  {{- end }}
  {{- end }}
  {{- with .Values.outline.env }}
  {{- toYaml . | nindent 2 }}
  {{- end }}

volumeMounts:
  {{- if .Values.outline.persistence.enabled }}
  - name: data
    mountPath: /var/lib/outline/data
  {{- end }}
  {{- with .Values.outline.extraVolumeMounts }}
  {{- toYaml . | nindent 2 }}
  {{- end }}


{{- end }}