{% macro limit_rows(default_limit=5000000) %}
    {% if target.name in ['dev', 'ci', 'prod'] %}
        LIMIT {{ default_limit }}
    {% endif %}
{% endmacro %}