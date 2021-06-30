$Body = ''

$vminfo = Get-AzVM
      
        

    foreach ($vm in $vminfo)
        {   
            $vmStatus = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status
           
            if($vmStatus.Statuses | where Code -match "PowerState/deallocated")  
            {
                Write-Output "Starting VM [$($vm.Name)]"
                $vm | Start-AzVM
            }
            elseif ($vmStatus.Statuses | where Code -match "PowerState/running") 
            {
                Write-Output "Stopping VM [$($vm.Name)]"
                $vm | Stop-AzVM
            } {
              
            }

            }


        foreach($vm in $vminfo)
 
        { 
         $vminfo = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status 
         foreach ($vmStatus in $vminfo.Statuses) 
        {                                 
             if($vmStatus.Code -like "PowerState/*") 
        { 
        $VMDetails = $vmStatus.DisplayStatus 
        } 

        } 
        $VMName = $vm.Name  
        Write-Host "VM Name : $VMName  -----  $VMDetails " 
        $Body = $Body + " <br /> VM Name : $VMName  -----  $VMDetails " 
      } 

$SmtpServer = 'smtp.mail.ru' 
$SmtpUser = 'sergey.r.7@mail.ru' 
$smtpPassword = ''
$MailtTo = 'sergey.r.5@mail.ru' 
$MailFrom = 'sergey.r.7@mail.ru' 
$MailSubject = "Azure VM Status"


$Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $SmtpUser, $($smtpPassword | ConvertTo-SecureString -AsPlainText -Force)

Send-MailMessage -To "$MailtTo" -from "$MailFrom" -Subject $MailSubject -Body "$Body" -SmtpServer $SmtpServer -BodyAsHtml -UseSsl -Credential $Credentials
 
write-Output "Custom Message : Azure VM Status Email Sent Users"
