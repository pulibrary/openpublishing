# openpublishing
OJS instance for Princeton Open Access Publishing Platform

## PUL OJS instances

PUL maintains two instances of OJS: ojs-staging, and ojs-prod. <https://openpublishing.princeton.edu> is an alias for ojs-prod.  

## Deployment

OJS deployments are handled in [princeton_ansible](https://github.com/pulibrary/princeton_ansible).  There is an [ojs playbook](https://github.com/pulibrary/princeton_ansible/blob/main/playbooks/ojs.yml).  Points to remember when deploying OJS with ansible:

* The OJS core code base is downloaded from [the PKP OJS .tar.gz downloads](https://pkp.sfu.ca/ojs/ojs_download/).  The software version number is defined in ansible.
* Some core files are maintained in the PKP OJS repository as git submodules, and therefore do not automatically ship with OJS downloads from source.  [This is an example of our recommendated approach for pulling in submodule code](https://github.com/pulibrary/princeton_ansible/blob/main/roles/ojs/tasks/main.yml#L182).
* The healthSciences theme is downloaded from the [healthSciences theme PKP GitHub repository](https://github.com/pkp/healthSciences/).
* Custom CSS used with OJS themes are maintained in the [ojs_styles repository](https://github.com/pulibrary/ojs_styles).  These stylesheets are uploaded directly to OJS via the admin web UI (see the [ojs_styles README](https://github.com/pulibrary/ojs_styles#readme) for instructions).
  
## Local Customizations
We want to keep local customization to a minimum to ensure we can upgrade easily. When a local customization is needed, add it to this repository and add a step in ansible to copy the file in place where it needs to go.

For example, the file in this repo at `plugins/themes/healthSciences/locale/ja_JP/locale.po` adds Japanese UI fixes to the healthSciences theme for OJS, which are needed by a Princeton journal that is published in Japanese. We keep the file here, and copy it to the right place via ansible.
