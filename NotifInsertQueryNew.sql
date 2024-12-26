

use esourcingv5

go
create function ufn_checkInterviewDate(@reqresid bigint)
returns datetime
as
begin

return (select top 1 invdate from HC_REQ_RES_INTERVIEW_STAGES with(nolock) where reqresid=@reqresid)

end

go

create or alter  procedure usp_getApliedjobDetailsforNoti(
@inputObject nvarchar(max)
)
as
begin

declare @lastId bigint
declare @content nvarchar(max)
declare @query nvarchar(max)
declare @templateId bigint

set @lastId=isnull(json_value(@inputObject,'$.lastId'),0)
set @content=isnull(json_value(@inputObject,'$.content'),'')
set @templateId=isnull(json_value(@inputObject,'$.templateId'),0)
if(@lastId=0)
begin
set @lastId=(select top 1 rid from hc_req_resume_stage_status with(nolock) where StatusDate>dateadd(minute,-4,getutcdate()))
end

set @query=concat('select top 100  ',replace(@content,'(resid)','(hrb.rid)'),' hrb.rid as rid,hu.mobileNo as mobileNo,hrb.candidateNo as candidateNo from openjson(''[{"Mapping_id":8,"stageId":1,"statusId":44},{"Mapping_id":9,"stageId":1,"statusId":12},{"Mapping_id":10,"stageId":1,"statusId":53},{"Mapping_id":11,"stageId":4,"statusId":14},{"Mapping_id":12,"stageId":4,"statusId":14},{"Mapping_id":13,"stageId":4,"statusId":66},{"Mapping_id":13,"stageId":4,"statusId":9},{"Mapping_id":14,"stageId":4,"statusId":18},{"Mapping_id":15,"stageId":5,"statusId":77},{"Mapping_id":16,"stageId":5,"statusId":77},{"Mapping_id":17,"stageId":5,"statusId":22},{"Mapping_id":18,"stageId":5,"statusId":9}]'') with(Mapping_id bigint,stageId bigint,statusId bigint) t, HC_REQ_RESUME_STAGE_STATUS hrr with(nolock), hc_req_resume h with(nolock), hc_resume_bank hrb with(nolock), hc_requisitions hr with(nolock), hc_user_main hu with(nolock) where hrr.reqresid=h.rid and h.resid=hrb.rid and h.reqid=hr.rid and hrb.userid=hu.rid and t.stageId=hrr.StageID and t.statusId=hrr.StatusID  hrb.rid>',@lastId,' and isnull(hu.mobileNo,'''')<>'''' order by rid desc ');



end

go

use esourcingv5_new

go

insert into hc_notificationTemplateCategory values (1002,'40% after educationdetails','usp_getPercentageMappingForNotification',3,1,getutcdate(),1,1,getutcdate())
insert into hc_notificationTemplateCategory values (1003,'60% after experience details','usp_getPercentageMappingForNotification',3,1,getutcdate(),1,1,getutcdate())
insert into hc_notificationTemplateCategory values (1004,'Applied Job details','usp_getApliedjobDetailsforNoti',3,1,getutcdate(),1,1,getutcdate())


alter table hc_notificationoutBoxNew add notes nvarchar(200)


insert into hc_notificationTempCommTempMapping values(1000,1039,3,'7-1-540-[180]',75,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- 0% signup after 3hour for next 7 days

update hc_notificationTempCommTempMapping set condition='7-1-540-[180]' where notifTemplateId=1001 and contentTemplateId=1037  -- 20 % completed after profile page

insert into hc_notificationTempCommTempMapping values(1001,1040,3,'7-1-540-[60]',76,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- recommended job

insert into hc_notificationTempCommTempMapping values(1002,1041,1,'7-1-540-[180]',77,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- 40% education info added 

insert into hc_notificationTempCommTempMapping values(1003,1042,1,'7-1-540-[180]',78,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- 60% experience section added

insert into hc_notificationTempCommTempMapping values(1004,1044,1,'1-0-0',79,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- Applied Job

insert into hc_notificationTempCommTempMapping values(1004,1045,1,'1-0-0',80,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- shortlist

insert into hc_notificationTempCommTempMapping values(1004,1046,1,'1-0-0',81,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- shortlist

insert into hc_notificationTempCommTempMapping values(1004,1047,1,'1-0-0',82,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- interview Schedule
insert into hc_notificationTempCommTempMapping values(1004,1048,1,'7-1-0',82,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- interview reminder

insert into hc_notificationTempCommTempMapping values(1004,1049,1,'1-0-0',82,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- interview selected
insert into hc_notificationTempCommTempMapping values(1004,1050,1,'1-0-0',82,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- interview rejected
insert into hc_notificationTempCommTempMapping values(1004,1051,1,'1-0-0',82,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- intervirew no show

insert into hc_notificationTempCommTempMapping values(1004,1052,1,'1-0-0',82,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- offer sent
insert into hc_notificationTempCommTempMapping values(1004,1053,1,'1-1-0',82,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- offer reminder 1
insert into hc_notificationTempCommTempMapping values(1004,1054,1,'1-2-0',82,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- offer reminder 2
insert into hc_notificationTempCommTempMapping values(1004,1055,1,'1-3-0',82,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- offer reminder 3
insert into hc_notificationTempCommTempMapping values(1004,1056,1,'1-0-0',82,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- offer Selected
insert into hc_notificationTempCommTempMapping values(1004,1057,1,'1-0-0',82,1,'','',1,1,getutcdate(),1,1,getutcdate())  -- Offer Rejected













