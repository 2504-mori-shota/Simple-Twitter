<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
	<head>
	 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

	<title>簡易Twitter</title>
	 <link href="./css/style.css" rel="stylesheet" type="text/css">
	</head>
	<body>

	    <div class="main-contents">
	            <div class="header">
	            <c:if test="${ empty loginUser }">

	                <a href="login">ログイン</a>
	                <a href="signup">登録する</a>
	            </c:if>
	   			<c:if test="${ not empty loginUser }">
	        	<a href="./">ホーム</a>
	        	<a href="setting">設定</a>
	        	<a href="logout">ログアウト</a>
	    		</c:if>

	            </div>

	            <c:if test="${ not empty loginUser }">
	    		<div class="profile">
	        	<div class="name"><h2><c:out value="${loginUser.name}" /></h2></div>
	        	<div class="account">@<c:out value="${loginUser.account}" /></div>
	        	<div class="description"><c:out value="${loginUser.description}" /></div>
	    		</div>
				</c:if>

				<c:if test="${ not empty errorMessages }">
	    			<div class="errorMessages">
	        			<ul>
	            			<c:forEach items="${errorMessages}" var="errorMessage">
	                			<li><c:out value="${errorMessage}" />
	            			</c:forEach>
	        			</ul>
	    			</div>
	    			<c:remove var="errorMessages" scope="session" />
				</c:if>

				<div class="dates">
					<form action="./" method="get">
						日付検索<input type="date" name="start_date" max="2100-12-31" min="2020-01-01" value="${start }">～<input type="date" name="end_date" max="2100-12-31" min="2020-01-01" value="${end }">
						<input type="submit" value="検索">
					</form>
				</div>
				<div class="form-area">
	    			<c:if test="${ isShowMessageForm }">
	        			<form action="message" method="post">
	            			いま、どうしてる？<br />
	            			<textarea name="text" cols="100" rows="5" class="tweet-box"></textarea>
	            			<br />
	            			<input type="submit" value="つぶやく">（140文字まで）
	        			</form>
	    			</c:if>
				</div>


				<div class="messages">
	    			<c:forEach items="${messages}" var="message">
			 			<div class="message">
	 						<div class="account-name">
					 			<span class="account">
						 			<a href="./?user_id=<c:out value="${message.userId}"/> ">
						 				<c:out value="${message.account}" />
						 			</a>
								</span>
					 			<span class="name"><c:out value="${message.name}" /></span>
							</div>
		            		<div class="text"><pre><c:out value="${message.text}" /></pre></div>
		            		<div class="date"><fmt:formatDate value="${message.createdDate}" pattern="yyyy/MM/dd HH:mm:ss" /></div>
							<!-- ログイン後に以下のボタンが表示されるようにする -->
							<c:if test="${ isShowMessageForm }" >
								<div class="comments">
									<form action="comment" method="post">
										<input name="id" value="${message.id}" type="hidden"/>
										<textarea name="text" cols="100" rows="5" class="tweet-box"></textarea>
								 		<br />
			            				<input type="submit" value="返信">（140文字まで）
									</form>
								</div>
								<c:if test="${message.userId == loginUser.id }"><!-- 追加した条件分岐 -->
									<form action="edit" method="get">
										<input name="id" value="${message.id}" type="hidden"/>
										<input type="submit" value="編集">
									</form>
					 				<form action="deleteMessage" method="post">
					 					<input name="id" value="${message.id}" type="hidden"/>
					 					<input type="submit" value="削除">
					 				</form>
					 			</c:if>
							</c:if>
							<c:forEach items="${comments }" var="comment">
								<c:if test="${comment.messageId == message.id }">
									<div class="account-name">
							 			<span class="account"><c:out value="${comment.account}" /></span>
							 			<span class="name"><c:out value="${comment.name}" /></span>
									</div>
					            	<div class="text"><pre><c:out value="${comment.text}" /></pre></div>
					            	<div class="date"><fmt:formatDate value="${comment.createdDate}" pattern="yyyy/MM/dd HH:mm:ss" /></div>
			 					</c:if>
			 				</c:forEach>
			 			</div>
	    			</c:forEach>
				</div>


				<div class="copyright"> Copyright(c)Shota Mori</div>
			</div>



	</body>
</html>