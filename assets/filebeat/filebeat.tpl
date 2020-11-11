{{range .configList}}
- type: log
  enabled: true
  paths:
      - {{ .HostDir }}/{{ .File }}
  multiline.pattern:  '^\['                            #新增正则条件，以[开头
  multiline.negate: true                                           #新增
  multiline.match: after                                           #新增
  multiline.max_lines: 10000                                       #新增
  scan_frequency: 10s
  fields_under_root: true
  {{if .Stdout}}
  docker-json: true
  {{end}}
  {{if eq .Format "json"}}
  json.keys_under_root: true
  {{end}}
  fields:
      {{range $key, $value := .CustomFields}}
      {{ $key }}: {{ $value }}
      {{end}}
      {{range $key, $value := .Tags}}
      {{ $key }}: {{ $value }}
      {{end}}
      {{range $key, $value := $.container}}
      {{ $key }}: {{ $value }}
      {{end}}
  {{range $key, $value := .CustomConfigs}}
  {{ $key }}: {{ $value }}
  {{end}}
  tail_files: false
  close_inactive: 2h
  close_eof: false
  close_removed: true
  clean_removed: true
  close_renamed: false

{{end}}
