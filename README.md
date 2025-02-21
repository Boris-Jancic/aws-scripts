# aws-scripts
Usefull scripts for shortening manual labour with AWS API


## [ses-email-uploader](https://github.com/Boris-Jancic/aws-scripts/blob/main/ses-email-uploader.sh)
If your application relies hevily on AWS SES you will probobaly find yourself in a position where you update the email template files often.
Knowing & experiencing this i created this script which will automatically use the awscli to upload/replace email templates from a specified directory.

The script has two paramaters:
- `--directory` -> this paramater is **mandatory**, this is where we specify what directory we should list email templates from
- `--overwrite` -> this paramater is **optional**, if the paramater is mentioned the script will overwrite all existing email templates with the current contents of the directory
