 WITH RingBuffer AS
(
	SELECT CAST(xst.target_data AS xml) AS TargetData
	FROM sys.dm_xe_database_session_targets AS xst
	INNER JOIN sys.dm_xe_database_sessions AS xs
	ON xst.event_session_address = xs.address
	WHERE xs.name = N'Bloqueos'
),
EventNode AS
(
	SELECT 
		CAST(NodeData.query('.') AS xml) AS EventInfo
	FROM RingBuffer AS rb
	CROSS APPLY rb.TargetData.nodes('/RingBufferTarget/event') AS n(NodeData)
)

SELECT 
	EventInfo.value('(event/@timestamp)[1]','datetimeoffset') AS timestamp,
	EventInfo.value('(event/@name)[1]','sysname') AS event_name,
	EventInfo.value('(/event/data[@name=''duration'']/value)[1]','BIGINT')/1024000 AS [Duration(seg)],

	-- bloqueado
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocked-process/process/@loginname)[1]', 'varchar(50)') 		as blocked_loginname,
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocked-process/process/@hostname)[1]', 'varchar(50)') 		as blocked_hostname,
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocked-process/process/@clientapp)[1]', 'varchar(50)') 		as blocked_clientapp,
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocked-process/process/@lockMode)[1]', 'varchar(50)') 		as blocked_LockMode,
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocked-process/process/@transactionname)[1]', 'varchar(50)') as blocked_transactionname,
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocked-process/process/@trancount)[1]', 'int') 				as blocked_trancount,
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocked-process/process/@isolationlevel)[1]', 'varchar(50)')	as blocked_isolationlevel,
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocked-process/process/@waitresource)[1]','SYSNAME')			AS blocked_waitres, 
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocked-process/process/inputbuf)[1]','varchar(max)')			AS blocked_query,

	-- bloqueador
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocking-process/process/@loginname)[1]', 'varchar(50)') 		as blocking_loginname,
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocking-process/process/@hostname)[1]', 'varchar(50)') 		as blocking_hostname,
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocking-process/process/@clientapp)[1]', 'varchar(50)') 		as blocking_clientapp,
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocking-process/process/@trancount)[1]', 'int') 				as blocking_trancount,
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocking-process/process/@isolationlevel)[1]', 'varchar(50)') as blocking_isolationlevel,
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocking-process/process/@waitresource)[1]','SYSNAME') 		AS blocking_waitres, 
	EventInfo.value('(/event/data[@name=''blocked_process'']/value/blocked-process-report/blocking-process/process/inputbuf)[1]','varchar(max)') 		AS blocking_query,


	EventInfo 
FROM EventNode
ORDER BY timestamp DESC;