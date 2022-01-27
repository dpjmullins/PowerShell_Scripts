# Powershell script that will be set on a time scheduled Windows Task.
# It will check if an Application service is down and if so send an email alert to specified email addresses
# The application hosting services were first registered for SMTP.
 
$ServiceName = "Application Service"
$APPservice = Get-ClusterResource -Name $ServiceName
 
# Specify email details
$timestamp = Get-Date -Format "HH:mm dd-MMMM-yyyy"
$EmailFrom = service_account@domain.net
$EmailTo = Get-Content -Path "D:\Email_Receipient_list"
$EmailSubject = "ALERT: Application Service is offline on Production Cluster Role <Server FQDN>."
$EmailBody = "The Application Service is offline on Production Cluster Role <Server FQDN>. 
 
This notification triggered at $timestamp CET.
 
Check server for further information."
 
# First check if the Application service is running
if ($APPservice.State -ne "Online")
{
    # If the service is not running, first sleep for 10 minutes as it may be restarting
    Start-Sleep -Seconds 600
 
    # If the service is still not running, send an email to say it is down
    if ($APPservice.State -ne "Online")
    {
        Send-MailMessage -From $EmailFrom -Subject $EmailSubject -To $EmailTo -Body $EmailBody -SmtpServer mail.novartis.net
    }
}
