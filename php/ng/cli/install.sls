{% set state = 'cli' %}
{% include "php/ng/installed.jinja" %}

{%- if salt['grains.get']('os_family') == "Debian" %}
{% set current_php = salt['alternatives.show_current']('php') %}
{% set phpng_version = salt['pillar.get']('php:ng:version', '7.0')|string %}

php_{{ phpng_version }}_link:
  cmd.run:
    - name: |
        if update-alternatives --query php >/dev/null 2>&1; then
          update-alternatives --set php /usr/bin/php{{ phpng_version }}
        else
          update-alternatives --install /usr/bin/php php /usr/bin/php{{ phpng_version }} {{ phpng_version|replace('.', '') }}
        fi
    - require:
      - pkg: php_install_{{ state }}
    - onlyif:
      - test -x /usr/bin/php{{ phpng_version }}
      - test "{{ current_php }}" != "/usr/bin/php{{ phpng_version }}"
{% endif %}
