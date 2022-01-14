<%@ page contentType="text/html; charset=utf-8" %>
<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="ko">


<head>

    <title>F.FIN | 회원목록 </title>
    <jsp:include page="../../common/lib.jsp"/>

    <!-- bootstrap core css -->
    <link rel="stylesheet" type="text/css" href="../../resources/bootstrap/css/bootstrap.css" />
    <!-- Custom styles for this template -->
    <link href="../../resources/bootstrap/css/style.css" rel="stylesheet" />

    <!--    Favicons-->
    <link rel="apple-touch-icon" sizes="180x180" href="../../resources/bootstrap/assets/favicons/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="../../resources/bootstrap/assets/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="../../resources/bootstrap/assets/favicons/favicon-16x16.png">
    <link rel="shortcut icon" type="image/x-icon" href="../../resources/bootstrap/assets/favicons/favicon.ico">
    <link rel="manifest" href="../../resources/bootstrap/assets/favicons/manifest.json">
    <meta name="msapplication-TileImage" content="../../resources/bootstrap/assets/favicons/mstile-150x150.png">
    <meta name="theme-color" content="#ffffff">

    <style>

        .search{
            margin-top: 100px;
        }

        #dataTable thead tr th, #dataTable tbody tr td{
            text-align: center;
        }

        #dataTable tbody tr:hover{
            color: #ffba49;
        }

        .form-inline{
            float: right;
            padding-right: 20px;
        }

    </style>

    <script type="text/javascript">

        $(function () {

            $('.userInfo').click(function () {

                var userId = $(this).find("input[name='userId']").val();
                alert(userId);
                self.location ="/user/getUser?userId="+userId;
            });
        });

        function fncGetUserList(currentPage) {
            $("#currentPage").val(currentPage)
            $("form").attr("method" , "POST").attr("action" , "/user/getUserList").submit();
        }


    </script>

</head>

<body>
    <jsp:include page="/views/navbar.jsp" />
    <div style="height: auto">
        <jsp:include page="/views/user/sidebar.jsp" />
    </div>

<section class="client_section layout_padding">

    <div class="container">
        <div class="col-md-12 col-lg-12 mx-auto">

            <div class="detail-box">
                <i class="fa fa-quote-left" aria-hidden="true" style="color: #f17228;"></i>
                <h4 style="margin-top: 10px;">
                    회원목록
                </h4>
            </div>

            <div class="row search">
                <div class="col-md-6 text-left" style="display: flex; align-items: center;">
                    <p style="margin: 0; font-size: 12px;">
                        전체  ${resultPage.totalCount } 건수, 현재 ${resultPage.currentPage}  페이지
                    </p>
                </div>

                <div class="col-md-6 text-right">
                    <form class="form-inline" name="detailForm" style="padding: 0;">

                        <div class="form-group">
                            <select class="form-control" name="searchCondition" >
                                <option value="0"  ${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>ID</option>
                                <option value="1"  ${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>답변여부</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="sr-only" for="searchKeyword">검색어</label>
                            <input type="text" class="form-control" id="searchKeyword" name="searchKeyword"  placeholder="검색어"
                                   value="${! empty search.searchKeyword ? search.searchKeyword : '' }"  >
                        </div>

                        <button type="button" class="btn btn-default">검색</button>

                        <!-- PageNavigation 선택 페이지 값을 보내는 부분 -->
                        <input type="hidden" id="currentPage" name="currentPage" value=""/>

                    </form>
                </div>
            </div>

            <div class="card" style="border: 0;">
                <div class="card-body">

                    <div class="table-responsive">
                        <table class="table" id="dataTable" width="100%" cellspacing="0">

                            <thead>
                                <tr>
                                    <th>Id</th>
                                    <th>성명</th>
                                    <th>연락처</th>
                                    <th>가입일</th>
                                    <th>신고횟수</th>
                                </tr>
                            </thead>

                            <tbody>

                            <c:set var="i" value="0" />
                            <c:forEach var="user" items="${list}">
                                <c:set var="i" value="${ i+1 }" />
                                <tr class="userInfo">
                                    <input type="hidden" id="userId" name ="userId" value="${user.userId}">
                                    <td class="userInfo-id">${user.userId}</td>
                                    <input type="hidden" value="${user.userId}">
                                    <td>${user.userName}</td>
                                    <td>${user.userPhone}</td>
                                    <td>${user.userRegDate}</td>
                                    <td>${user.reportCount}</td>
                                </tr>
                            </c:forEach>

                            </tbody>

                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>

</section>
    <jsp:include page="../../common/pageNavigator_new.jsp"/>
    <jsp:include page="/views/footer.jsp" />
</body>
</html>