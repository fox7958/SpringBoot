<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt"		uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form"	uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring"	uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>">
<script src="<c:url value='/resources/js/jquery-3.6.0.min.js'/>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'/>"></script>
<script type="text/javaScript" language="javascript" defer="defer">
$(document).ready(function(){
	list();
});
function list(){
	$.ajax({
		url: "<c:url value='/list.do'/>",
		processData: false,
		contentType: false,
		method: "GET",
		cache: false,
		data: ''
	}).done(function(data){
		$('#list').children().remove();
		for(var i = 0; i < data.list.length; i++){
			var contents = data.list[i].contents;
			contents = contents.replace(/\n/gi, '\\n');
			var txt = "<tr onclick=\"detail('"+data.list[i].id+"','"+data.list[i].title+"','"+contents+"');\">";
			txt += "<td>" + data.list[i].title + "<span style=\"float:right\">"+ data.list[i].date +"</td>";
			txt += "</tr>"
			$('#list').append(txt);
		}
		alert(data.list.length);
	}).fail(function(jqXHR, textStatus, errorThrown){
		alert("오류:"+errorThrown);
	});
}
function detail(id, title, contents){
	$('#title').val(title);
	$('#content').val(contents);
	$('#id').val(id);
}
function save(){
	if(!confirm("저장하시겠습니까?")){
		return;
	}
	
	var formData = new FormData();
	formData.append('id', $('#id').val());
	formData.append('title', $('#title').val());
	formData.append('content', $('#content').val());
	
	if($('#id').val() == ''){
		url = "<c:url value='/add.do'/>";
	}else{
		url = "<c:url value='/mod.do'/>"
	}
	
	$.ajax({
		url: url,
		processData: false,
		contentType: false,
		method: "POST",
		cache: false,
		//data: $('#form1').serialize()
		data: formData
	}).done(function(data){
		if(data.returnCode == 'success'){
			list();
			console.log('data === ', data);
		}else{
			alert(data.returnDesc);
		}
	}).fail(function(jqXHR, textStatus, errorThrown){
		alert("오류:"+errorThrown);
	});
}
function cancel(){
	$('#title').val('');
	$('#content').val('');
}
function del(){
	if($('#id').val() == ''){
		alert("삭제할 데이터가 없습니다.");
	}
	
	if(!confirm("삭제하시겠습니까?")){
		return;
	}
	
	var formData = new FormData();
	formData.append('id', $('#id').val());
	
	$.ajax({
		url: "<c:url value='/del.do'/>",
		processData: false,
		contentType: false,
		method: "POST",
		cache: false,
		//data: $('#form1').serialize()
		data: formData
	}).done(function(data){
		if(data.returnCode == 'success'){
			list();
			console.log('data === ', data);
		}else{
			alert(data.returnDesc);
		}
	}).fail(function(jqXHR, textStatus, errorThrown){
		alert("오류:"+errorThrown);
	});
}
function delimg(){
	alert('delimg');
}
</script>
</head>
<body>
	<div class="card">
		<div class="card-header">SpringBoot + MongoDB + BootStrap 게시판 만들기</div>
		<div class="card-body">
			<div class="row">
				<div class="col-md-4">
					<div class="card" style="min-height:500px;max-height:500px">
						<table class ="table">
							<thead>
								<tr>
									<th>게시물 리스트</th>
								</tr>
							</thead>
							<tbody id="list">
								<tr>
									<td>안녕하세요.</td>
								</tr>
								<tr>
									<td>반값습니다.</td>
								</tr>
								<tr>
									<td>고맚습니다.</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="col-md-5">
					<div class="card" style="min-height:500px;max-height:800px">
						<form id="form" name="form1" action="">
							<div class="form-group">
								<label class="control-label" for="title">제목 : </label>
								<div>
									<input type="text" class="form-control" id="title" placeholder="제목을 입력하세요">
								</div>
							</div>
							<div class="form-group">
								<label class="control-label" for="contents">내용 :</label>
								<div>
									<textarea class="form-control" rows="15" id="content"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label class="control-label">이미지 첨부 : jpg, gif, png</label>
								<div>
									<input type="file" class="form-control" name="file" ref="file" style="width:80%" />
								</div>
							</div>
							<input type="hidden" id="id" name="id"/>
						</form>
						<div style="text-align:center">
							<div class="btn-group">
								<button type="button" class="btn btn-primary" onclick="save()">저장</button>
								<button type="button" class="btn btn-default" onclick="cancel()">취소</button>
								<button type="button" class="btn btn-default" onclick="del()">삭제</button>
								<button type="button" class="btn btn-default" onclick="delimg()">그림삭제</button>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-3">
					<div class="card bg-light text-dark" style="min-height:500px;max-height:1000px">이미지 미리보기</div>
				</div>
			</div>
		</div>
		<div class="card-footer">강의자료는 여기에 있습니다.</div>
	</div>
</body>
</html>