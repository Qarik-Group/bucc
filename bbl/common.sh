#!/bin/bash
vars_file="${BBL_STATE_DIR}/vars/director-vars-file.yml"
flags_file="${BBL_STATE_DIR}/vars/flags"

add_var() {
    echo "${1}: '${2}'" >> "${vars_file}"
}

add_var_from_file() {
    echo "${1}: |" >> "${vars_file}"
    cat "${2}" | sed 's/^/  /g' >> "${vars_file}"
}

add_flag() {
    echo "${1}" >> "${flags_file}"
}

cpi() {
    env | sed -E -n 's/BBL_(AWS|AZURE|GCP|VSPHERE|OPENSTACK).*/\1/p' | head -n 1 | tr '[:upper:]' '[:lower:]'
}

set_default_cpi_flags() {
    if [ ! -e "${flags_file}" ]; then
       touch "${flags_file}"
       case $(cpi) in
           aws)
           ;;
           azure)
           ;;
           gcp)
               add_flag "ephemeral_external_ip"
           ;;
           vsphere)
           ;;
           openstack)
           ;;
       esac
    fi
}

prepare_vars_file_for_cpi() {
    case $(cpi) in
        aws)
            add_var "access_key_id" "${BBL_AWS_ACCESS_KEY_ID}"
            add_var "secret_access_key" "${BBL_AWS_SECRET_ACCESS_KEY}"
            ;;
        azure)
            add_var "subscription_id" "${BBL_AZURE_SUBSCRIPTION_ID}"
            add_var "client_id" "${BBL_AZURE_CLIENT_ID}"
            add_var "client_secret" "${BBL_AZURE_CLIENT_SECRET}"
            add_var "tenant_id" "${BBL_AZURE_TENANT_ID}"
            ;;
        gcp)
            add_var_from_file "gcp_credentials_json" "${BBL_GCP_SERVICE_ACCOUNT_KEY_PATH}"
            add_var "project_id" "${BBL_GCP_PROJECT_ID}"
            add_var "zone" "${BBL_GCP_ZONE}"
            ;;
        vsphere)
            add_var "vcenter_user" "${BBL_VSPHERE_VCENTER_USER}"
            add_var "vcenter_password" "${BBL_VSPHERE_VCENTER_PASSWORD}"
            ;;
        openstack)
            add_var "openstack_username" "${BBL_OPENSTACK_USERNAME}"
            add_var "openstack_password" "${BBL_OPENSTACK_PASSWORD}"
            ;;
    esac
}
