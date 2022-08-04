# Production and staging environments

Open Publishing has both a staging environment and a production environment.

The production environment for OJS is regarded as live and for use by the intended public audience.  It is relied upon for daily organizational operations of this service for the public.

The staging environment for OJS is regarded as an environment as close to production conditions as possible where upgrades of the OJS software can be test-deployed and made available to the product owners for acceptance testing before application deployment to production.  The staging environment is not regarded as persistent or having the same expectations for uptime/availability as a production service would.

## Configuration management

OJS's configuration workflows are managed in a web-based admin interface in the software.  These configurations are set and maintained by authenticated admin users assigned to the Journal Manager role in OJS.

Configuration changes include settings entered directly into the OJS admin web forms, files such as images uploaded through theme management, or basically any data or files uploaded through the "Settings" section of OJS.  These are recorded in the environment's database and local file system.

## Journal articles management

Journal articles are created through the web browser and managed in the same way that site-wide configurations are made.

Journal articles are configured in the web browser by admin users with the proper role assigned.  Files such as PDFs that are attached to the article submissions are stored on the environment's local file system.

## Mirroring staging and production

The staging environment's code base is kept identical to the production code base as much as possible, however site configurations/uploaded files are regarded as transient and are not mirrored.  Attempting to mirror configuration settings and files from staging to production is not recommended for PHP-based applications, as this can cause upgrades to fail unpredictably, introduce bugs, and put files at risk of being stored incorrectly/accidentally overwritten when moved between environments.

All configurations for the production environment are made by OJS admin users in the production environment.  

The staging environment is used for testing new code releases and bug fixes and can be used to test configuration changes in a non-production setting.  

In line with best practices carried out across teams for ITIMS-hosted and managed applications, configuration changes or uploaded files that are intended for production must be entered into the production environment by the appropriate admin user.
