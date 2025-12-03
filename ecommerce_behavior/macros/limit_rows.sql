{% macro limit_rows(default_limit=5000000) %}
    {% if target.name in ['dev', 'ci', 'local'] %}
        LIMIT {{ default_limit }}
    {% endif %}
{% endmacro %}