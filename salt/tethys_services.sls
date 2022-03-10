{% set CONDA_HOME = salt['environ.get']('CONDA_HOME') %}
{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}
{% set TETHYS_DB_HOST = salt['environ.get']('TETHYS_DB_HOST') %}
{% set TETHYS_DB_PORT = salt['environ.get']('TETHYS_DB_PORT') %}
{% set TETHYS_DB_SUPERUSER = salt['environ.get']('TETHYS_DB_SUPERUSER') %}
{% set TETHYS_DB_SUPERUSER_PASS = salt['environ.get']('TETHYS_DB_SUPERUSER_PASS') %}

{% set THREDDS_TDS_USERNAME = salt['environ.get']('THREDDS_TDS_USERNAME') %}
{% set THREDDS_TDS_PASSWORD = salt['environ.get']('THREDDS_TDS_PASSWORD') %}
{% set THREDDS_TDS_PROTOCOL = salt['environ.get']('THREDDS_TDS_PROTOCOL') %}
{% set THREDDS_TDS_HOST = salt['environ.get']('THREDDS_TDS_HOST') %}
{% set THREDDS_TDS_PORT = salt['environ.get']('THREDDS_TDS_PORT') %}

{% set GEOSERVER_USERNAME = salt['environ.get']('GEOSERVER_USERNAME') %}
{% set GEOSERVER_PASSWORD = salt['environ.get']('GEOSERVER_PASSWORD') %}
{% set GEOSERVER_PROTOCOL = salt['environ.get']('GEOSERVER_PROTOCOL') %}
{% set GEOSERVER_HOST = salt['environ.get']('GEOSERVER_HOST') %}
{% set GEOSERVER_PORT = salt['environ.get']('GEOSERVER_PORT') %}


{% set THREDDS_SERVICE_NAME = 'tethys_thredds' %}
{% set POSTGRES_SERVICE_NAME = 'tethys_postgres' %}
{% set GEOSERVER_SERVICE_NAME = 'tethys_geoserver' %}


{% set THREDDS_SERVICE_URL = THREDDS_TDS_USERNAME + ':' + THREDDS_TDS_PASSWORD + '@' + THREDDS_TDS_PROTOCOL +'://' + THREDDS_TDS_HOST + ':' + THREDDS_TDS_PORT %}
{% set GEOSERVER_SERVICE_URL = GEOSERVER_USERNAME + ':' + GEOSERVER_PASSWORD + '@' + GEOSERVER_PROTOCOL +'://' + GEOSERVER_HOST + ':' + GEOSERVER_PORT %}
{% set POSTGRES_SERVICE_URL = TETHYS_DB_SUPERUSER + ':' + TETHYS_DB_SUPERUSER_PASS + '@' + TETHYS_DB_HOST + ':' + TETHYS_DB_PORT %}


Create_THREDDS_Spatial_Dataset_Service:
  cmd.run:
    - name: ". {{ CONDA_HOME }}/bin/activate tethys && tethys services create spatial -t THREDDS -n {{ THREDDS_SERVICE_NAME }} -c {{ THREDDS_SERVICE_URL }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"


Create_GEOSERVER_Spatial_Dataset_Service:
  cmd.run:
    - name: ". {{ CONDA_HOME }}/bin/activate tethys && tethys services create spatial -t GeoServer -n {{ GEOSERVER_SERVICE_NAME }} -c {{ GEOSERVER_SERVICE_URL }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"


Create_Persistent_Stores_Database:
  cmd.run:
    - name: ". {{ CONDA_HOME }}/bin/activate tethys && tethys services create persistent -n {{ POSTGRES_SERVICE_NAME }} -c {{ POSTGRES_SERVICE_URL }}"
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"



Flag_Tethys_Services_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/tethys_services_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/tethys_services_complete" ];"