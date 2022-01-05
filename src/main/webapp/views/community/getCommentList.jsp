<%@ page import="com.ffin.service.domain.Comment" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="com.ffin.service.domain.Comment" %>

<html lang="ko">

<head>

    <title>댓글 목록 조회</title>
    <jsp:include page="../../common/lib.jsp"/>

    <!-- 참조 : http://getbootstrap.com/css/   참조 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

    <!-- ajax 모듈 -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

    <!--  ///////////////////////// JavaScript ////////////////////////// -->
    <script type="text/javascript">

        //============= "작성완료"  Event 연결 =============
        $(function () {
            //==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
            $("button.btn.btn-secondary").on("click", function () {
                fncAddPost();
            });
        });

        //============= "취소"  Event 처리 및  연결 =============
        $(function () {
            //==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
            $("a[href='#' ]").on("click", function () {
                self.location = "/views/community/getPostList.jsp"
            });
        });

        function fncAddPost() {
            // 유효성체크
            var title = $("input[name='postTitle']").val();
            var content = $("textarea[name='postContent']").val();

            if (title == null || title.length < 1) {
                alert("게시물 제목은 반드시 입력하셔야 합니다.");
                return;
            }
            if (content == null || content.length < 1) {
                alert("게시물 내용은 반드시 입력하셔야 합니다.");
                return;
            }
            $("form").attr("method", "POST").attr("action", "/community/addPost").attr("enctype", "multipart/form-data").submit();
            alert("게시물 작성이 완료되었습니다.");
        }

        //댓글 목록 출력 함수
        function listReply() {
            alert("listReply function excute");
            $.ajax({
                type   : "get", //get방식으로 자료를 전달한다
                url    : "/community/getCommentList?commentPostNo="+${post.postNo},
                data    : "commentList", //컨트롤러에 있는 list.do로 맵핑하고 게시판 번호도 같이 보낸다.
                success: function (result) { //자료를 보내는것이 성공했을때 출력되는 메시지
                    //result : responseText 응답텍스트(html)
                    console.log(result);
                    alert(result);
                    $("#listReply").html(result);
                    alert("댓글 출력");
                }
            });
        }

        $(function () {
            //댓글 쓰기 (버튼을 눌러서 id값이 넘어와 실행되는 자바스크립트 구문)
            $("#btnReply").click(function () {
                //alert("댓글쓰기를 클릭했다");
                var replytext = $("#commentContent").val(); //댓글 내용
                <%--var bno = "${post.postNo}"; //게시물 번호--%>
                var param = {"commentContent": replytext};
                //var param="replytext="+replytext+"&bno="+bno;

                if (replytext == null || replytext.length < 1) {
                    alert("댓글 내용은 반드시 입력하셔야 합니다.");
                    return;
                }

                $.ajax({
                    type   : "post", //데이터를 보낼 방식
                    url    : "/community/addComment", //데이터를 보낼 url
                    data   : param, //보낼 데이터
                    success: function () { //데이터를 보내는것이 성공했을시 출력되는 메시지
                        alert("댓글이 등록되었습니다.");
                        listReply(); //댓글 목록 출력
                    }
                });
            });
        })


    </script>

</head>


<body id="page-top">

<jsp:include page="/views/navbar.jsp"/>
<br/><br/><br/><br/><br/>

<div class="container">
                <div id="listReply">
                    <p>${comment.commentContent}</p>
                    읭?
                </div>
                <!-- 댓글 -->
                <div id="reply">
                    <ol class="replyList">
                        <c:forEach items="${commentList}" var="commentList">
                            <li>
                                <p>
                                    작성자 : ${comment.commentUserId}<br />
                                    작성자 : ${comment.commentTruckId}<br />
                                    작성 날짜 :  <fmt:formatDate value="${comment.commentDate}" pattern="yyyy-MM-dd" />
                                </p>

                                <p>${comment.commentContent}</p>
                            </li>
                        </c:forEach>
                    </ol>
                </div>
        </div>
        <!-- 댓글 목록 -->
        <!-- 댓글이 등록이 되면 listReply에 댓글이 쌓이게 된다 -->
        <%--        <div id="listReply">--%>
        <%--            ${comment.commentContent}--%>
        <%--        </div>--%>
        <%--        <!-- 댓글 -->--%>
        <%--        <div id="reply">--%>
        <%--            <ol class="replyList">--%>
        <%--                <c:forEach items="${commentList}" var="commentList">--%>
        <%--                    <li>--%>
        <%--                        <p>--%>
        <%--                            작성자 : ${comment.commentUserId}<br />--%>
        <%--                            작성자 : ${comment.commentTruckId}<br />--%>
        <%--                            작성 날짜 :  <fmt:formatDate value="${comment.commentDate}" pattern="yyyy-MM-dd" />--%>
        <%--                        </p>--%>

        <%--                        <p>${comment.commentContent}</p>--%>
        <%--                    </li>--%>
        <%--                </c:forEach>--%>
        <%--            </ol>--%>
        <%--        </div>--%>

</div>
<%--<jsp:include page="/views/footer.jsp"/>--%>

</body>

</html>
