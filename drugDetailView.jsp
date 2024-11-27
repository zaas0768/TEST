<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/ubiplus/weblock/common/commImport.jsp" %>
<%
// 처방정보 등록 화면
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

    <!-- Header -->
    <header id="header" class="tit_bdr_bttm">
        <h1 class="blind">WeHealth</h1>
        <fmt:parseDate value="${SDATE}" var="sdate" pattern="yyyyMMdd"/>
        <h2 class="title"><fmt:formatDate value="${sdate}" pattern="yyyy-MM-dd"/></h2>
        <a href="#" class="btn_back" onclick="history.back();">뒤로가기</a>
    </header>
    <!-- //Header -->
    <!-- Container -->
    <div id="container">
        <!-- Content -->
        <section id="content" class="inner_pd"  style="padding-top: 60px;">
        	<!-- 처방전 없을 경우 보여줌. -->
<%-- 			<c:if test="${ATCH_FILE_ID eq '' || ATCH_FILE_ID eq null}"> --%>
<!-- 				<div class="bd_cont no_pd" id="div_preReg"> -->
<!-- 	                <button class="btn_md btn_grey" type="button" onclick="fn_movePreRegView();">처방전 등록</button> -->
<!-- 	            </div> -->
<%--         	 </c:if> --%>

<!-- 			<!-- 처방전 있을 경우 보여줌. --> 
<%-- 			<c:if test="${ATCH_FILE_ID ne '' && ATCH_FILE_ID ne null}"> --%>
<!-- 				 <div class="bd_cont no_pd" id="div_preReg" style="display: none;"> -->
<!-- 	                <button class="btn_md btn_grey" type="button" onclick="fn_movePreRegView();">처방전 등록</button> -->
<!-- 	            </div> -->
<!-- 	        	 <div class="bd_cont no_pd"> -->
<!-- 	                <div class="img_area" id="img_area"> -->
<%-- 	               	 	<img id="imgWrap" name="imgWrap" style="width: 100%;" src="${cPath}/weblock/getImage.do?atchFileId=${ATCH_FILE_ID}"> --%>
<!-- 	                </div> -->
<!-- 	                <button class="btn_md btn_grey" type="button" id="btnDel" onclick="fn_delImg();">처방전삭제</button> -->
<!-- 	            </div> -->
<%-- 			</c:if> --%>
        
        	<!-- 복약 해야 할 경우 -->
			<c:if test="${isDrugYoil eq true}">
				<div class="txt_cmt" style="padding-bottom: 60px;">
	                <p>복약할 약이 있습니다. 복약 후 복약 완료에 체크해 주세요.</p>
	                <label class="chk_custom">
	                    <input type="checkbox" name="drugYn"  <c:if test="${USER_DRUG_ID ne ''}">checked</c:if> >
	                    <span class="checkmark"></span>
	                    복약완료
	                </label>
	            </div>
             </c:if>
        </section>
        <!-- //Content -->
        <div class="btn_btm_fix" id="div_btn">
            
            <!-- 복약 해야 할 경우만 보임 -->
            <c:if test="${isDrugYoil eq true }">
	            <button class="btn_lg_half btn_grey" type="button" onclick="history.back();">취소</button>
            	<button class="btn_lg_half btn_blue" type="button" onclick="fn_regDrugYn();">확인</button>
           	</c:if>
           	<c:if test="${isDrugYoil ne true }">
           		<button class="btn_lg btn_grey" type="button" onclick="history.back();">취소</button>
           	</c:if>
        </div>
    </div>
    <!-- //Container -->
</body>


<script type="text/javascript">
// 전역변수
var global = {
		ATCH_FILE_ID : '${ATCH_FILE_ID}'
		,PRESCRIPT_ID : '${PRESCRIPT_ID}'
}


$(function(){
	// 처방전 보여주기
	fn_showPrescript();
});

// 처방전 보여주기
function fn_showPrescript(){
	
	var param = {
			USER_ID : '${USER_ID}'
			,SDATE : '${SDATE}'
	};
	ajaxUtil.callJsonString("${cPath}/medi/getMeasFileInfoAjax.do", JSON.stringify(param), succMeasFileInfoCallback);
	
	// 콜백함수
	function succMeasFileInfoCallback(response) {
		console.log(response);
		var res = response.res;
		
		var atchFileId = "";
		if (res != null) {
			atchFileId = res.ATCH_FILE_ID;
			global.ATCH_FILE_ID = atchFileId;
			global.PRESCRIPT_ID = res.PRESCRIPT_ID;
		} else {
			global.ATCH_FILE_ID = "";
			global.PRESCRIPT_ID = "";
		}
		
		var html = "";
		// 처방전 없을 경우 등록버튼 보이기
		if (atchFileId == "") {
			html += "<div class='bd_cont no_pd' id='div_preReg'>";
			html += 	"<button class='btn_md btn_grey' type='button' onclick='fn_movePreRegView();'>처방전 등록</button>";
			html += "</div>";
		} else { // 있을경우 처방전 보여줌
			html += "<div class='bd_cont no_pd' id='div_preReg' style='display: none;'>";
			html += 	"<button class='btn_md btn_grey' type='button' onclick='fn_movePreRegView();'>처방전 등록</button>";
			html += "</div>";
			html += "<div class='bd_cont no_pd'>";
			html += 	"<div class='img_area' id='img_area'>";
			html += 		"<img id='imgWrap' name='imgWrap' style='width: 100%;' src='${cPath}/weblock/getImage.do?atchFileId=" + atchFileId +"'>";
			html += 	"</div>";
			html += 	"<button class='btn_md btn_grey' type='button' id='btnDel' onclick='fn_delImg();'>처방전삭제</button>";
			html += "</div>";
		}

		$("#content").prepend(html);
	}
	
};

// 복약 여부 등록/수정 묻기
function fn_regDrugYn() {
	// 복약 체크 여부 
	var isChecked = $("input[name=drugYn]").prop("checked");
	if (confirm("복약 여부를 저장하시겠습니까?")) {
		if (isChecked) { // 선택시 'Y'
			fn_insDrugYnAjax(); // 복약 여부 등록
		} else {
			fn_delDrugYnAjax(); // 복약 여부 삭제
		}
	}
};

//복약 여부 등록
function fn_insDrugYnAjax() {
	// 측정일자 시간,분,초계산
	var date = new Date();
	var hour = date.getHours();
	var minute = date.getMinutes();
	var second = date.getSeconds();
	
	if (hour < 10) {
		hour = "0"+hour;
	}
	if (minute < 10) {
		minute = "0"+minute;
	}
	if (second < 10) {
		second = "0"+second;
	}
	
	var param = JSON.stringify({
		USER_ID : '${USER_ID}'
		,USER_DRUG_ID : '${USER_DRUG_ID}'
		,MEASURE_DT : "${MEASURE_DT} " + hour +":" + minute +":"+second
	});
	ajaxUtil.callJsonString("${cPath}/medi/insDrugYnAjax.do", param, succInsDrugYnAjaxCallback);
	
	// 복약 여부 등록 응답성공 콜백
	function succInsDrugYnAjaxCallback(response) {
// 		console.log(response);
		// 복약 관리화면 이동
		history.back();
	}
}

// 복약 여부 삭제
function fn_delDrugYnAjax() {
	// 아무것도 선택안하고 확인시
	if ("" == '${USER_DRUG_ID}') {
		// 복약 관리화면 이동
		location.href = "${cPath}/medi/getDrugMngView.do?USER_ID=${USER_ID}&DID_SESSION_ID=${DID_SESSION_ID}";
		return;
	};
	
	var param = JSON.stringify({
		USER_ID : '${USER_ID}'
		,USER_DRUG_ID : '${USER_DRUG_ID}'
	});
	ajaxUtil.callJsonString("${cPath}/medi/delDrugYnAjax.do", param, succDelDrugYnAjaxCallback);
	
	// 복약 여부 삭제 응답성공 콜백
	function succDelDrugYnAjaxCallback(response) {
// 		console.log(response);
		// 복약 관리화면 이동
		history.back();
	}
}


// 처방전 등록 화면 이동
function fn_movePreRegView() {
	var measureDt = '${MEASURE_DT}';
	location.href = "${cPath}//medi/getPreRegView.do?USER_ID=${USER_ID}&MEASURE_DT="+measureDt.replaceAll("-", "")+"&DID_SESSION_ID=${DID_SESSION_ID}";
};

// 처방전 삭제
function fn_delImg() {
	
	// 알림 문구
	if(!confirm("등록된 처방전을 삭제하시겠습니까?")) {
		return;
	}
	
	// 해당 미사용으로 변경 후 처방전 정보에서 FILE ID 지움.
	var param = JSON.stringify({
		ATCH_FILE_ID : global.ATCH_FILE_ID
		,USER_ID : '${USER_ID}'
		,PRESCRIPT_ID : global.PRESCRIPT_ID
	});
	ajaxUtil.callJsonString("${cPath}/medi/delPrescriptFileAjax.do", param, succDelPrescriptFileCallback);
	
	// 처방전 삭제 응답성공 콜백
	function succDelPrescriptFileCallback(response) {
// 		console.log(response);
		if (response.result == 1) {
			// 이미지 미리보기 영역 제거
			$("#img_area").remove();
			
			// 처방전 삭제 버튼 숨김
			$("#btnDel").css("display", "none");
			
			// 처방전 정보 등록 버튼 보이기
			$("#div_preReg").css("display", "block");
		} // if
	}
	
};

</script>

</html>