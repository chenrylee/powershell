
$ErrorActionPreference = "SilentlyContinue"

Import-Module ActiveDirectory

$UserList=Import-Csv D:\Source\users.csv -Encoding Default
$PWD=ConvertTo-SecureString -AsPlainText "1234@abcd" -Force

$OUList = @("BOD","GeneralOffice","IPO","Credit","Finance","CallCenter","BMD","IT","Supervision","RiskManagement","DataCenter","FinanceMKT","LegalCompliance","Administration","FPPM","University","HR","Collection","eBusiness","Sales","MTP","IS","Engineering","PM","Public")
$DptList = @("董事会","总裁室","互联网产品中心","信审中心","财务部","呼叫中心","品牌管理部","信息技术部","监察部","风险管理部","数据中心","金融同业部","法务合规部","行政采购部","金融产品与项目管理部","达飞大学","人力资源部","催收中心","电子商务部","销售部","管培生项目部","信息安全部","工程部","项目管理部","公共")

foreach($user in $UserList) {
    $Name=$User.姓名
    $employeeID= "{0:d4}" -f [int]$user.编号
    $FN = $user.FN
    $LN = $user.LN
    $account = ($LN + $FN).ToLower()
    $username = $account
    $i = 0
    Get-ADUser $username -ErrorAction SilentlyContinue -ErrorVariable Flag | Out-Null
    while (!$Flag) {
      $i++
      $sub = "{0:d2}" -f $i
      $username = $account+[string]$sub
      Get-ADUser $username -ErrorAction SilentlyContinue -ErrorVariable Flag | Out-Null
    }
    $GivenName=$User.名
    $surname=$User.姓
    $dept = $User.部门
    $title = $user.岗位
    $office = $user.工作地
    $Description = $user.岗位
    $index = [array]::IndexOf($DptList,$dept)
    $Path = "OU=$($OUList[$index]),OU=Users,OU=HQ,DC=example,DC=com"
    $Group = "JK $($OUList[$index]) DptFolder Users"
    $TimeStamp=Get-Date -Format "yyyy-MM-dd HH:mm:ss"
   
   	$newUser = @{
      Name = $Name
		  GivenName = $GivenName
	    Surname = $surname
	    Path = $Path
	    samAccountName = $username
	    userPrincipalName = $username+"@example.com"
	    DisplayName = $Name
      EmployeeID=$employeeID
      Department = $dept
      Title = $title
	    AccountPassword = $PWD
	    ChangePasswordAtLogon = $true
	    Enabled = $true
	    Company = "My Group"
	    Office = $office
      Description = $Description
	    }

      Write-Host "Creating user $Name"
      try {
        New-ADUser @newUser
        Set-ADUser $username -Replace @{Firstname=$FN;Lastname=$LN}
        Write-Host -ForegroundColor Green "User $Name is created with username $username."
        Start-Sleep -Seconds 2
        Add-ADGroupMember $Group $username
        Add-ADGroupMember "OTRS Users" $username
        Add-Content -Path "D:\Logs\Add_User.log" -Value "$TimeStamp, User $Name with account $username was created successfully."
        }
      catch {
        Write-Host -ForegroundColor Red "Failed to create user $Name."
        Add-Content -Path "D:\Logs\Add_User.log" -Value "$TimeStamp, Failed to create user $Name with account $username."
        }
      Start-Sleep -Seconds 1
}
