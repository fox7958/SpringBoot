<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:forward page="/board.do"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script type="text/javaScript" language="javascript" defer="defer">
	function main(){
		location.href = "/board.do";
	}
	setTimeout(main,3000);
</script>
<title>Insert title here</title>
</head>
<body>
	<h1>jsp야야야</h1>
</body>
</html>