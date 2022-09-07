{{- $secretObj := (lookup "v1" "Secret" "devtroncd" "postgresql-postgresql") | default dict }}
{{- $secretData := (get $secretObj "data") | default dict }}
{{- $Secret := (get $secretData "postgresql-password") | b64dec | default .Values.config.postgresPassword }}
introspection_addr: {{ .Values.config.introspection_addr }}
http_listen_addr: {{ .Values.config.http_listen_addr }}
log_level: {{ .Values.config.log_level }}
indexer:
  connstring: "host={{ .Values.config.postgresHost }} port={{ .Values.config.postgresPort }} dbname={{ .Values.config.postgresdbname }} user={{ .Values.config.postgresUser }} password={{ $Secret }} sslmode=disable"
  scanlock_retry: {{ .Values.config.indexer.scanlock_retry }}
  layer_scan_concurrency: {{ .Values.config.indexer.layer_scan_concurrency }}
  migrations: {{ .Values.config.indexer.migrations }}

matcher:
  indexer_addr: "{{ .Values.config.matcher.indexer_addr }}"
  connstring: "host={{ .Values.config.postgresHost }} port={{ .Values.config.postgresPort }} dbname={{ .Values.config.postgresdbname }} user={{ .Values.config.postgresUser }} password={{ $Secret }} sslmode=disable"
  max_conn_pool: {{ .Values.config.matcher.max_conn_pool }}
  run: ""
  migrations: {{ .Values.config.matcher.migrations }}
  updater_sets:
  {{- range $key, $value := .Values.config.matcher.clairUpdaterSets }}
  - "{{ $value }}"
  {{- end }}
    
notifier:
  connstring: "host={{ .Values.config.postgresHost }} port={{ .Values.config.postgresPort }} dbname={{ .Values.config.postgresdbname }} user={{ .Values.config.postgresUser }} password={{ $Secret }} sslmode=disable"
  delivery_interval: {{ .Values.config.notifier.delivery_interval }}
  poll_interval: {{ .Values.config.notifier.poll_interval }}
  migrations: {{ .Values.config.notifier.migrations }}