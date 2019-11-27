/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000
      [Collection]
	,[DocumentType]
	  ,CASE [Collection]
		  WHEN 'Household' THEN
			CASE [DocumentType]
				WHEN 'Community Service File' THEN 'Community Service'
				WHEN 'EIV' THEN 'EIV'
				WHEN 'Familial File' THEN 'Familial File'
				WHEN 'Form HUD-50058' THEN 'HUD-50058'
				WHEN 'FSS' THEN 'FSS'
				WHEN 'General Inspection Form - Detail' THEN 'Inspection'
				WHEN 'Identification File' THEN 'Identification File'
				WHEN 'Landlord File' THEN 'Landlord File'
				WHEN 'Legal File' THEN ''
				WHEN 'LL Initial Contract' THEN 'Contracts'
				WHEN 'LL Inspection' THEN 'Inspection'
				WHEN 'LL Rent Increase' THEN 'Rent Increase'
				WHEN 'LL Transfer Contract' THEN 'Contracts'
				WHEN 'S8 Home Ownership' THEN 'S8 Home Ownership'
				WHEN 'T01-New Admission' THEN 'Certifications'
				WHEN 'T02-Annual' THEN 'Certifications'
				WHEN 'T03-Interim' THEN 'Certifications'
				WHEN 'T04-Port In' THEN 'Certifications'
				WHEN 'T05-Port Out' THEN 'Certifications'
				WHEN 'T06-End Participation' THEN 'Certifications'
				WHEN 'T07-Other Change of Unit' THEN 'Certifications'
				WHEN 'T08-FSS/WtW' THEN 'Certifications'
				WHEN 'T09-Annual Searching' THEN 'Certifications'
				WHEN 'T10-Issued Voucher' THEN 'Certifications'
				WHEN 'T11-Expired Voucher' THEN 'Certifications'
				WHEN 'T13-Inpsection' THEN 'Certifications'
				WHEN 'T14-Historical Adjustment' THEN 'Certifications'
				WHEN 'T15-Void' THEN 'Certifications'
				WHEN 'Tenant File' THEN 'Tenant File'
			END
		  WHEN 'Vendor' THEN 'Vendor'
		  WHEN 'Report' THEN ''
		  WHEN 'Unknown' THEN ''
		  ELSE ''
	  END AS YardiObject
	  ,CASE
			WHEN [AssetID] IS NOT NULL THEN [AssetID]
			WHEN [HouseholdID] IS NOT NULL THEN  [HouseholdID]
			WHEN [EmployeeID]  IS NOT NULL THEN  [EmployeeID]
			WHEN [UnitID] IS NOT NULL THEN [UnitID]
			WHEN [LandlordID] IS NOT NULL THEN [LandlordID]
			WHEN [VendorID]  IS NOT NULL THEN  LEFT([VendorNumber],1) + RIGHT([VendorID],LEN([VendorID])-3)
			WHEN [WorkOrderID]  IS NOT NULL THEN  [WorkOrderID]
			WHEN [IncidentID]  IS NOT NULL THEN  [IncidentID]
		END As [YardiObjectCode]
,CASE [Collection]
	WHEN 'Household' THEN [DocumentType] +
				CASE
					WHEN LTRIM(SUBSTRING([JobDescription], CHARINDEX(')',[JobDescription])+1,99)) = [DocumentType] THEN ''
					WHEN LEN(LTRIM(SUBSTRING([JobDescription], CHARINDEX(')',[JobDescription])+1,99)))>0 THEN ' (' +  RTRIM(LTRIM( SUBSTRING([JobDescription], CHARINDEX(')',[JobDescription])+1,99) )) + ')'
				ELSE
					''
				END
				+ ' (Tcode ' + [HouseholdID] + ')'
	WHEN 'Vendor' THEN [DocumentType] + ' (Vcode ' + LEFT([VendorNumber],1) + RIGHT([VendorID],LEN([VendorID])-3) + ')'
	WHEN 'Report' THEN [DataAreaDescription] + ' (' + [ReportTitle] + ')'
	WHEN 'Unknown' THEN
				CASE
					WHEN LEN(LTRIM([Description]))>0 THEN REPLACE(REPLACE([Description],'A-^',''),'.TIF',' ')
				ELSE
					'Unknow'
				END
				+
				CASE
					WHEN LEN(LTRIM(SUBSTRING([JobDescription], CHARINDEX(')',[JobDescription])+1,99)))>0 THEN ' (' +  RTRIM(LTRIM( SUBSTRING([JobDescription], CHARINDEX(')',[JobDescription])+1,99) )) + ')'
				ELSE
					' (Unknown)'
				END
	WHEN 'Asset' THEN [AssetNumber]
	ELSE
		CASE
			WHEN LEN(LTRIM([Title]))>0 THEN [Title]
			WHEN LEN(LTRIM([ReportTitle]))>0 THEN [ModuleCode] + '-' + [ReportTitle]
		ELSE 'Unknown'
		END
END
+ '.pdf'
As [YardiFilename]
,ChildOrder AS PagesInDoc
,CAST(S8Guid AS varchar(36)) + '.pdf' As [Filename]

--,[JobDescription]
      ,[ArchiveTime]
--	  ,CASE WHEN [AssetID] IS NULL THEN 'NULLER' ELSE STR([AssetID]) END AS TESTERNICK
--      ,[Status]
--      ,[JobType]
--      ,[JobDescription]
--      ,[EventMessage]
--      ,[EventTime]
--      ,[DocumentDate]
--,[Title]
	,CASE
		WHEN LEN(LTRIM([Title]))>0 THEN [Title]
		WHEN LEN(LTRIM([ReportTitle]))>0 THEN [ModuleCode] + '-' + [ReportTitle]
	END
	+
	CASE
		WHEN LEN(LTRIM([DocumentUser]))>0 THEN ' ( ' + [DocumentUser] +  ' )'
		WHEN LEN(LTRIM([ReportUser]))>0 THEN ' ( ' + [ReportUser] +  ' )'
	END
	+
	': '
	+
	CASE
		WHEN LEN(LTRIM([Notes]))>0 THEN [Notes]
		WHEN LEN(LTRIM([ReportNotes]))>0 THEN [ReportNotes]
		WHEN LEN(LTRIM([JobDescription]))>0 THEN RTRIM(LTRIM(SUBSTRING([JobDescription], CHARINDEX(')',[JobDescription])+1,99)))
	END AS DocumentNotes
	,CASE
		WHEN [HOHSSN] IS NOT NULL THEN [HOHSSN]
	END AS [HoH_SSN(TEST)]
	,CASE
		WHEN [HOHLastName] IS NOT NULL THEN [HOHLastName] + ',' + [HOHFirstName]
		WHEN [VendorLastName] IS NOT NULL THEN [VendorLastName] + ',' + [VendorFirstName]
	END AS [TenantOrVendorName(TEST)]
	   ,'http://hasctd1/members/GetPriPreview.aspx?PriGuid=' + CAST(PriGuid AS varchar(36)) AS 'FirstPageURL(TEST)'
--     ,[PurchaseDate]
--      ,[AssetID]
--      ,[AssetNumber]
--      ,[AssetType]

--      ,[CertificationDate]
--      ,[HOHSSN]
--      ,[MemberID]
--      ,[MemberFirstName]
--      ,[MemberSSN]
--      ,[MemberLastName]

/*** HR Module not used
      ,[EmployeeLastName]
      ,[EmployeeFirstName]
      ,[EmployeeID]
      ,[EmployeeNumber]
      ,[EmployeeSSN]
      ,[Zip]
      ,[StreetName]
      ,[City]
      ,[State]
***/
/*** Unit Tracking
      ,[UnitID]
      ,[UnitNumber]
      ,[StreetNumber]
      ,[ApartmentNumber]
***/
/*** Reporting
      ,[ReportDate]
      ,[ModuleCode]
      ,[ReportUser]
      ,[ReportTitle]
      ,[ReportNotes]
      ,[DataAreaID]
      ,[DataAreaDescription]
      ,[LandlordID]
      ,[PropID]
      ,[Owner]
***/
/*** Incident
      ,[IncidentID]
      ,[IncidentEventType]
      ,[Development]
      ,[Building]
      ,[Unit]
      ,[PoliceReportNumber]
      ,[TrespasserID]
      ,[PersonID]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[AliasNames]
      ,[Description]
***/
/*** Vendor
      ,[GrantID]
      ,[ContractID]
      ,[VendorFirstName]
      ,[DocumentReferenceNumber]
      ,[VendorID]
      ,[VendorNumber]
      ,[VendorLastName]
***/
/*** Work Order
      ,[WorkOrderRequestDate]
      ,[WorkOrderType]
      ,[PHASCode]
      ,[WorkOrderID]
      ,[WorkOrderNumber]
***/
  FROM [NowFORMS].[dbo].[DocumentsView]
  WHERE YEAR(ArchiveTime) = '2011'
/***
AND CASE
	  WHEN [AssetID] IS NOT NULL THEN [AssetID]
	 WHEN  [HouseholdID] IS NOT NULL THEN  [HouseholdID]
	 WHEN  [EmployeeID]  IS NOT NULL THEN  [EmployeeID]
	  WHEN [UnitID] IS NOT NULL THEN [UnitID]
	 WHEN  [LandlordID] IS NOT NULL THEN [LandlordID]
	 WHEN [VendorID]  IS NOT NULL THEN  LEFT([VendorID],1) + RIGHT([VendorID],LEN([VendorID])-3)
	 WHEN  [WorkOrderID]  IS NOT NULL THEN  [WorkOrderID]
	 	 WHEN  [IncidentID]  IS NOT NULL THEN  [IncidentID]
	   END
   IS NULL
   ORDER BY COllection
   ***/
