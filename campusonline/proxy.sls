{%- from "campusonline/map.jinja" import campusonline with context %}
{%- set noservices = salt['grains.get']('noservices', None) %}

{%- if campusonline.sites is defined %}
campusonline_proxy_package:
  pkg.installed:
  - pkgs: {{ campusonline.proxy.pkgs }}

campusonline_proxy_service:
  service.running:
    - name: {{ campusonline.proxy.service }}
    - enable: true
    {%- if noservices %}
    - onlyif: /bin/false
    {%- endif %}
    - require:
      - pkg: campusonline_proxy_package

{%- for module in campusonline.proxy.modules %}
{%- if grains['os_family'] == 'Debian' %}
campusonline_proxy_module_{{ module }}:
  cmd.run:
    - name: /usr/sbin/a2enmod {{ module }}
    - unless: /usr/sbin/a2query -m {{ module }}
    - watch:
      - pkg: campusonline_proxy_package
    - require_in:
      - service: campusonline_proxy_service
{%- endif %}
{%- endfor %}

{%- for name, site in campusonline.sites.items() %}
campusonline_{{ name }}_proxy_config:
  file.managed:
  - name: {{ campusonline.proxy.config.dir }}/{{ name }}{{ campusonline.proxy.config.suffix }}
  - source: salt://campusonline/files/vhost.conf
  - template: jinja
  - context:
      site: {{ site }}
      proxy: {{ campusonline.proxy }}
  - require:
    - pkg: campusonline_proxy_package
  - require_in:
    - service: campusonline_proxy_service
  - watch_in:
    - service: campusonline_proxy_service

campusonline_{{ name }}_proxy_tls_certificate:
  file.managed:
  - name: {{ campusonline.proxy.tls.public }}/{{ site.hostname }}.pem
  - contents_pillar: campusonline:sites:{{ name }}:proxy:tls:certificate
  - user: root
  - group: root
  - mode: 0644
  - require:
    - pkg: campusonline_proxy_package
  - require_in:
    - service: campusonline_proxy_service
  - watch_in:
    - service: campusonline_proxy_service
campusonline_{{ name }}_proxy_tls_key:
  file.managed:
  - name: {{ campusonline.proxy.tls.private }}/{{ site.hostname }}.pem
  - contents_pillar: campusonline:sites:{{ name }}:proxy:tls:key
  - user: {{ campusonline.proxy.tls.get('user', 'root') }}
  - group: {{ campusonline.proxy.tls.get('group', 'ssl-cert') }}
  - mode: {{ campusonline.proxy.tls.get('mode', '0640') }}
  - require:
    - pkg: campusonline_proxy_package
  - require_in:
    - service: campusonline_proxy_service
  - watch_in:
    - service: campusonline_proxy_service

{%- if site.proxy.tls.chain is defined %}
campusonline_{{ name }}_proxy_tls_chain:
  file.managed:
  - name: {{ campusonline.proxy.tls.public }}/{{ site.hostname }}.chain.pem
  - contents_pillar: campusonline:sites:{{ name }}:proxy:tls:chain
  - user: root
  - group: root
  - mode: 0644
  - require:
    - pkg: campusonline_proxy_package
  - require_in:
    - service: campusonline_proxy_service
  - watch_in:
    - service: campusonline_proxy_service
{%- endif %}

{%- if site.proxy.maintainance is defined %}
campusonline_{{ name }}_maintainance_dir_home:
  file.directory:
    - name: {{ site.proxy.maintainance.directory }}
    - user: {{ site.proxy.maintainance.username }}
    - group: {{ campusonline.proxy.group }}
    - dir_mode: 750
    - file_mode: 640

campusonline_{{ name }}_maintainance_dir_root:
  file.directory:
    - name: {{ site.proxy.maintainance.directory }}/CAMPUSonline
    - user: {{ site.proxy.maintainance.username }}
    - group: {{ campusonline.proxy.group }}
    - dir_mode: 750
    - file_mode: 640
    - require:
      - file: campusonline_{{ name }}_maintainance_dir_home

campusonline_{{ name }}_maintainance_dir_{{ site.proxy.instance }}:
  file.directory:
    - name: {{ site.proxy.maintainance.directory }}/CAMPUSonline/{{ site.proxy.instance }}
    - user: {{ site.proxy.maintainance.username }}
    - group: {{ campusonline.proxy.group }}
    - dir_mode: 750
    - file_mode: 640
    - require:
      - file: campusonline_{{ name }}_maintainance_dir_root

campusonline_{{ name }}_maintainance_dir_scripts:
  file.directory:
    - name: {{ site.proxy.maintainance.directory }}/scripts
    - user: {{ site.proxy.maintainance.username }}
    - group: {{ campusonline.proxy.group }}
    - dir_mode: 750
    - file_mode: 640
    - require:
      - file: campusonline_{{ name }}_maintainance_dir_home

campusonline_{{ name }}_maintainance_dir_conf:
  file.directory:
    - name: {{ site.proxy.maintainance.directory }}/CAMPUSonline/conf
    - user: {{ site.proxy.maintainance.username }}
    - group: {{ campusonline.proxy.group }}
    - dir_mode: 750
    - file_mode: 640
    - require:
      - file: campusonline_{{ name }}_maintainance_dir_home

{%- if site.proxy.maintainance.keys is iterable %}
campusonline_{{ name }}_maintainance_public_key:
  ssh_auth.present:
    - user: {{ site.proxy.maintainance.username }}
    - names:
      {%- for key in site.proxy.maintainance.keys %}
      - {{ key }}
      {%- endfor %}
{%- endif %}
{%- endif %}

{%- if grains['os_family'] == 'Debian' %}
campusonline_{{ name }}_proxy_config_enable:
  cmd.run:
    - name: /usr/sbin/a2ensite -q {{ name }}{{ campusonline.proxy.config.suffix }}
    - unless: /usr/sbin/a2query -q -s {{ name }}{{ campusonline.proxy.config.suffix }}
    - watch:
      - file: campusonline_{{ name }}_proxy_config
    - require_in:
      - service: campusonline_proxy_service
{%- endif %}

{%- endfor %}
{%- endif %}
