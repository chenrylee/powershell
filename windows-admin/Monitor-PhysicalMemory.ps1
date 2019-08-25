# Reqire    Powershell 2.0 or above
# Author    Chenry Lee
# Twitter   @chenrylee

function Get-MemCounter {
    # 获取物理内存大小，单位B
    $total_mem = (Get-WmiObject win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum
    function Check-Usage {
        # 通过计数器取已提交内存大小及时间戳
        $mem_counter =  Get-Counter "\Memory\Available Bytes"
        $timestamp = $mem_counter.TimeStamp
        $mem_in_use = $mem_counter.CounterSamples.CookedValue
        # 格式化时间戳
        $f_timestamp = Get-Date -Date $timestamp -Format "HH:mm:ss"
        # 格式化内存占用，并转化为百分比
        $f_mem_in_use = "{0:p2}" -f $(1 - $mem_in_use/$total_mem)
        # 输出
        Write-Host -BackgroundColor Green -ForegroundColor Black -NoNewline "$f_timestamp"
        Write-Host -NoNewline "`t`t"
        Write-Host -BackgroundColor Blue -ForegroundColor Black "$f_mem_in_use"
        # 每30秒取一次数
        Start-Sleep -Seconds 30
        # 重复
        Check-Usage
    }
Check-Usage
}
