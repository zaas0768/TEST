<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/ubiplus/weblock/common/commImport.jsp" %>
<%
// 복얄알림 등록
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
    <title>WeHealth</title>
<!--     <script src="../static/js/jquery.mCustomScrollbar.js"></script> -->
</head>

<body>
	
	<!-- common -->
	<jsp:include page="/WEB-INF/jsp/ubiplus/common/weblockComm.jsp"></jsp:include>
	<!-- // common -->
	 
    <!-- Container -->
    <div id="container">
        <!-- Content -->
        <section id="content" class="inner_pd">
        	<form id="regForm" method="post">
	            <div class="row">
	                <label for="nameMdc" class="tit">의약품명</label>
	                <div class="fm_line"><input type="text" id="DRUG_DESC" name="DRUG_DESC" class="input_type" value=""></div>
	            </div>
	            <div class="row">
	                <label for="slctDt" class="tit">날짜</label>
	                <div class="radio_row">
	                    <label class="radio_custom">
	                        <input type="radio" checked="checked" id="slctDt" name="rd_gubun" value="all" checked>
	                        <span class="checkmark"></span>
	                        매일
	                    </label>
	                    <label class="radio_custom">
	                        <input type="radio" id="slctDt" name="rd_gubun" value="yoil">
	                        <span class="checkmark"></span>
	                        요일선택
	                    </label>
	                </div>
	                <ul class="slct_week">
	                    <li><button class="day_week on" type="button" name="chk_yoil" value="MON">월</button></li>
	                    <li><button class="day_week on" type="button" name="chk_yoil" value="TUE">화</button></li>
	                    <li><button class="day_week on" type="button" name="chk_yoil" value="WED">수</button></li>
	                    <li><button class="day_week on" type="button" name="chk_yoil" value="THU">목</button></li>
	                    <li><button class="day_week on" type="button" name="chk_yoil" value="FRI">금</button></li>
	                    <li><button class="day_week on" type="button" name="chk_yoil" value="SAT">토</button></li>
	                    <li><button class="day_week on" type="button" name="chk_yoil" value="SUN">일</button></li>
	                </ul>
	            </div>
	            <div class="row">
	                <label for="nameMdc" class="tit">시간</label>
	                <div class="slec_line_third">
	                    <select name="sbx_timeGubun">
	                        <option value="COM075">오전</option>
							<option value="COM076" selected>오후</option>
	                    </select>
	                </div>
	                <div class="slec_line_third">
	                    <select name="sbx_hour">
	                        <option value="" selected>시</option>
							<c:forEach var="list" items="${hourList}" varStatus="status">
								<option value="${list.CODE}">${list.CODE_NM}</option>
							</c:forEach>
	                    </select>
	                </div>
	                <div class="slec_line_third">
		                <select name="sbx_minute">
							<option value="" selected>분</option>
							<c:forEach var="list" items="${minuteList}" varStatus="status">
								<option value="${list.CODE}">${list.CODE_NM}</option>
							</c:forEach>
						</select>
					</div>
	            </div>
	            
	            <input type="hidden" name="SUN"> 	<!-- 일요일 -->	
				<input type="hidden" name="MON"> 	<!-- 월요일 -->	
				<input type="hidden" name="TUE"> 	<!-- 화요일 -->	
				<input type="hidden" name="WED"> 	<!-- 수요일 -->	
				<input type="hidden" name="THU"> 	<!-- 목요일 -->	
				<input type="hidden" name="FRI"> 	<!-- 금요일 -->	
				<input type="hidden" name="SAT"> 	<!-- 토요일 -->	
				<input type="hidden" name="ALARM_TIME"> 	<!-- 알람시간 -->	
				<input type="hidden" name="USER_ID" value="${USER_ID}"> 	<!-- 회원ID -->	
            </form>
        </section>
        <!-- //Content -->
        <div class="btn_btm_fix">
        	<c:if test="${device == 'android' }">
	            <button class="btn_lg_half btn_grey" type="button" onclick="fn_goViewFinish();">취소</button>
        	</c:if>
        	<c:if test="${device == 'web' }">
	            <button class="btn_lg_half btn_grey" type="button" onclick="history.back();">취소</button>
        	</c:if>
            <button class="btn_lg_half btn_blue" type="button" onclick="fn_regDrugAlarm();">확인</button>
        </div>
    </div>
    <!-- //Container -->
</body>

<script type="text/javascript">

$(function(){
	// 날짜 구분(모두/요일) 선택.
	$("input[name=rd_gubun]").on("change", function(){
		// 모두 선택시 모든 요일 체크.
		if ("all"==this.value) {
			$(".day_week").addClass("on");
		} else if ("yoil"==this.value) {
			$(".day_week").removeClass("on");
		}
	});
	
	// 요일 선택시 선택한 요일 CSS적용
	$(".day_week").on("click", function(){
		// on -> off
		if ($(this).hasClass("on")) {
			$(this).removeClass("on");
		} else { // off -> on
			$(this).addClass("on");
		}
	});
	
	// 시간 구분(오전/오후) 선택시 시간 목록 조회
	$("select[name=sbx_timeGubun]").on("change", function(){
		var param = JSON.stringify({
			CODE_ID : this.value
		});
		ajaxUtil.callJsonString("${cPath}/medi/getHourAjax.do", param, succGetHourCallback);
		
		// 시간 조회 성공 콜백
		function succGetHourCallback(response) {
			console.log(response);
			
			var hourList = response.hourList;
			var hourHtml = "<option value=''>시</option>";
			$(hourList).each(function(i,e){
				hourHtml += "<option value='" + e.CODE + "'>" + e.CODE_NM +"</option>";
			});
			$("select[name=sbx_hour]").html(hourHtml);
		};
	});
});



//복약 알림 등록
function fn_regDrugAlarm() {
	
	var form = $("#regForm")[0];
	
	// 약품명 저장
	if (form.DRUG_DESC.value =="") {
		alert("의약품명을 입력해주세요.");
		form.DRUG_DESC.select();
		return;
	}
	
	// 요일 필수 선택
	if ($("button[class='day_week on']").length == 0) {
		alert("요일을 최소 한개 이상 선택해 주세요.");
		return;
	}
	
	// 선택 요일 저장
	var yoil = $("button[class^=day_week]"); // 요일 버튼
	$(yoil).each(function(i,e){
		// 체크된건 'Y'
	    if ($(e).hasClass("on")) {
	    	form[e.value].value = "Y";
	    } else {
	    	form[e.value].value = "N";
	    }
	});
	
	// 시간 저장
	var hour = $("select[name=sbx_hour]").val();
	var minute = $("select[name=sbx_minute]").val();
	if ( hour=="" || minute =="") {
		alert("시간을 선택해주세요.");
		return;
	}
	form.ALARM_TIME.value = hour+":"+minute;
	
	ajaxUtil.callJson("${cPath}/medi/upsertDrugAlarmAjax.do", $("#regForm"), succUpsertDrugAlarmCallback);
	
	// 복약 알림 등록 성공 콜백
	function succUpsertDrugAlarmCallback(response) {
		console.log(response);
		if ('${device}' == 'android') {
			fn_goViewFinish();
		} else if ('${device}' == 'web') {
			history.back();
		}
	}
};

</script>

</html>