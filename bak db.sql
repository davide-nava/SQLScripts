Declare @nomeFile varchar(max)
declare @backupSetId as int

 
set @nomeFile = 'C:\SQL\Dev_' + REPLACE(REPLACE(REPLACE(convert(varchar(50),Getdate(), 120),':','_'),' ','__'),'.','_') + '.bak'

BACKUP DATABASE [XXXXXX] TO  DISK = @nomeFile WITH NOFORMAT, INIT,  NAME = N'XXXXXX-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
select @backupSetId = position from msdb..backupset where database_name=N'XXXXXX' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'TTB' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''XXXXXX'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = @nomeFile WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND

GO