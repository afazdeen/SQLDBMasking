CREATE PROCEDURE MaskBloodGroupWrapperProcedure 
	@substituteDbName VARCHAR(MAX),
	@substituteSchemaName VARCHAR(MAX),
	@substituteTableName VARCHAR(MAX),
	@substituteColumnName VARCHAR(MAX),
	@substituteIdColumn VARCHAR(MAX)
AS
BEGIN
	DECLARE @cnt int=1,@totalrows int;
	DECLARE @sql1 varchar(500),@sql2 nvarchar(500);
	DECLARE @blood VARCHAR(50);

	SET @sql1='(SELECT COUNT('+@substituteIdColumn+') FROM '+@substituteDbName+'.'+@substituteSchemaName+'.'+ @substituteTableName+')';
	DECLARE @counttbl TABLE (count1 INT)
	INSERT @counttbl
	EXEC(@sql1)
	SET @totalRows = (SELECT count1 FROM @counttbl)
	DECLARE @total int = @totalrows
	WHILE(@cnt<=@total)
	BEGIN
		EXEC MaskBloodGroupAtomicProcedure @blood=@blood OUTPUT
		SET @sql2='UPDATE '+@substituteDbName+'.'+@substituteSchemaName+'.'+ @substituteTableName+' SET '+@substituteColumnName+ ' = '''+@blood+''' WHERE '+@substituteIdColumn+' ='+CAST(@cnt AS varchar(500))
		EXEC sys.sp_executesql @sql2
		SET @cnt=@cnt+1;
	END
END