{% set CONDA_HOME = salt['environ.get']('CONDA_HOME') %}
{% set TETHYS_PERSIST = salt['environ.get']('TETHYS_PERSIST') %}

{% set TETHYS_HOME = salt['environ.get']('TETHYS_HOME') %}

{% set THREDDS_SERVICE_NAME = 'tethys_thredds' %}
{% set POSTGRES_SERVICE_NAME = 'tethys_postgres' %}
{% set GEOSERVER_SERVICE_NAME = 'tethys_postgres' %}

{% set WDE_VIEW_NAME = salt['environ.get']('WDE_VIEW_NAME') %}
{% set GEOSERVER_ENDPOINT = salt['environ.get']('GEOSERVER_ENDPOINT') %}
{% set INDRHI_GEOSERVER_WORKSPACE = salt['environ.get']('INDRHI_GEOSERVER_WORKSPACE') %}
{% set HYDROSERVER_ENDPOINT_RESERVOIRS = salt['environ.get']('HYDROSERVER_ENDPOINT_RESERVOIRS') %}
{% set CONDA_HOME = salt['environ.get']('CONDA_HOME') %}




Sync_Apps:
  cmd.run:
    - name: >
        . {{ CONDA_HOME }}/bin/activate tethys &&
        tethys db sync
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/init_apps_setup_complete" ];"

Set_Custom_Settings:
  cmd.run:
    - name: >
        . {{ CONDA_HOME }}/bin/activate tethys &&
        tethys app_settings set Views Names {{ WDE_VIEW_NAME }} &&
        tethys app_settings set endpoint {{ GEOSERVER_ENDPOINT }} &&
        tethys app_settings set workspace {{ INDRHI_GEOSERVER_WORKSPACE }}
        tethys app_settings set Hydroser_Endpoint {{ HYDROSERVER_ENDPOINT_RESERVOIRS }}
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/init_apps_setup_complete" ];"

Link_Tethys_Services_to_Apps:
  cmd.run:
    - name: >
        . {{ CONDA_HOME }}/bin/activate tethys &&
        tethys link persistent:{{ POSTGRES_SERVICE_NAME }} metdataexplorer2:ps_database:thredds_db &&
        tethys link persistent:{{ POSTGRES_SERVICE_NAME }} water_data_explorer:ps_database:catalog_db &&        
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/init_apps_setup_complete" ];"

Sync_App_Persistent_Stores:
  cmd.run:
    - name: >
        . {{ CONDA_HOME }}/bin/activate tethys &&
        tethys syncstores all
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/init_apps_setup_complete" ];"

Flag_Init_Apps_Setup_Complete:
  cmd.run:
    - name: touch {{ TETHYS_PERSIST }}/init_apps_setup_complete
    - shell: /bin/bash
    - unless: /bin/bash -c "[ -f "{{ TETHYS_PERSIST }}/init_apps_setup_complete" ];"