<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>메뉴 관리 페이지</title>
    <jsp:include page="../../common/lib.jsp"/>

    <style>
        .div.flex.card.h-100{
            float:left;
            height:500px;
        }
        .card-body{
            height:301px;
        }
        .container-fluid{

            margin-right:142px;
            padding-left:190px;
        }
    </style>



    <style>

        .truckNameForMenu{
            color:black;
            font-weight: bolder;
            text-align: center;
        }
    </style>

    <script>

        //모달에서 메뉴 추가 버튼 클릭 시
        $(function(){

            $('#add-menu').on("click", function(){

                fncAddMenu();

            });

        });

        function fncAddMenu(){

            alert("optionGroup개수 : " +$('input#optionGroupName.form-control').length);

            if($('input#optionGroupName.form-control').length==0){
                $("form").attr("method", "POST").attr("action","/menu/addMenu").attr("enctype", "multipart/form-data").submit();
            }else{
                $("form").attr("method", "POST").attr("action","/menu/addMenuOptionGroup").attr("enctype", "multipart/form-data").submit();

            }


        }

        function applyOptionGroupNamer(){ // 모달에서 옵션그룹이름 적용누르면 돌아가는 function

            var modal = $('#optionGroupModal');
            realOptionGroupName = modal.find('input#optionGroupName.form-control').val();

            console.log(realOptionGroupName + " : realOptionGroupName");
            //alert(realOptionGroupName)

            // divElem = "<div class=\"form-group\" id=\""+realOptionGroupName+"-target\" name=\"optionGroupName\">"+
            //     "<input type=\"text\" id=\"applyOptionGroupName+"+realOptionGroupName+"\" name=\"applyOptionGroupName\" value=\""+realOptionGroupName+"\"/>22222"+
            //     "</div>";


            divElem = "<input type=\"hidden\" id=\"applyOptionGroupName+"+realOptionGroupName+"\" name=\"applyOptionGroupName\" value=\""+realOptionGroupName+"\"/>";

            // alert("applyOptionGroupName을 name으로 가진 태그가 있는가 ??? 있다면 몇 개?"+modal.find('input[name="applyOptionGroupName"]').length);

            //옵션그룹이름이 정해지지 않았다면
            if(modal.find('input[name="applyOptionGroupName"]').length!==0) {
                modal.find('input[name="applyOptionGroupName"]').val(realOptionGroupName);
            }else{
                modal.find('.modal-body').append($(divElem));
            }




        }





        $(function(){


            var modalOp = $('#optionModal');


            modalOp.find('button.btn.btn-primary.addOption').on("click", function(){
                //countOp++;

                var realOptionName = modalOp.find('input#optionName.form-control').val();
                var realOptionPrice = modalOp.find('input#optionPrice.form-control').val();

                console.log(realOptionName +" : realOptionName");
                console.log(realOptionPrice +" : realOptionPrice");

                divElemOp ="</hr>"+
                    "<div class=\"form-group\" id=\""+realOptionName+"\" name=\"optionName\">"+
                    "<div class=\"col-xs-8 col-md-4\">"+"옵션 이름 : "+realOptionName+"</div>"+
                    "<input type=\"hidden\" id=\"applyOptionName+"+realOptionName+"\" name=\"applyOptionName\" value=\""+realOptionName+"\"/>"+
                    "<div class=\"col-xs-8 col-md-4\">"+"옵션 가격 : "+realOptionPrice+"</div>"+
                    "<input type=\"hidden\" id=\"applyOptionPrice+"+realOptionPrice+"\" name=\"applyOptionPrice\" value=\""+realOptionPrice+"\"/>"+
                    "<input type=\"button\" value=\"삭제\" onclick=\"javascript:removeEL(\'"+realOptionName+"\')\"/>"+
                    "</div>";

                console.log("divElemOp : "+divElemOp);


                //$('div#'+indexOp+'-target').append($(divElemOp));
                console.log("append-op-target : " + $('#optionGroupModal').find('.modal-body').html());

                $('#optionGroupModal').find('.modal-body').append($(divElemOp));

                modalOp.find('input#optionName.form-control').val("");
                modalOp.find('input#optionPrice.form-control').val("");


            });

        });

        //modal창 안에서의 적용버튼 눌렀을 때 로직
        $(function(){

            var modalApply = $('#exampleModal');

            $(document).on("click", "#add-optionGroup", function(){
                // modalApply.find('#add-optionGroup').on("click", function(){
                //countOp++;
                // var happyOptionPrice = [];

                var applyOptionGroupName = modalApply.find('input[name="applyOptionGroupName"]').val();
                var applyOptionName = modalApply.find('input[name="applyOptionName"]').val();
                var applyOptionPrice = modalApply.find('input[name="applyOptionPrice"]').val();

                console.log(applyOptionGroupName +" : applyOptionGroupName");
                console.log(applyOptionName +" : applyOptionName");
                console.log(applyOptionPrice +" : applyOptionPrice");


                ///append를 위한 for문
                var optionNameCount = $('input[name="applyOptionName"]').length;



                for(var i=0; i<optionNameCount; i++){
                    var applyOptionGroupName = modalApply.find('input[name="applyOptionGroupName"]').val();
                    finalOptionName = ($('input[name="applyOptionName"]').eq(i).val());
                    finalOptionPrice = ($('input[name="applyOptionPrice"]').eq(i).val());



                    divElemApply1 = "</hr>"+
                        "<div class=\"form-group\" id=\"removeTarget"+applyOptionGroupName+"\">"+
                        " <label for=\"optionGroupName\" class=\"col-sm-offset-1 col-sm-3 control-label\">옵션그룹이름</label>"+
                        "<div class=\"col-sm-4\">"+
                        "<input type=\"text\" class=\"form-control\" id=\"optionGroupName\" name=\"optionGroupName\"  value=\""+applyOptionGroupName+"\" placeholder=\""+applyOptionGroupName+"\">"+
                        "</div>"+
                        "</div>"+
                        "</hr>";
                    divElemApply2 =  "<div class=\"form-group\" id=\"removeTarget"+applyOptionGroupName+"\">"+
                        " <label for=\"optionName\" class=\"col-sm-offset-1 col-sm-3 control-label\">옵션이름</label>"+
                        "<div class=\"col-sm-4\">"+
                        "<input type=\"text\" class=\"form-control\" id=\"optionName\" name=\"optionName\"  value=\""+finalOptionName+"\" placeholder=\""+finalOptionName+"\">"+
                        "</div>"+
                        "</div>"+
                        "</hr>"+
                        "<div class=\"form-group\" id=\"removeTarget"+applyOptionGroupName+"\">"+
                        " <label for=\"optionPrice\" class=\"col-sm-offset-1 col-sm-3 control-label\">옵션가격</label>"+
                        "<div class=\"col-sm-4\">"+
                        "<input type=\"text\" class=\"form-control\" id=\"optionPrice\" name=\"optionPrice\"  value=\""+finalOptionPrice+"\" placeholder=\""+finalOptionPrice+"\">"+
                        "</div>"+
                        "</div>"+
                        "<input type=\"button\" value=\"삭제\" id=\"removeTarget"+applyOptionGroupName+"\" onclick=\"javascript:removeELOption(\'"+applyOptionGroupName+"\')\"/>";


                    alert(i+"번째 optionPrice" + ($('input[name="applyOptionPrice"]').eq(i).val()));

                    $('#here').append(divElemApply1+divElemApply2);
                }

                forResetModal =

                    "<div class=\"modal-dialog modal-dialog-centered\">"+
                    "<div class=\"modal-content\">"+
                    "<div class=\"modal-header\">"+
                    "<h5 class=\"modal-title\" id=\"exampleModalLabel\">옵션그룹이름</h5>"+
                    "<button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"modal\" aria-label=\"Close\"></button>"+
                    "</div>"+
                    "<div class=\"modal-body\">"+
                    "<div class=\"form-group\">"+
                    "<label for=\"optionGroupName\" class=\"col-from-label\">옵션그룹이름</label>"+
                    "<input type=\"text\" class=\"form-control\" id=\"optionGroupName\" value=\"\">"+
                    "</div>"+
                    // "</div>"+
                    "<div class=\"modal-footer\">"+
                    //"<button type=\"button\" class=\"btn btn-primary custom\" onclick='applyOptionGroupNamer();'>옵션그룹이름적용</button>"+
                    "<button type=\"button\" class=\"btn btn-primary customer\" onclick=\'applyOptionGroupNamer()\' data-bs-toggle=\"modal\" data-bs-target=\"#optionModal\" data-whatever=\"option\">옵션추가</button>"+
                    "<button type=\"button\" class=\"btn btn-primary\" id=\"add-optionGroup\">적용</button>"+
                    "</div>"+
                    "</div>"+
                    // "</div>"+
                    "</div>";


                console.log("forresetmodal : " + $('#optionGroupModal').html());
                console.log("forResetModal 대체텍스트 : " + forResetModal);

                $('#optionGroupModal').html(forResetModal);

            });

        });

        function removeEL(idIndex){
            console.log("removeEL(옵션 삭제)");
            console.log("삭제 타겟 : " + $('div#'+idIndex+'.form-group').html());

            if(!confirm("옵션을 삭제하시겠습니까?")){

            }else{
                $('div#'+idIndex+'.form-group').remove();

            }

        }

        function removeELOption(idIndex){
            console.log("removeELOption(옵션그룹 삭제)");
            console.log("삭제 타겟 : " + $('div#removeTarget'+idIndex+'.form-group').html());

            // var removeTargetOG=[];
            // removeTargetOG=idIndex.split();
            // idIndex1 = idIndex.replace(/(\s*)/g, "\ ");




            if(!confirm("옵션 그룹"+idIndex+"을(를) 삭제하시겠습니까?")){

            }else{
                $('div#removeTarget'+idIndex+'.form-group').remove();
                $('input#removeTarget'+idIndex).remove();

            }

        }




    </script>


</head>
<body>
<%--<jsp:include page="/views/navbar.jsp" />--%>
<br>
<br>
<br>
<br>
<br>

<!--////////////////모달 옵션그룹 추가 시작////////////-->

<!--modal1(메뉴 추가)-->
<div class="modal fade" id="menuModal" aria-hidden="true" aria-labelledby="menuModalLabel" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="menuModalLabel">메뉴 추가</h5>

                <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!--//////////////////여기에 추가 메뉴 정보///////시이이이작//////////////////////////////////-->
                <form class="form-horizontal">
                    <input type="hidden" id = "menuTruckId" name="menuTruckId" value="${truck.truckId}">

                    <div class="form-group">
                        <label for="menuName" class="col-sm-offset-1 col-sm-10 control-label">메뉴 이름</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="menuName" name="menuName" value="${menu.menuName }" placeholder="메뉴 이름">

                        </div>
                    </div>

                    <div class="form-group">
                        <label for="menuDetail" class="col-sm-offset-1 col-sm-10 control-label">메뉴상세정보</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="menuDetail" name="menuDetail" value="${menu.menuDetail }" placeholder="메뉴상세정보">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="menuPrice" class="col-sm-offset-1 col-sm-10 control-label">메뉴 가격</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="menuPrice" name="menuPrice" value="${menu.menuPrice }" placeholder="메뉴 가격">
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="col-sm-10">

                            <div class="form-check form-switch" id="isThereSigMenu">
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="menuImg1" class="col-sm-offset-1 col-sm-10 control-label">메뉴 이미지1</label>
                        <div class="col-sm-10">
                            <input type="file" class="form-control" id="menuImg1" name="menuImg11"  value="${menu.menuImg1}" placeholder="메뉴 이미지1" onchange="setImage1Preview(event);">
                        </div>
                        <div id="image1preview" class="col-sm-10"></div>
                    </div>

                    <div class="form-group">
                        <label for="menuImg2" class="col-sm-offset-1 col-sm-10 control-label">메뉴 이미지2</label>
                        <div class="col-sm-10">
                            <input type="file" class="form-control" id="menuImg2" name="menuImg22"  value="${menu.menuImg2}" placeholder="메뉴 이미지2" onchange="setImage2Preview(event);">
                        </div>
                        <div id="image2preview" class="col-sm-10"></div>
                    </div>

                    <div class="form-group">
                        <label for="menuImg3" class="col-sm-offset-1 col-sm-10 control-label">메뉴 이미지3</label>
                        <div class="col-sm-10">
                            <input type="file" class="form-control" id="menuImg3" name="menuImg33"  value="${menu.menuImg3}" placeholder="메뉴 이미지3" onchange="setImage3Preview(event);">
                        </div>
                        <div id="image3preview" class="col-sm-10"></div>
                    </div>

                    <script>


                        function setImage1Preview(event){

                            var DIVimage1preview = $('#image1preview');
                            var isTherePreview = DIVimage1preview.find('img').length;
                            alert("isTherePreview : " + isTherePreview);
                            //이미지파일미리보기 이미 있으면 바꾸기 구현 중-  점심먹고 왔다! 다시 시작!
                            var reader  = new FileReader();

                            if(isTherePreview==0){

                            }else{

                                DIVimage1preview.find('img').remove();

                            }

                            reader.onload = function(event){
                                var img = document.createElement("img");

                                img.setAttribute("src", event.target.result);
                                img.setAttribute("style", "width:50%");
                                document.querySelector("div#image1preview").appendChild(img);

                            };

                            reader.readAsDataURL(event.target.files[0]);


                        }

                        function setImage2Preview(event){
                            var DIVimage2preview = $('#image2preview');
                            var isTherePreview = DIVimage2preview.find('img').length;
                            alert("isTherePreview : " + isTherePreview);
                            //이미지파일미리보기 이미 있으면 바꾸기 구현 중-  점심먹고 왔다! 다시 시작!
                            var reader  = new FileReader();

                            if(isTherePreview==0){

                            }else{

                                DIVimage2preview.find('img').remove();

                            }

                            reader.onload = function(event){
                                var img = document.createElement("img");

                                img.setAttribute("src", event.target.result);
                                img.setAttribute("style", "width:50%");
                                document.querySelector("div#image2preview").appendChild(img);

                            };

                            reader.readAsDataURL(event.target.files[0]);


                        }

                        function setImage3Preview(event){
                            var DIVimage3preview = $('#image3preview');
                            var isTherePreview = DIVimage3preview.find('img').length;
                            alert("isTherePreview : " + isTherePreview);
                            //이미지파일미리보기 이미 있으면 바꾸기 구현 중-  점심먹고 왔다! 다시 시작!
                            var reader  = new FileReader();

                            if(isTherePreview==0){

                            }else{

                                DIVimage3preview.find('img').remove();

                            }

                            reader.onload = function(event){
                                var img = document.createElement("img");

                                img.setAttribute("src", event.target.result);
                                img.setAttribute("style", "width:50%");
                                document.querySelector("div#image3preview").appendChild(img);

                            };

                            reader.readAsDataURL(event.target.files[0]);


                        }

                    </script>
                <!--//////////////////여기에 추가 메뉴 정보///////끄으으으읕//////////////////////////////////-->
                    <div id="here"></div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary customer" data-toggle="modal" data-target="#optionGroupModal" data-whatever="optionGroup" data-dismiss="modal" aria-label="Close">옵션그룹추가</button>
                <button type="button" class="btn btn-primary" id="add-menu" data-dismiss="modal" aria-label="Close">메뉴추가</button>
            </div>
        </div>
    </div>
</div>
<!--modal1(메뉴 추가 끝)-->

<%--<!--modal2(옵션그룹추가)-->--%>
<div class="modal fade" id="optionGroupModal" aria-hidden="true" aria-labelledby="optionGroupModalLabel" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="optionGroupModalLabel">옵션 그룹 추가</h5>
                <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!--옵션그룹추가 시이이이작-->
                <div class="form-group" id="rrrrrr" name="rrrrrr">
                    <label for="optionGroupName" class="col-from-label">옵션그룹이름</label>
                    <input type="text" class="form-control" id="optionGroupName" value="">
                </div>
                <!--옵션그룹추가 끄으으으읕-->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary addOption" data-target="#optionModal" data-dismiss="modal" aria-label="Close" onclick="applyOptionGroupNamer();" data-toggle="modal">옵션 추가</button>
                <button type="button" class="btn btn-primary addOptionGroup" id="add-optionGroup" data-dismiss="modal" aria-label="Close" data-target="#menuModal" data-toggle="modal">옵션 그룹 적용</button>
            </div>
        </div>
    </div>
</div>
<%--<!--modal2(옵션그룹추가 끝)-->--%>

<%--<!--modal3(옵션그룹추가)-->--%>
<div class="modal fade" id="optionModal" aria-hidden="true" aria-labelledby="optionModalLabel" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="optionModalLabel">옵션 추가</h5>
                <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!--옵션추가 시이이이이작-->
                <span>옵션 이름
                                <input type="text" class="form-control" id="optionName" value="${optionGroup.optionName}"></span>

                <span>옵션 가격</span>
                <input type="text" class="form-control" id="optionPrice" value="${optionGroup.optionPrice}" placeholder="옵션 가격 - 숫자를 입력해주세요.">
                <!--옵션추가 끄으으으으읕-->

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary addOption" data-dismiss="modal" aria-label="Close" data-target="#optionGroupModal" data-toggle="modal">옵션 적용</button>
            </div>
        </div>
    </div>
</div>
<%--<!--modal3(옵션그룹추가 끝)-->--%>

<!--모달 옵션그룹 추가 끝-->



<!--  화면구성 div Start /////////////////////////////////////-->
<div class="container">

    <div class="page-header">
        <h3 class="truckNameForMenu">${truck.truckName} 메뉴 관리</h3>
    </div>

    <!--메뉴 추가 버튼-->
    <a class="btn btn-warning" data-toggle="modal" href="#menuModal" role="button" >메뉴 추가</a>
    <hr/>




</div>
<!--  메뉴 목록 div Start /////////////////////////////////////-->


<div class="container-fluid content-row">
    <div class="row mb-3">

        <c:set var="i" value="0"/>
        <c:forEach var="menu" items="${list}">
            <c:set var="i" value="${i+1}"/>
            <div class="flex card h-100" style="width: 17rem; margin-bottom:15px; margin-left: 10px;">
                <img class="card-img-top" src="/resources/menu/${menu.menuImg1}" alt="Card image cap"
                     style="border-bottom: 1px solid #eee; height: 200px;">
                <div class="card-body" style="text:center ">
                    <h3 class="align-content-center"> <strong style="text:center;">${menu.menuName}</strong></h3>
                    <h3> ${menu.menuPrice}원</h3>
                    <ul class='card-body-ul'>
                        <h4>${menu.menuDetail}</h4>
                    </ul>
                    <div class="btn-detail">
                        <button class="button btn-warning" name="deleteMenu" onclick="deleteMenu(${menu.menuNo});">
                            메뉴 삭제하기
                            <input type="hidden" name="menuNo" value="${menu.menuNo}"/></button>
                        <button class="button is-warning is-light" name="getMenu"
                                style='margin-left: 100px; margin-bottom: 13px; height: 25px'
                                onclick="updateMenu(${menu.menuNo});"
                        >
                            메뉴 수정하기
                            <input type="hidden" name="menuNo" value="${menu.menuNo}"/>
                        </button>

                    </div>
                </div>
            </div>
            <%--</div>--%>
        </c:forEach>
    </div>

</div>
<!--  메뉴 목록 div End /////////////////////////////////////-->


</body>


<script>

    //메뉴 수정 클릭 시
    function updateMenu(menuNo){
        var menuNoo = menuNo;

        self.location="/menu/updateMenu?menuNo="+menuNoo;

    }

    function deleteMenu(menuNo){

        if(!confirm("정말 삭제하시겠습니까?(복구 불가)")){

        }else{
            $.ajax({
                url:"/menu/json/deleteMenu/"+menuNo,
                method:"get",
                success:function(data){
                    // console.log("")
                    alert("메뉴가 삭제되었습니다.");
                    location.reload();


                }
            })
        }

    }
</script>



</body>
</html>