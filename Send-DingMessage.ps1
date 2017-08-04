# Version       1.2
# Author        Chenry Lee
# Tool          VSCode

$ErrorActionPreference = "SilentlyContinue"

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms");
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing");

function Check-PSVersion {
    if ($PSVersionTable.PSVersion.Major -lt 3) {
        $chkRes = [System.Windows.Forms.MessageBox]::Show("你的Powershell版本太低。`n运行本工具需要Powershell 3.0或以上版本。")          
    }
    if ($chkRes -eq "OK") {
        $objForm.Close()
    }
}

# Define Main Form
$objForm = New-Object System.Windows.Forms.Form
$objForm.Size = New-Object System.Drawing.Size(800,350)
$objForm.FormBorderStyle = "none"
$objForm.MaximizeBox = $false
$objForm.MinimizeBox = $false
$objForm.StartPosition = "centerscreen"
$objForm.add_Load({Check-PSVersion})

# Close button
$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Size = New-Object System.Drawing.Size(60,30)
$btnClose.FlatStyle = "Flat"
$btnClose.Text = "退出"
$btnClose.Font = New-Object System.Drawing.Font("微软雅黑",10)
$btnClose.Location = New-Object System.Drawing.Size(530,300)
$btnClose.Add_Click({$objForm.Close()})
$objForm.Controls.Add($btnClose)

# Form title
$lbTitle = New-Object System.Windows.Forms.Label
$lbTitle.Size = New-Object System.Drawing.Size(600,60)
$lbTitle.Location = New-Object System.Drawing.Size(100,20)
$lbTitle.BorderStyle = "none"
$lbTitle.TextAlign = "middlecenter"
$lbTitle.Font = New-Object System.Drawing.Font("微软雅黑",24)
$lbTitle.Text = "钉钉群消息发送器"
$objForm.Controls.Add($lbTitle)

# WebHook
$lbWebHook = New-Object System.Windows.Forms.Label
$lbWebHook.Size = New-Object System.Drawing.Size(120,30)
$lbWebHook.Location = New-Object System.Drawing.Size(20,100)
$lbWebHook.BorderStyle = "none"
$lbWebHook.TextAlign = "middleright"
$lbWebHook.Font = New-Object System.Drawing.Font("微软雅黑",12)
$lbWebHook.Text = "Web Hook:"
$objForm.Controls.Add($lbWebHook)

$txtWebHook = New-Object System.Windows.Forms.TextBox
$txtWebHook.Size = New-Object System.Drawing.Size(640,30)
$txtWebHook.Location = New-Object System.Drawing.Size(140,100)
$txtWebHook.BorderStyle = "FixedSingle"
$txtWebHook.TextAlign = "middleleft"
$txtWebHook.Font = New-Object System.Drawing.Font("微软雅黑",12)
$objForm.Controls.Add($txtWebHook)

# Message Title
$lbmsgTitle = New-Object System.Windows.Forms.Label
$lbmsgTitle.Size = New-Object System.Drawing.Size(120,30)
$lbmsgTitle.Location = New-Object System.Drawing.Size(20,150)
$lbmsgTitle.BorderStyle = "none"
$lbmsgTitle.TextAlign = "middleright"
$lbmsgTitle.Font = New-Object System.Drawing.Font("微软雅黑",12)
$lbmsgTitle.Text = "消息标题:"
$objForm.Controls.Add($lbmsgTitle)

$txtmsgTitle = New-Object System.Windows.Forms.TextBox
$txtmsgTitle.Size = New-Object System.Drawing.Size(640,30)
$txtmsgTitle.Location = New-Object System.Drawing.Size(140,150)
$txtmsgTitle.BorderStyle = "FixedSingle"
$txtmsgTitle.TextAlign = "middleleft"
$txtmsgTitle.Font = New-Object System.Drawing.Font("微软雅黑",12)
$objForm.Controls.Add($txtmsgTitle)

# Message URL
$lbmsgURL = New-Object System.Windows.Forms.Label
$lbmsgURL.Size = New-Object System.Drawing.Size(120,30)
$lbmsgURL.Location = New-Object System.Drawing.Size(20,200)
$lbmsgURL.BorderStyle = "none"
$lbmsgURL.TextAlign = "middleright"
$lbmsgURL.Font = New-Object System.Drawing.Font("微软雅黑",12)
$lbmsgURL.Text = "消息地址:"
$objForm.Controls.Add($lbmsgURL)

$txtmsgURL = New-Object System.Windows.Forms.TextBox
$txtmsgURL.Size = New-Object System.Drawing.Size(640,30)
$txtmsgURL.Location = New-Object System.Drawing.Size(140,200)
$txtmsgURL.BorderStyle = "FixedSingle"
$txtmsgURL.TextAlign = "middleleft"
$txtmsgURL.Font = New-Object System.Drawing.Font("微软雅黑",12)
$objForm.Controls.Add($txtmsgURL)

# Message Picture
$lbpicURL = New-Object System.Windows.Forms.Label
$lbpicURL.Size = New-Object System.Drawing.Size(120,30)
$lbpicURL.Location = New-Object System.Drawing.Size(20,250)
$lbpicURL.BorderStyle = "none"
$lbpicURL.TextAlign = "middleright"
$lbpicURL.Font = New-Object System.Drawing.Font("微软雅黑",12)
$lbpicURL.Text = "图片地址:"
$objForm.Controls.Add($lbpicURL)

$txtpicURL = New-Object System.Windows.Forms.TextBox
$txtpicURL.Size = New-Object System.Drawing.Size(640,30)
$txtpicURL.Location = New-Object System.Drawing.Size(140,250)
$txtpicURL.BorderStyle = "FixedSingle"
$txtpicURL.TextAlign = "middleleft"
$txtpicURL.Font = New-Object System.Drawing.Font("微软雅黑",12)
$objForm.Controls.Add($txtpicURL)

# Send Button
$btnSend = New-Object System.Windows.Forms.Button
$btnSend.Size = New-Object System.Drawing.Size(60,30)
$btnSend.FlatStyle = "Flat"
$btnSend.Text = "发送"
$btnSend.Font = New-Object System.Drawing.Font("微软雅黑",10)
$btnSend.Location = New-Object System.Drawing.Size(210,300)
$btnSend.Add_Click({Send-DingMessage})
$objForm.Controls.Add($btnSend)

# Send-Message function
function Send-DingMessage {
    $webhook = $txtWebHook.Text
    $msgTitle = $txtmsgTitle.Text
    $msgURL = $txtmsgURL.Text
    $picURL = $txtpicURL.Text

    $msg = @"
    {
    'feedCard': {
        'links': [
            {
                'title': '$msgTitle', 
                'messageURL': '$msgURL', 
                'picURL': '$picURL'
            }
        ]
    }, 
    'msgtype': 'feedCard'
}
"@

    Invoke-WebRequest -Uri $webhook -Method Post -ContentType 'application/json; charset=utf-8' -Body $msg    
}

$objForm.ShowDialog()
