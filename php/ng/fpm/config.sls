# Manages the php-fpm main ini file
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/ng/map.jinja" import php with context %}
{%- from tplroot ~ "/ng/ini.jinja" import php_ini %}

{%- set ini_settings = php.ini.defaults %}
{%- for key, value in php.fpm.config.ini.settings.items() %}
  {%- if ini_settings[key] is defined %}
    {%- do ini_settings[key].update(value) %}
  {%- else %}
    {%- do ini_settings.update({key: value}) %}
  {%- endif %}
{%- endfor %}

{%- set conf_settings = php.lookup.fpm.defaults %}
{%- do conf_settings.update(php.fpm.config.conf.settings) %}

php_fpm_ini_config:
  {{ php_ini(php.lookup.fpm.ini,
             'php_fpm_ini_config',
             php.fpm.config.ini.opts,
             ini_settings
  ) }}

php_fpm_conf_config:
  {{ php_ini(php.lookup.fpm.conf,
             'php_fpm_conf_config',
             php.fpm.config.conf.opts,
             conf_settings
  ) }}

{{ php.lookup.fpm.pools }}:
    file.directory:
        - name: {{ php.lookup.fpm.pools }}
        - user: {{ php.lookup.fpm.user }}
        - group: {{ php.lookup.fpm.group }}
        - file_mode: 755
        - make_dirs: True
